import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import '../providers/financial_account_provider.dart';

class CashPocketCard extends ConsumerStatefulWidget {
  const CashPocketCard({super.key});

  @override
  ConsumerState<CashPocketCard> createState() => _CashPocketCardState();
}

class _CashPocketCardState extends ConsumerState<CashPocketCard>
    with SingleTickerProviderStateMixin {
  final _logger = Logger('CashPocketCard');
  late AnimationController _animationController;
  late Animation<double> _balanceAnimation;
  Decimal _previousBalance = Decimal.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _balanceAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Initial load of summary data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSummary();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateBalanceChange(Decimal newBalance) {
    final newBalanceDouble = newBalance.toDouble();
    final previousBalanceDouble = _previousBalance.toDouble();

    if (_previousBalance != newBalance) {
      _balanceAnimation =
          Tween<double>(
            begin: previousBalanceDouble,
            end: newBalanceDouble,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            ),
          );

      _animationController.reset();
      _animationController.forward();
      _previousBalance = newBalance;
    }
  }

  /// Load summary information (for profile card display)
  Future<void> _loadSummary() async {
    try {
      // Load data using financial accounts API
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
    } catch (e) {
      // Silently handle error, doesn't affect UI display
      _logger.info('Failed to load cash sources: $e');
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥ ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatLastUpdated(DateTime? dateTime) {
    if (dateTime == null) return 'Never updated';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(financialAccountProvider);

    // Trigger balance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateBalanceChange(state.effectiveTotalBalance);
    });

    return GestureDetector(
      onTap: () {
        // Navigate to account management on tap
        context.push('/forecast', extra: 1);
      },
      child: FCard(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'My Cash Pockets',
                        style: theme.typography.xl.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Balance display
              if (state.isLoading)
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading...',
                      style: theme.typography.sm.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                )
              else if (state.error != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Load Failed',
                      style: theme.typography.xl.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.error!,
                      style: theme.typography.sm.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated balance
                    AnimatedBuilder(
                      animation: _balanceAnimation,
                      builder: (context, child) {
                        return Text(
                          _formatCurrency(_balanceAnimation.value),
                          style: theme.typography.xl.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Update time and source count
                    Row(
                      children: [
                        Text(
                          'Last updated: ${_formatLastUpdated(state.lastUpdatedAt)}',
                          style: theme.typography.sm.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        if (state.accounts.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${state.accounts.length} Sources',
                              style: theme.typography.sm.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Update Now button
              FButton(
                style: FButtonStyle.outline(),
                onPress: () => context.push('/forecast', extra: 1),
                child: Text(
                  'Update Now',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
