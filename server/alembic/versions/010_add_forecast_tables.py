"""Add forecast support tables

Revision ID: 010
Revises: None
Create Date: 2025-12-21

This migration adds two tables for the financial forecasting feature:
1. account_daily_snapshots - Daily balance snapshots for high-performance time series analysis
2. ai_feedback_memory - User feedback on AI predictions for RAG context learning
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = '010'
down_revision: Union[str, None] = None 
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create forecast support tables."""

    # =========================================================================
    # 1. account_daily_snapshots - 每日账户余额快照表
    # 
    # 用途：高性能时间序列分析和图表绘制，避免实时聚合计算
    # 设计：适度反范式化（冗余 currency 和 user_uuid）以提升查询性能
    # =========================================================================
    op.create_table(
        'account_daily_snapshots',
        # 复合主键的一部分，使用 date 而非 timestamp，因为这是按"天"维度的汇总
        sa.Column('snapshot_date', sa.Date(), nullable=False,
                  comment='快照日期'),
        
        # 关联账户ID (UUID)
        sa.Column('account_id', postgresql.UUID(as_uuid=True), nullable=False,
                  comment='关联的 financial_accounts.id'),
        
        # 冗余 user_uuid，方便执行 "查询某用户所有资产曲线" 时不需要 Join account 表
        sa.Column('user_uuid', postgresql.UUID(as_uuid=True), nullable=False,
                  comment='冗余的用户 UUID，用于加速用户级查询'),
        
        # 当日结束时的最终余额（核心字段）
        sa.Column('balance', sa.Numeric(precision=20, scale=8), nullable=False,
                  comment='该账户在当日结束时的最终余额'),
        
        # 冗余货币代码，避免绘图时频繁回查 account 表
        sa.Column('currency', sa.String(length=3), nullable=False,
                  comment='货币代码，冗余自 financial_accounts'),
        
        # 当日总流入（用于绘制"收入支出流向图" Sankey Diagram）
        sa.Column('total_incoming', sa.Numeric(precision=20, scale=8), 
                  nullable=False, server_default='0',
                  comment='该账户当日所有收入交易的汇总'),
        
        # 当日总流出
        sa.Column('total_outgoing', sa.Numeric(precision=20, scale=8), 
                  nullable=False, server_default='0',
                  comment='该账户当日所有支出交易的汇总'),
        
        # 汇率快照（可选）：记录当天的基准汇率，方便后续计算"历史总资产（折合本币）"
        sa.Column('exchange_rate_snapshot', sa.Numeric(precision=20, scale=8), 
                  nullable=True,
                  comment='当日基准汇率快照，用于多币种资产折算'),
        
        # 记录创建时间，用于调试
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='记录创建时间'),
        
        # 复合主键：同一个账户在同一天只能有一条快照记录
        sa.PrimaryKeyConstraint('account_id', 'snapshot_date'),
        
        # 外键约束
        sa.ForeignKeyConstraint(
            ['account_id'], ['financial_accounts.id'],
            ondelete='CASCADE',
            name='fk_snapshots_account'
        ),
        sa.ForeignKeyConstraint(
            ['user_uuid'], ['users.uuid'],
            ondelete='CASCADE',
            name='fk_snapshots_user'
        ),
        
        comment='账户每日余额与流水快照表：用于高性能的时间序列分析和图表绘制'
    )
    
    # 索引：加速查询某用户特定时间段的资产曲线
    op.create_index(
        'idx_snapshots_user_date',
        'account_daily_snapshots',
        ['user_uuid', 'snapshot_date']
    )

    # =========================================================================
    # 2. ai_feedback_memory - AI 洞察反馈表
    # 
    # 用途：存储用户对 AI 预测和建议的交互反馈，构建个性化 RAG 上下文记忆
    # 设计：通用性强，支持多种洞察类型的反馈存储
    # =========================================================================
    op.create_table(
        'ai_feedback_memory',
        sa.Column('id', postgresql.UUID(as_uuid=True), nullable=False,
                  server_default=sa.text('gen_random_uuid()'),
                  comment='主键'),
        
        sa.Column('user_uuid', postgresql.UUID(as_uuid=True), nullable=False,
                  comment='用户 UUID'),
        
        # 洞察类型：区分 AI 是在做什么任务
        # 枚举值：SPENDING_FORECAST, ANOMALY_DETECTION, BUDGET_ADVICE, TAGGING_SUGGESTION
        sa.Column('insight_type', sa.String(length=50), nullable=False,
                  comment='洞察类型：SPENDING_FORECAST/ANOMALY_DETECTION/BUDGET_ADVICE 等'),
        
        # 关联的对象（可选）：如果 AI 是针对某笔具体交易或预算提出的建议
        sa.Column('target_table', sa.String(length=50), nullable=True,
                  comment='关联的表名：transactions/budgets/accounts'),
        
        sa.Column('target_id', postgresql.UUID(as_uuid=True), nullable=True,
                  comment='关联记录的 ID'),
        
        # AI 当时的原始输出快照（重要）：用于复盘 AI 为什么会这么说
        sa.Column('ai_content_snapshot', postgresql.JSONB(), nullable=False,
                  comment='AI 预测的原始内容快照，如 {"predicted_amount": 5000}'),
        
        # 用户反馈动作
        # 枚举值：THUMBS_UP, DISMISSED, CORRECTED, STOP_REMINDING
        sa.Column('user_action', sa.String(length=20), nullable=False,
                  comment='用户反馈：THUMBS_UP/DISMISSED/CORRECTED/STOP_REMINDING'),
        
        # 如果用户进行了修正，修正后的值存在这里
        sa.Column('user_correction_data', postgresql.JSONB(), nullable=True,
                  comment='用户修正的数据，如 {"corrected_amount": 3000}'),
        
        # 如果用户选择了 "不再提醒"，这里可以存储具体的忽略规则
        sa.Column('preference_rule', postgresql.JSONB(), nullable=True,
                  comment='用户偏好规则，如 {"ignore_category": "coffee"}'),
        
        # 是否已应用于系统学习（标记位，用于后续批处理优化）
        sa.Column('is_processed', sa.Boolean(), nullable=False,
                  server_default='false',
                  comment='是否已处理（用于批处理优化）'),
        
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='创建时间'),
        
        sa.PrimaryKeyConstraint('id'),
        
        sa.ForeignKeyConstraint(
            ['user_uuid'], ['users.uuid'],
            ondelete='CASCADE',
            name='fk_feedback_user'
        ),
        
        comment='AI 洞察反馈表：用于存储用户对 AI 预测和建议的反馈，构建个性化 RAG 上下文记忆'
    )
    
    # 索引：查询用户在特定类型下的偏好
    op.create_index(
        'idx_feedback_user_type',
        'ai_feedback_memory',
        ['user_uuid', 'insight_type']
    )

    # =========================================================================
    # 3. 创建存储过程：rebuild_account_snapshots
    # 
    # 用途：全量重算指定用户的每日余额快照
    # 触发：初始化或数据校正时调用
    # =========================================================================
    op.execute("""
        CREATE OR REPLACE FUNCTION public.rebuild_account_snapshots(target_user_uuid uuid)
        RETURNS void
        LANGUAGE plpgsql
        AS $function$
        BEGIN
            -- 1. 清理该用户的旧快照数据（防止重复叠加）
            DELETE FROM public.account_daily_snapshots 
            WHERE user_uuid = target_user_uuid;

            -- 2. 插入重新计算的数据
            INSERT INTO public.account_daily_snapshots (
                snapshot_date, 
                account_id, 
                user_uuid, 
                currency, 
                total_incoming, 
                total_outgoing, 
                balance
            )
            WITH 
            -- A. 获取该用户最早的交易日期，作为计算起点
            date_bounds AS (
                SELECT 
                    COALESCE(MIN(transaction_at::date), CURRENT_DATE - INTERVAL '1 year') as min_date,
                    CURRENT_DATE as max_date
                FROM public.transactions
                WHERE user_uuid = target_user_uuid
            ),
            
            -- B. 生成从"最早交易日"到"今天"的完整日期序列 (无间断)
            date_series AS (
                SELECT generate_series(min_date, max_date, '1 day')::date as day_date
                FROM date_bounds
            ),

            -- C. 汇总每日的流入流出 (按账户 + 日期聚合)
            daily_stats AS (
                SELECT 
                    ds.day_date,
                    acct.id as account_id,
                    acct.currency_code,
                    -- 计算流入：作为目标账户时的金额汇总
                    COALESCE(SUM(CASE WHEN t.target_account_id = acct.id THEN t.amount ELSE 0 END), 0) as incoming,
                    -- 计算流出：作为源账户时的金额汇总
                    COALESCE(SUM(CASE WHEN t.source_account_id = acct.id THEN t.amount ELSE 0 END), 0) as outgoing
                FROM public.financial_accounts acct
                CROSS JOIN date_series ds
                LEFT JOIN public.transactions t 
                    ON (t.source_account_id = acct.id OR t.target_account_id = acct.id)
                    AND t.transaction_at::date = ds.day_date
                    AND t.status = 'CLEARED'
                WHERE acct.user_uuid = target_user_uuid
                GROUP BY ds.day_date, acct.id, acct.currency_code
            ),

            -- D. 核心计算：使用窗口函数计算累计余额 (Running Total)
            running_balance AS (
                SELECT
                    ds.day_date,
                    acct.id as account_id,
                    acct.user_uuid,
                    acct.currency_code,
                    COALESCE(s.incoming, 0) as daily_in,
                    COALESCE(s.outgoing, 0) as daily_out,
                    -- 累计余额公式：初始余额 + (截止当天的总流入 - 截止当天的总流出)
                    acct.initial_balance + SUM(COALESCE(s.incoming, 0) - COALESCE(s.outgoing, 0)) 
                        OVER (PARTITION BY acct.id ORDER BY ds.day_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
                    as current_balance
                FROM date_series ds
                CROSS JOIN public.financial_accounts acct
                LEFT JOIN daily_stats s ON s.day_date = ds.day_date AND s.account_id = acct.id
                WHERE acct.user_uuid = target_user_uuid
            )

            -- E. 最终写入目标表
            SELECT 
                day_date, 
                account_id, 
                user_uuid, 
                currency_code, 
                daily_in, 
                daily_out, 
                current_balance
            FROM running_balance;

        END;
        $function$;

        COMMENT ON FUNCTION public.rebuild_account_snapshots IS 
            '全量重算指定用户的每日余额快照。建议在初始化或数据校正时调用。';
    """)


def downgrade() -> None:
    """Drop forecast support tables."""
    # 删除存储过程
    op.execute("DROP FUNCTION IF EXISTS public.rebuild_account_snapshots(uuid);")
    
    # 删除索引和表
    op.drop_index('idx_feedback_user_type', table_name='ai_feedback_memory')
    op.drop_table('ai_feedback_memory')
    
    op.drop_index('idx_snapshots_user_date', table_name='account_daily_snapshots')
    op.drop_table('account_daily_snapshots')
