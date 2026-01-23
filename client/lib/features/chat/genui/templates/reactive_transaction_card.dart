// TransactionCard - GenUI DataContext Reactive Version
//
// Fully refactored to use GenUI DataContext for reactive data binding.
// All state changes flow through DataModel, enabling:
// - Reactive updates via DataModelUpdate messages
// - Server-driven UI updates
// - Surface reuse for "modify existing UI" scenarios
//
// Architecture:
// 1. All display data comes from DataContext subscriptions
// 2. User interactions dispatch events to backend via dispatchEvent
// 3. Backend sends DataModelUpdate to update specific fields
// 4. Only affected widgets rebuild

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:go_router/go_router.dart';

import '../../../profile/models/financial_account.dart';
import '../../../profile/providers/financial_account_provider.dart';
import '../organisms/account_select_sheet.dart';
import '../atoms/atoms.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/constants/category_constants.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/i18n/strings.g.dart';

/// Reactive TransactionCard using GenUI DataContext
///
/// This widget uses DataContext subscriptions for reactive updates.
/// When backend sends DataModelUpdate, only the affected parts rebuild.
class ReactiveTransactionCard extends ConsumerStatefulWidget {
  /// The CatalogItemContext from GenUI widget builder
  final CatalogItemContext catalogContext;

  const ReactiveTransactionCard({super.key, required this.catalogContext});

  @override
  ConsumerState<ReactiveTransactionCard> createState() =>
      _ReactiveTransactionCardState();
}

class _ReactiveTransactionCardState
    extends ConsumerState<ReactiveTransactionCard> {
  // DataContext subscriptions - these return ValueNotifier for reactive updates
  late final ValueNotifier<double?> _amountNotifier;
  late final ValueNotifier<String?> _currencyNotifier;
  late final ValueNotifier<String?> _categoryKeyNotifier;
  late final ValueNotifier<String?> _timeNotifier;
  late final ValueNotifier<String?> _transactionTypeNotifier;
  late final ValueNotifier<String?> _transactionIdNotifier;
  late final ValueNotifier<List<Object?>?> _tagsNotifier;
  late final ValueNotifier<String?> _accountIdNotifier;
  late final ValueNotifier<String?> _accountNameNotifier;
  late final ValueNotifier<List<Object?>?> _spaceIdsNotifier;

  // UI state (local only, not part of DataModel)
  bool _isUpdating = false;
  bool _isUpdatingSpace = false;
  List<Map<String, dynamic>>? _cachedSpaces;

  DataContext get _dataContext => widget.catalogContext.dataContext;
  Map<String, dynamic> get _data =>
      widget.catalogContext.data as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    _initializeSubscriptions();
  }

  void _initializeSubscriptions() {
    // Subscribe to all fields that may change reactively
    // These paths should match the DataModel structure
    _amountNotifier = _dataContext.subscribe<double>(DataPath('/amount'));
    _currencyNotifier = _dataContext.subscribe<String>(DataPath('/currency'));
    _categoryKeyNotifier = _dataContext.subscribe<String>(
      DataPath('/category_key'),
    );
    _timeNotifier = _dataContext.subscribe<String>(DataPath('/time'));
    _transactionTypeNotifier = _dataContext.subscribe<String>(
      DataPath('/type'),
    );
    _transactionIdNotifier = _dataContext.subscribe<String>(
      DataPath('/transaction_id'),
    );
    _tagsNotifier = _dataContext.subscribe<List<Object?>>(DataPath('/tags'));
    _accountIdNotifier = _dataContext.subscribe<String>(
      DataPath('/linked_account/id'),
    );
    _accountNameNotifier = _dataContext.subscribe<String>(
      DataPath('/linked_account/name'),
    );
    _spaceIdsNotifier = _dataContext.subscribe<List<Object?>>(
      DataPath('/space_ids'),
    );

    // Initialize with static data as fallback
    _initializeFallbackValues();
  }

  void _initializeFallbackValues() {
    // If subscriptions return null, use direct data access
    if (_amountNotifier.value == null && _data.containsKey('amount')) {
      _amountNotifier.value = (_data['amount'] as num?)?.toDouble();
    }
    if (_currencyNotifier.value == null) {
      _currencyNotifier.value = _data['currency'] as String? ?? 'CNY';
    }
    if (_categoryKeyNotifier.value == null) {
      _categoryKeyNotifier.value = _data['category_key'] as String?;
    }
    if (_timeNotifier.value == null) {
      _timeNotifier.value = _data['time'] as String? ?? '';
    }
    if (_transactionTypeNotifier.value == null) {
      _transactionTypeNotifier.value =
          _data['type'] as String? ??
          _data['transaction_type'] as String? ??
          'EXPENSE';
    }
    if (_transactionIdNotifier.value == null) {
      _transactionIdNotifier.value = _data['transaction_id']?.toString();
    }
    if (_tagsNotifier.value == null && _data.containsKey('tags')) {
      _tagsNotifier.value = (_data['tags'] as List?)?.cast<Object?>();
    }

    // Handle linked_account
    final linkedAccount = _data['linked_account'];
    if (linkedAccount is Map) {
      if (_accountIdNotifier.value == null) {
        _accountIdNotifier.value = linkedAccount['id']?.toString();
      }
      if (_accountNameNotifier.value == null) {
        _accountNameNotifier.value = linkedAccount['name']?.toString();
      }
    } else {
      if (_accountIdNotifier.value == null) {
        _accountIdNotifier.value = _data['account_id'] as String?;
      }
      if (_accountNameNotifier.value == null) {
        _accountNameNotifier.value = _data['account_name'] as String?;
      }
    }

    // Handle space_ids
    if (_spaceIdsNotifier.value == null) {
      final spaceId = _data['space_id']?.toString();
      if (spaceId != null) {
        _spaceIdsNotifier.value = [spaceId];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // Use ValueListenableBuilder for reactive updates
    // Each builder only rebuilds when its specific data changes
    return ValueListenableBuilder<String?>(
      valueListenable: _transactionIdNotifier,
      builder: (context, transactionId, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _navigateToDetail(transactionId),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusHeader(theme, colors),
                _buildMainContent(theme, colors),
                _buildActionsFooter(theme, colors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusHeader(FThemeData theme, FColors colors) {
    return ValueListenableBuilder<String?>(
      valueListenable: _timeNotifier,
      builder: (context, time, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(FIcons.check, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                t.chat.genui.transactionCard.title,
                style: theme.typography.base.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _formatTimeOnly(time ?? ''),
                style: theme.typography.sm.copyWith(
                  color: colors.primary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(FThemeData theme, FColors colors) {
    // Multiple ValueListenableBuilders for fine-grained reactivity
    return ValueListenableBuilder<double?>(
      valueListenable: _amountNotifier,
      builder: (context, amount, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _transactionTypeNotifier,
          builder: (context, typeStr, _) {
            return ValueListenableBuilder<String?>(
              valueListenable: _categoryKeyNotifier,
              builder: (context, categoryKey, _) {
                return ValueListenableBuilder<String?>(
                  valueListenable: _currencyNotifier,
                  builder: (context, currency, _) {
                    return ValueListenableBuilder<List<Object?>?>(
                      valueListenable: _tagsNotifier,
                      builder: (context, tagsRaw, _) {
                        final categoryEnum = TransactionCategory.fromKey(
                          categoryKey,
                        );
                        final category = categoryEnum.displayText;
                        final isExpense =
                            (typeStr ?? 'EXPENSE').toUpperCase() == 'EXPENSE';
                        final transactionType = isExpense
                            ? TransactionType.expense
                            : TransactionType.income;
                        final tags = (tagsRaw ?? [])
                            .map((e) => e?.toString() ?? '')
                            .where((e) => e.isNotEmpty)
                            .toList();

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              ThemedIcon.large(icon: categoryEnum.icon),
                              const SizedBox(height: 16),
                              AmountText.large(
                                amount: amount ?? 0.0,
                                type: transactionType,
                                currency: currency ?? 'CNY',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category,
                                style: theme.typography.sm.copyWith(
                                  color: colors.mutedForeground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  alignment: WrapAlignment.center,
                                  children: tags
                                      .map((tag) => Tag(label: tag))
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActionsFooter(FThemeData theme, FColors colors) {
    return ValueListenableBuilder<String?>(
      valueListenable: _accountIdNotifier,
      builder: (context, accountId, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _accountNameNotifier,
          builder: (context, accountName, _) {
            return ValueListenableBuilder<List<Object?>?>(
              valueListenable: _spaceIdsNotifier,
              builder: (context, spaceIds, _) {
                final hasAccount = accountId != null && accountId.isNotEmpty;
                final linkedSpaces = (spaceIds ?? [])
                    .map((e) => e?.toString())
                    .where((e) => e != null && e.isNotEmpty)
                    .toList();
                final hasSpaces = linkedSpaces.isNotEmpty;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colors.muted.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionPill(
                          theme: theme,
                          colors: colors,
                          icon: hasAccount ? FIcons.wallet : FIcons.link,
                          label: hasAccount
                              ? accountName ??
                                    t
                                        .chat
                                        .genui
                                        .transactionCard
                                        .associatedAccount
                              : t.chat.genui.transactionCard.associate,
                          isActive: hasAccount,
                          activeColor: colors.primary,
                          isLoading: _isUpdating,
                          onTap: _isUpdating ? null : _showAccountSelector,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionPill(
                          theme: theme,
                          colors: colors,
                          icon: hasSpaces ? FIcons.users : FIcons.plus,
                          label: hasSpaces
                              ? '${linkedSpaces.length} ${t.chat.genui.transactionCard.sharedSpace}'
                              : t.chat.genui.transactionCard.sharedSpace,
                          isActive: hasSpaces,
                          activeColor: theme.semantic.sharedSpaceAccent,
                          isLoading: _isUpdatingSpace,
                          onTap: _isUpdatingSpace ? null : _showSpaceSelector,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActionPill({
    required FThemeData theme,
    required FColors colors,
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required bool isLoading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        unawaited(HapticFeedback.lightImpact());
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.1)
              : colors.muted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isActive ? activeColor : colors.mutedForeground,
                  ),
                ),
              )
            else
              Icon(
                icon,
                size: 14,
                color: isActive ? activeColor : colors.mutedForeground,
              ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: theme.typography.sm.copyWith(
                  color: isActive ? activeColor : colors.mutedForeground,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(String? transactionId) {
    if (transactionId == null || transactionId.isEmpty) {
      ToastService.showWarning(
        description: Text(t.chat.genui.transactionCard.missingId),
      );
      return;
    }
    unawaited(HapticFeedback.lightImpact());
    unawaited(
      context.pushNamed(
        AppRouteNames.transactionDetail,
        pathParameters: {'transactionId': transactionId},
      ),
    );
  }

  Future<void> _showAccountSelector() async {
    FocusScope.of(context).unfocus();

    var accountState = ref.read(financialAccountProvider);

    if (accountState.accounts.isEmpty && !accountState.isLoading) {
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
      if (!mounted) return;
      accountState = ref.read(financialAccountProvider);
    }

    final accountList = accountState.accounts;

    final accounts = accountList
        .where(
          (a) =>
              a.status == AccountStatus.active &&
              a.nature == FinancialNature.asset,
        )
        .map(
          (a) => {
            'id': a.id,
            'name': a.name,
            'type': a.type?.name ?? 'unknown',
          },
        )
        .toList();

    if (accounts.isEmpty) {
      if (!mounted) return;
      ToastService.show(
        description: Text(t.chat.genui.transactionCard.noAccount),
      );
      return;
    }

    if (!mounted) return;

    final selectedId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountSelectSheet(
        accounts: accounts,
        selectedId: _accountIdNotifier.value,
        title: t.chat.genui.transactionCard.selectAccount,
      ),
    );

    if (selectedId != null && selectedId != _accountIdNotifier.value) {
      await _updateAccount(selectedId, accounts);
    }
  }

  Future<void> _updateAccount(
    String accountId,
    List<Map<String, dynamic>> accounts,
  ) async {
    final transactionId = _transactionIdNotifier.value;
    if (transactionId == null) {
      ToastService.showWarning(
        description: Text(t.chat.genui.transactionCard.missingId),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final result = await _updateTransactionAccountApi(
        transactionId: transactionId,
        accountId: accountId,
      );

      if (result['code'] == 0) {
        String? accountName;
        for (final acc in accounts) {
          if (acc['id'] == accountId) {
            accountName = acc['name'] as String?;
            break;
          }
        }

        // Update via DataContext for reactive propagation
        _dataContext.update(DataPath('/linked_account/id'), accountId);
        _dataContext.update(DataPath('/linked_account/name'), accountName);

        setState(() => _isUpdating = false);

        if (!mounted) return;
        ToastService.success(
          description: Text(
            t.chat.genui.transactionCard.associatedTo(
              name: accountName ?? t.financial.title,
            ),
          ),
        );

        unawaited(
          ref.read(financialAccountProvider.notifier).loadFinancialAccounts(),
        );
      } else {
        throw Exception(result['message'] ?? t.financial.saveFailed);
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      if (!mounted) return;
      ToastService.showDestructive(
        description: Text(
          t.chat.genui.transactionCard.updateFailed(error: e.toString()),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _updateTransactionAccountApi({
    required String transactionId,
    required String accountId,
  }) async {
    final networkClient = ref.read(networkClientProvider);
    final result = await networkClient.requestMap(
      '/transactions/$transactionId/account',
      method: HttpMethod.patch,
      data: {'account_id': accountId},
    );
    return result;
  }

  Future<void> _showSpaceSelector() async {
    FocusScope.of(context).unfocus();

    final theme = context.theme;
    final colors = theme.colors;

    if (_cachedSpaces == null) {
      try {
        final networkClient = ref.read(networkClientProvider);
        final result = await networkClient.requestMap(
          '/shared-spaces',
          method: HttpMethod.get,
        );

        if (result['code'] == 0 && result['data'] != null) {
          final data = result['data'] as Map<String, dynamic>;
          _cachedSpaces = (data['spaces'] as List? ?? [])
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        } else {
          _cachedSpaces = [];
        }
      } catch (e) {
        _cachedSpaces = [];
      }
    }

    if (_cachedSpaces!.isEmpty) {
      if (!mounted) return;
      ToastService.show(
        description: Text(t.chat.genui.transactionCard.noSpace),
      );
      return;
    }

    if (!mounted) return;

    final currentSpaceIds = (_spaceIdsNotifier.value ?? [])
        .map((e) => e?.toString())
        .where((e) => e != null)
        .toList();

    final selectedSpaceId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.chat.genui.transactionCard.selectSpace,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cachedSpaces!.length,
                itemBuilder: (context, index) {
                  final space = _cachedSpaces![index];
                  final spaceId = space['id']?.toString();
                  final isSelected = currentSpaceIds.contains(spaceId);
                  return ListTile(
                    leading: Icon(
                      FIcons.users,
                      color: isSelected
                          ? colors.primary
                          : colors.mutedForeground,
                    ),
                    title: Text((space['name'] as String?) ?? ''),
                    trailing: isSelected
                        ? Icon(FIcons.check, color: colors.primary)
                        : null,
                    onTap: () => Navigator.pop(context, spaceId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedSpaceId != null && mounted) {
      await _updateTransactionSpace(selectedSpaceId);
    }
  }

  Future<void> _updateTransactionSpace(String spaceId) async {
    final transactionId = _transactionIdNotifier.value;
    if (transactionId == null) {
      ToastService.showWarning(
        description: Text(t.chat.genui.transactionCard.missingId),
      );
      return;
    }

    setState(() => _isUpdatingSpace = true);

    try {
      final networkClient = ref.read(networkClientProvider);
      await networkClient.requestMap(
        '/shared-spaces/$spaceId/transactions',
        method: HttpMethod.post,
        data: {'transaction_id': transactionId},
      );

      // Update via DataContext
      final currentSpaceIds = (_spaceIdsNotifier.value ?? [])
          .map((e) => e?.toString())
          .where((e) => e != null && e.isNotEmpty)
          .toList();
      if (!currentSpaceIds.contains(spaceId)) {
        _dataContext.update(DataPath('/space_ids'), [
          ...currentSpaceIds,
          spaceId,
        ]);
      }

      setState(() => _isUpdatingSpace = false);

      if (!mounted) return;
      ToastService.success(
        description: Text(t.chat.genui.transactionCard.linkedToSpace),
      );
    } catch (e) {
      setState(() => _isUpdatingSpace = false);
      if (!mounted) return;
      ToastService.showDestructive(
        description: Text(
          t.chat.genui.transactionCard.updateFailed(error: e.toString()),
        ),
      );
    }
  }

  String _formatTimeOnly(String isoTime) {
    if (isoTime.isEmpty) {
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
    try {
      final dateTime = DateTime.parse(isoTime);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
