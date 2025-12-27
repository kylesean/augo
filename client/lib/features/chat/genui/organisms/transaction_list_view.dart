import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/themed_icon.dart';
import '../../../home/services/home_service.dart';
import '../../../home/models/transaction_model.dart';
import '../../../../core/constants/category_constants.dart';

/// 交易列表视图组件
///
/// Layer 3 (Organism) 组件，支持瀑布流分页加载。
/// 用于底部弹窗等场景中展示完整交易列表。
class TransactionListView extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  /// 每页加载数量
  final int pageSize;

  const TransactionListView({
    super.key,
    required this.data,
    this.pageSize = 10,
  });

  @override
  ConsumerState<TransactionListView> createState() =>
      _TransactionListViewState();
}

class _TransactionListViewState extends ConsumerState<TransactionListView> {
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

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final homeService = ref.read(homeServiceProvider);

      String? typesString;
      final rawTypes = _searchMetadata?['transaction_types'];
      if (rawTypes is List) {
        typesString = rawTypes.join(',');
      }

      final result = await homeService.searchTransactions(
        page: _currentPage + 1,
        size: widget.pageSize,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme, colors),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
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
              separatorBuilder: (context, index) => Container(
                height: 1,
                margin: const EdgeInsets.only(left: 56),
                color: colors.muted.withValues(alpha: 0.5),
              ),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildLoadMoreIndicator(theme, colors);
                }
                final item = _items[index] as Map<String, dynamic>;
                return _TransactionListItem(
                  data: item,
                  onTap: () {
                    final id = item['id'] as String?;
                    if (id != null) {
                      context.push('/home/transaction/$id');
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    final loadedCount = _items.length;
    final hasMoreToLoad = loadedCount < _total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colors.muted.withValues(alpha: 0.2)),
      child: Row(
        children: [
          Icon(FIcons.list, color: colors.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            t.chat.genui.transactionList.searchResults(
              count: _total.toString(),
            ),
            style: theme.typography.base.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            hasMoreToLoad
                ? t.chat.genui.transactionList.loaded(
                    count: loadedCount.toString(),
                  )
                : t.chat.genui.transactionList.allLoaded,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              t.chat.genui.transactionList.loadMore,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
    );
  }
}

/// 交易列表项 - 复用现有逻辑但更简洁
class _TransactionListItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const _TransactionListItem({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = data['currency'] as String? ?? 'CNY';
    final categoryKey = data['category'] as String?;
    final categoryEnum = TransactionCategory.fromKey(categoryKey);
    final tags =
        (data['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final type = (data['type'] as String? ?? 'EXPENSE').toUpperCase();
    final time = data['transaction_time'] as String? ?? '';

    final isExpense = type == 'EXPENSE';
    final isIncome = type == 'INCOME';

    final transactionType = isExpense
        ? TransactionType.expense
        : (isIncome ? TransactionType.income : TransactionType.transfer);

    return InkWell(
      onTap: onTap,
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
                      // 优先使用后端 display，否则 fallback 到客户端计算
                      data['display'] != null
                          ? AmountText.fromDisplay(
                              display: data['display'] as Map<String, dynamic>,
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
                              : (data['description'] ?? ''),
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
            const SizedBox(width: 8),
            Icon(
              FIcons.chevronRight,
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
