"""Transaction management API endpoints."""

from typing import Any
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from fastapi_pagination import Params
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.user import User
from app.schemas.transaction import (
    BatchCreateTransactionRequest,
    CashFlowForecastRequest,
    CashFlowForecastResponse,
    CommentCreateRequest,
    CommentResponse,
    RecurringTransactionCreateRequest,
    RecurringTransactionResponse,
    RecurringTransactionUpdateRequest,
    TransactionDisplayValue,
    UpdateAccountRequest,
    UpdateBatchAccountRequest,
)
from app.services.transaction_service import TransactionService
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

router = APIRouter(prefix="/transactions", tags=["transactions"])


def _transaction_to_dict(tx: Any, display_currency: str = "CNY", exchange_rate: float = 1.0) -> dict[str, Any]:
    """统一的交易模型转字典辅助函数

    返回格式包含：
    - amount: 换算到 display_currency 的金额（用于统一展示）
    - amountOriginal: 原始记录金额（不可变）
    - originalCurrency: 原始记录货币（不可变）
    - exchangeRate: 记账时的汇率快照（不可变）
    """
    from app.services.transaction_query_service import TransactionItem

    # helper to get value from either object or dict
    def get_val(obj: Any, attr: str, key: str | None = None) -> Any:
        if key is None:
            key = attr
        if isinstance(obj, dict):
            return obj.get(key)
        return getattr(obj, attr, None)

    # 1. 如果已经是经过完整格式化的字典（通常由 Service 层返回），直接返回
    if isinstance(tx, dict) and ("userUuid" in tx or "display" in tx):
        return tx

    # 2. 识别输入源并决定是否换算
    # 如果输入已经是 TransactionItem (Pydantic模型)，说明 Service 层已经做过换算了
    is_already_converted = isinstance(tx, TransactionItem)

    tx_id = str(get_val(tx, "id"))
    tx_type = get_val(tx, "type")

    # 获取原始金额和货币（历史数据，不可变）
    amount_original = float(
        get_val(tx, "amount_original") or get_val(tx, "amountOriginal") or get_val(tx, "amount") or 0
    )
    original_currency = get_val(tx, "currency") or "CNY"
    stored_exchange_rate = get_val(tx, "exchange_rate") or get_val(tx, "exchangeRate")

    # 获取已换算到本位币的金额
    amount_val = float(get_val(tx, "amount") or 0)

    # 3. 执行换算 (仅对未换算的本位币数据进行)
    # 如果已经换算过，或者目标是本位币且输入也是本位币，则跳过
    if not is_already_converted and display_currency != BASE_CURRENCY:
        amount_val = amount_val * exchange_rate

    return {
        "id": tx_id,
        "userUuid": str(get_val(tx, "user_uuid") or get_val(tx, "userUuid")),
        "type": tx_type,
        # 换算后的展示金额（用于统一列表展示）
        "amount": round(amount_val, 2),
        "currency": display_currency,
        # 原始记录信息（历史数据，不可变）
        "amountOriginal": round(amount_original, 2),
        "originalCurrency": original_currency,
        "exchangeRate": str(stored_exchange_rate) if stored_exchange_rate else None,
        # 其他字段
        "categoryKey": get_val(tx, "category_key") or get_val(tx, "categoryKey"),
        "description": get_val(tx, "description") or "",
        "rawInput": get_val(tx, "raw_input") or get_val(tx, "rawInput") or "",
        "transactionAt": get_val(tx, "transaction_at").isoformat()
        if hasattr(get_val(tx, "transaction_at"), "isoformat")
        else get_val(tx, "transaction_at"),
        "transactionTimezone": get_val(tx, "transaction_timezone")
        or get_val(tx, "transactionTimezone")
        or "Asia/Shanghai",
        "tags": get_val(tx, "tags") or [],
        "status": get_val(tx, "status") or "CLEARED",
        "location": get_val(tx, "location"),
        "sourceAccountId": str(get_val(tx, "source_account_id")) if get_val(tx, "source_account_id") else None,
        "targetAccountId": str(get_val(tx, "target_account_id")) if get_val(tx, "target_account_id") else None,
        "createdAt": get_val(tx, "created_at").isoformat()
        if hasattr(get_val(tx, "created_at"), "isoformat")
        else get_val(tx, "created_at"),
        "display": TransactionDisplayValue.from_params(
            amount=amount_val, tx_type=tx_type, currency=display_currency
        ).model_dump(by_alias=False),
    }


@router.get("")
async def get_transactions(
    page: int = 1,
    size: int = 20,
    date: str | None = None,  # YYYY-MM-DD format
    transaction_type: str | None = None,  # EXPENSE, INCOME, TRANSFER
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Retrieve Transaction List (Feed Stream)
       Supports filtering by date and transaction type, returns a list of transactions with display calculated fields.

    Args:
        page: Page number, default is 1
        size: Number of items per page, default is 20
        date: Optional, date in YYYY-MM-DD format for filtering
        transaction_type: Optional, transaction type (EXPENSE, INCOME, TRANSFER)
        current_user: Current user
        db: Database session

    Returns:
        Unified format pagination response, containing display fields
    """
    from app.core.responses import error_response, get_error_code_int, success_response
    from app.services.transaction_query_service import (
        TransactionQueryParams,
        TransactionQueryService,
        TransactionType,
    )

    try:
        # 构建查询参数
        params = TransactionQueryParams(
            date=date,
            transaction_types=[TransactionType(transaction_type.upper())] if transaction_type else None,
            page=page,
            per_page=size,
        )

        # 使用共享服务执行查询
        service = TransactionQueryService(db)
        # 注意：这里我们获取原始数据，然后在 API 层应用换算（或者获取已换算的并直接返回）
        # 为了避免 get_transactions 和 search_transactions 逻辑不一致，我们在下面统一处理
        result = await service.search(str(current_user.uuid), params)

        # 获取汇率和用户偏好币种
        display_currency = await get_user_display_currency(db, current_user.uuid)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # 在此处重新映射，确保使用的是最新的换算逻辑，且 items 里的每一个 tx 都是 Transaction 对象或 Model
        return success_response(
            data={
                "items": [_transaction_to_dict(item, display_currency, exchange_rate) for item in result.items],
                "page": result.page,
                "size": result.per_page,
                "total": result.total,
                "pages": result.pages,
                "hasMore": result.has_more,
            },
            message="Transactions retrieved successfully",
        )
    except Exception:
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve transactions",
            http_status=500,
        )


@router.get("/search")
async def search_transactions(
    params: Params = Depends(),
    keyword: str | None = None,
    min_amount: str | None = None,
    max_amount: str | None = None,
    category_keys: str | None = None,
    tags: str | None = None,
    start_date: str | None = None,
    end_date: str | None = None,
    transaction_type: str | None = None,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """搜索交易记录

    使用 fastapi-pagination 进行标准分页，支持多种过滤条件。

    Args:
        params: 分页参数
        keyword: 关键词搜索（描述、位置）
        min_amount: 最小金额（字符串格式）
        max_amount: 最大金额（字符串格式）
        category_keys: 分类键（逗号分隔）
        tags: 标签（逗号分隔）
        start_date: 开始日期（ISO 8601）
        end_date: 结束日期（ISO 8601）
        transaction_type: 交易类型
        current_user: 当前用户
        db: 数据库会话

    Returns:
        统一格式的分页响应
    """
    from datetime import datetime
    from decimal import Decimal

    from fastapi_pagination.ext.sqlalchemy import apaginate
    from sqlalchemy import and_, desc, or_, select

    from app.core.responses import error_response, get_error_code_int, success_response
    from app.models.transaction import Transaction

    try:
        # 构建基础查询
        conditions = [Transaction.user_uuid == current_user.uuid]

        # 添加过滤条件
        if keyword:
            conditions.append(
                or_(Transaction.description.ilike(f"%{keyword}%"), Transaction.location.ilike(f"%{keyword}%"))
            )

        if min_amount is not None:
            try:
                min_val = Decimal(min_amount)
                conditions.append(Transaction.amount >= min_val)
            except (ValueError, TypeError):
                pass

        if max_amount is not None:
            try:
                max_val = Decimal(max_amount)
                conditions.append(Transaction.amount <= max_val)
            except (ValueError, TypeError):
                pass

        if category_keys:
            keys = [k.strip() for k in category_keys.split(",")]
            conditions.append(Transaction.category_key.in_(keys))  # type: ignore

        if tags:
            tag_list = [t.strip() for t in tags.split(",")]
            # PostgreSQL JSONB contains check
            for tag in tag_list:
                conditions.append(Transaction.tags.contains([tag]))

        if start_date:
            try:
                start_dt = datetime.fromisoformat(start_date.replace("Z", "+00:00"))
                conditions.append(Transaction.transaction_at >= start_dt)
            except ValueError:
                pass

        if end_date:
            try:
                end_dt = datetime.fromisoformat(end_date.replace("Z", "+00:00"))
                conditions.append(Transaction.transaction_at <= end_dt)
            except ValueError:
                pass

        if transaction_type:
            conditions.append(Transaction.type == transaction_type.upper())

        # 构建查询
        query = select(Transaction).where(and_(*conditions)).order_by(Transaction.transaction_at.desc())

        # 获取汇率和用户偏好币种
        display_currency = await get_user_display_currency(db, current_user.uuid)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # 使用 fastapi-pagination 分页
        page_result = await apaginate(
            db,
            query,
            params=params,
            transformer=lambda items: [_transaction_to_dict(t, display_currency, exchange_rate) for t in items],
        )

        # 返回统一格式
        return success_response(
            data={
                "items": page_result.items,
                "page": page_result.page,
                "size": page_result.size,
                "total": page_result.total,
                "pages": page_result.pages,
                "has_more": page_result.page < page_result.pages if page_result.pages else False,
            },
            message="Transactions searched successfully",
        )
    except Exception:
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to search transactions",
            http_status=500,
        )


@router.get("/{transaction_id:uuid}")
async def get_transaction_detail(
    transaction_id: UUID,  # UUID from path
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """获取交易详情"""
    service = TransactionService(db)
    transaction_data = await service.get_transaction_detail(transaction_id, current_user.uuid)

    if not transaction_data:
        return error_response(
            code=get_error_code_int("NOT_FOUND"),
            message="Transaction not found",
            http_status=status.HTTP_404_NOT_FOUND,
        )

    return success_response(
        data=transaction_data,
        message="Transaction retrieved successfully",
    )


@router.delete("/{transaction_id:uuid}", status_code=status.HTTP_200_OK)
async def delete_transaction(
    transaction_id: UUID,  # UUID from path
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """删除交易记录"""
    from app.core.exceptions import BusinessError, NotFoundError

    service = TransactionService(db)
    try:
        await service.delete_transaction(transaction_id, current_user.uuid)
        return success_response(
            data=None,
            message="Transaction deleted successfully",
        )
    except NotFoundError:
        return error_response(
            code=get_error_code_int("NOT_FOUND"),
            message="Transaction not found",
            http_status=status.HTTP_404_NOT_FOUND,
        )
    except BusinessError as e:
        return error_response(
            code=get_error_code_int("FORBIDDEN"),
            message=str(e),
            http_status=status.HTTP_403_FORBIDDEN,
        )


@router.patch("/{transaction_id:uuid}/account")
async def update_transaction_account(
    transaction_id: UUID,
    request: UpdateAccountRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """更新交易的关联账户

    支持：
    - 关联账户：传入 account_id
    - 取消关联：传入 null
    - 更换账户：传入新的 account_id（会自动回滚旧账户余额并更新新账户）
    """
    from app.core.exceptions import BusinessError, NotFoundError

    service = TransactionService(db)
    try:
        result = await service.update_transaction_account(
            transaction_id=transaction_id,
            user_uuid=current_user.uuid,
            account_id=UUID(request.account_id) if request.account_id else None,
        )
        return success_response(
            data=result,
            message="Transaction account updated successfully",
        )
    except NotFoundError:
        return error_response(
            code=get_error_code_int("NOT_FOUND"),
            message="Transaction or account not found",
            http_status=status.HTTP_404_NOT_FOUND,
        )
    except BusinessError as e:
        return error_response(
            code=get_error_code_int("FORBIDDEN"),
            message=str(e),
            http_status=status.HTTP_403_FORBIDDEN,
        )


@router.post("/batch")
async def create_batch_transactions(
    request: BatchCreateTransactionRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """批量创建交易记录"""
    service = TransactionService(db)
    result = await service.create_batch_transactions(
        user_uuid=current_user.uuid,
        data=request.model_dump(),
    )
    return success_response(
        data=result,
        message="Batch transactions created successfully",
    )


@router.patch("/batch/account")
async def update_batch_transactions_account(
    request: UpdateBatchAccountRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """批量更新交易的关联账户"""
    from app.core.exceptions import BusinessError, NotFoundError

    service = TransactionService(db)
    try:
        result = await service.update_batch_transactions_account(
            user_uuid=current_user.uuid,
            transaction_ids=[UUID(tid) for tid in request.transaction_ids],
            account_id=UUID(request.account_id) if request.account_id else None,
        )
        return success_response(
            data=result,
            message="Batch transactions account updated successfully",
        )
    except (NotFoundError, BusinessError) as e:
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message=str(e),
            http_status=status.HTTP_400_BAD_REQUEST,
        )


@router.get("/{transaction_id:uuid}/comments", response_model=list[CommentResponse])
async def get_transaction_comments(
    transaction_id: UUID,  # UUID from path
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """获取交易评论列表"""
    service = TransactionService(db)
    comments = await service.get_comments_for_transaction(transaction_id, current_user.uuid)
    return success_response(
        data=comments,
        message="Comments retrieved successfully",
    )


@router.post("/{transaction_id:uuid}/comments", response_model=CommentResponse)
async def add_transaction_comment(
    transaction_id: UUID,  # UUID from path
    request: CommentCreateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """添加交易评论"""
    service = TransactionService(db)
    comment = await service.add_comment(
        transaction_id=transaction_id,
        user_uuid=current_user.uuid,
        comment_text=request.comment_text,
        parent_comment_id=request.parent_comment_id,
    )
    return success_response(
        data=comment,
        message="Comment added successfully",
    )


@router.delete("/comments/{comment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_transaction_comment(
    comment_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """删除交易评论"""
    service = TransactionService(db)
    success = await service.delete_comment(comment_id, current_user.uuid)

    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Comment not found",
        )

    return success_response(
        data=None,
        message="Comment deleted successfully",
    )


@router.get("/recurring")
async def list_recurring_transactions(
    type: str | None = None,  # EXPENSE, INCOME, TRANSFER
    is_active: bool | None = None,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """获取周期性交易列表

    Args:
        type: 可选，交易类型过滤 (EXPENSE, INCOME, TRANSFER)
        is_active: 可选，激活状态过滤
        current_user: 当前用户
        db: 数据库会话

    Returns:
        周期性交易列表
    """
    service = TransactionService(db)
    recurring_txs = await service.list_recurring_transactions(
        current_user.uuid,
        type_filter=type,
        is_active=is_active,
    )
    return success_response(
        data=recurring_txs,
        message="Recurring transactions retrieved successfully",
    )


@router.post("/recurring", response_model=RecurringTransactionResponse)
async def create_recurring_transaction(
    request: RecurringTransactionCreateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """创建周期性交易"""
    service = TransactionService(db)
    recurring_tx = await service.create_recurring_transaction(current_user.uuid, request.model_dump())
    return success_response(
        data=recurring_tx,
        message="Recurring transaction created successfully",
    )


@router.get("/recurring/{recurring_id:uuid}", response_model=RecurringTransactionResponse)
async def get_recurring_transaction(
    recurring_id: UUID,  # UUID from path
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """获取周期性交易详情"""
    service = TransactionService(db)
    recurring_tx = await service.get_recurring_transaction(recurring_id, current_user.uuid)

    if not recurring_tx:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recurring transaction not found",
        )

    return success_response(
        data=recurring_tx,
        message="Recurring transaction retrieved successfully",
    )


@router.put("/recurring/{recurring_id:uuid}", response_model=RecurringTransactionResponse)
async def update_recurring_transaction(
    recurring_id: UUID,  # UUID from path
    request: RecurringTransactionUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """更新周期性交易"""
    service = TransactionService(db)
    recurring_tx = await service.update_recurring_transaction(
        recurring_id, current_user.uuid, request.model_dump(exclude_unset=True)
    )

    if not recurring_tx:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recurring transaction not found",
        )

    return success_response(
        data=recurring_tx,
        message="Recurring transaction updated successfully",
    )


@router.delete("/recurring/{recurring_id:uuid}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_recurring_transaction(
    recurring_id: UUID,  # UUID from path
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """删除周期性交易"""
    service = TransactionService(db)
    success = await service.delete_recurring_transaction(recurring_id, current_user.uuid)

    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recurring transaction not found",
        )

    return success_response(
        data=None,
        message="Recurring transaction deleted successfully",
    )


@router.post("/forecast", response_model=CashFlowForecastResponse)
async def forecast_cash_flow(
    request: CashFlowForecastRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """现金流预测"""
    service = TransactionService(db)
    forecast = await service.forecast_cash_flow(
        user_uuid=current_user.uuid,
        forecast_days=request.forecast_days,
        granularity=request.granularity,
        scenarios=request.scenarios,
    )
    return success_response(
        data=forecast,
        message="Cash flow forecast generated successfully",
    )
