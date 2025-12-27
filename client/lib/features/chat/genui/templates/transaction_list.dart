import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'package:augo/features/home/services/home_service.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../../../core/constants/category_constants.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'dart:async';

/// 交易列表组件 - 支持瀑布流分页加载
class TransactionList extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TransactionList({super.key, required this.data});

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  late List<dynamic> _items;
  late int _currentPage;
  late bool _hasMore;
  late int _total;
  bool _isLoadingMore = false;

  // 缓存搜索参数，用于翻页
  Map<String, dynamic>? _searchMetadata;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final d = widget.data;
    _items = List.from(d['items'] as List<dynamic>? ?? []);
    _total = (d['total'] as num?)?.toInt() ?? 0;
    _currentPage = (d['page'] as num?)?.toInt() ?? 1;
    _hasMore = d['has_more'] as bool? ?? false;
    _searchMetadata = d['metadata'] as Map<String, dynamic>?;
  }

  // 监听并执行翻页
  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final homeService = ref.read(homeServiceProvider);

      // 提取转换 transaction_types
      String? typesString;
      final rawTypes = _searchMetadata?['transaction_types'];
      if (rawTypes is List) {
        typesString = rawTypes.join(',');
      }

      final result = await homeService.searchTransactions(
        page: _currentPage + 1,
        size: (widget.data['per_page'] as num?)?.toInt() ?? 10,
        keyword: _searchMetadata?['keyword'],
        startDate: _searchMetadata?['start_date'],
        endDate: _searchMetadata?['end_date'],
        type: typesString,
      );

      if (mounted) {
        setState(() {
          final newItems = result['items'] as List<dynamic>? ?? [];
          _items.addAll(newItems);
          _currentPage =
              (result['page'] as num?)?.toInt() ?? (_currentPage + 1);
          _hasMore = result['has_more'] as bool? ?? false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
      debugPrint('Error loading more transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (_items.isEmpty) {
      return _buildEmptyState(theme, colors);
    }

    // 在 Modal 内部时，使用 Column + Expanded 填充空间
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部：摘要
        _buildHeader(theme, colors),

        // 列表内容 - 占满剩余空间
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoadingMore &&
                  _hasMore &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                _loadMore();
              }
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _items.length + (_hasMore ? 1 : 0),
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 56,
                color: colors.muted.withValues(alpha: 0.5),
              ),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildLoadMoreIndicator(theme, colors);
                }
                final item = _items[index] as Map<String, dynamic>;
                return _buildTransactionItem(context, theme, colors, item);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colors.muted.withValues(alpha: 0.2)),
      child: Row(
        children: [
          Icon(FIcons.list, color: colors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            t.chat.genui.transactionList.searchResults(count: _total),
            style: theme.typography.base.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (_items.length < _total)
            Text(
              t.chat.genui.transactionList.loaded(count: _items.length),
              style: theme.typography.sm.copyWith(
                color: colors.primary.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(FIcons.search, size: 48, color: colors.mutedForeground),
          const SizedBox(height: 16),
          Text(
            t.chat.genui.transactionList.noResults,
            style: theme.typography.base.copyWith(
              color: colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primary,
              ),
            )
          : Text(
              _hasMore
                  ? t.chat.genui.transactionList.loadMore
                  : t.chat.genui.transactionList.allLoaded,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> item,
  ) {
    final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = item['currency'] as String? ?? 'CNY';
    final categoryKey = item['category'] as String?;
    final categoryEnum = TransactionCategory.fromKey(categoryKey);
    final tags =
        (item['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final type = (item['type'] as String? ?? 'EXPENSE').toUpperCase();
    final time = item['transaction_time'] as String? ?? '';

    final isExpense = type == 'EXPENSE';
    final isIncome = type == 'INCOME';

    final transactionType = isExpense
        ? TransactionType.expense
        : (isIncome ? TransactionType.income : TransactionType.transfer);
    final transactionId = item['id'] as String?;

    return InkWell(
      onTap: transactionId != null
          ? () => context.push('/home/transaction/$transactionId')
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemedIcon.large(icon: categoryEnum.icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryEnum.displayText,
                        style: theme.typography.base.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // 使用统一的 AmountText 组件
                      item['display'] != null
                          ? AmountText.fromDisplay(
                              display: item['display'] as Map<String, dynamic>,
                              type: transactionType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : AmountText(
                              amount: amount,
                              type: transactionType,
                              currency: currency,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tags.isNotEmpty
                              ? tags.join(' · ')
                              : (item['description'] ?? ''),
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(time),
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 添加右箭头指示可点击
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: colors.mutedForeground.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoTime) {
    if (isoTime.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(isoTime);
      return '${dateTime.month}/${dateTime.day}';
    } catch (e) {
      return '';
    }
  }
}
