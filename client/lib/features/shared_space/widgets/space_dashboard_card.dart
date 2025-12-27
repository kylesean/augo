import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../models/shared_space_models.dart';

class SpaceDashboardCard extends StatelessWidget {
  final SharedSpace space;
  final Settlement settlement;

  const SpaceDashboardCard({
    super.key,
    required this.space,
    required this.settlement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.foreground.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '累计总支出',
                      style: theme.typography.xs.copyWith(
                        color: colors.primaryForeground.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    Icon(
                      FIcons.info,
                      size: 14,
                      color: colors.primaryForeground.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '¥${_formatAmount(space.totalExpense)}',
                  style: theme.typography.xl3.copyWith(
                    color: colors.primaryForeground,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildQuickStat(
                      context,
                      '参与成员',
                      '${space.members?.length ?? 0} 人',
                    ),
                    const SizedBox(width: 32),
                    _buildQuickStat(context, '成员人均', '¥${_calculateAverage()}'),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '成员消费分布',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.foreground,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '实时更新',
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDistributionBar(context),
                const SizedBox(height: 24),
                ..._buildMemberList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(BuildContext context, String label, String value) {
    final theme = context.theme;
    final colors = theme.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.typography.xs.copyWith(
            color: colors.primaryForeground.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.typography.sm.copyWith(
            color: colors.primaryForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionBar(BuildContext context) {
    final colors = context.theme.colors;
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Row(
          children: [
            Expanded(flex: 65, child: Container(color: colors.primary)),
            Expanded(
              flex: 35,
              child: Container(color: colors.primary.withValues(alpha: 0.3)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMemberList(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final members = space.members ?? [];

    if (members.isEmpty) return [const SizedBox()];

    return members.map((member) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            _buildAvatar(context, member),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.username,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    member.role == MemberRole.owner ? '主理人' : '成员',
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥${_formatAmount(member.contributionAmount)}',
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.foreground,
                  ),
                ),
                Text(
                  '已支付',
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAvatar(BuildContext context, SharedSpaceMember member) {
    final colors = context.theme.colors;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: colors.muted,
        shape: BoxShape.circle,
        border: Border.all(color: colors.background, width: 2),
      ),
      child: Center(
        child: Text(
          member.username.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colors.mutedForeground,
          ),
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    String valueStr = amount.toString();
    final value = double.tryParse(valueStr) ?? 0.0;
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    var formatted = '';
    var count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0 && intPart[i] != '-') {
        formatted = ',$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }
    return '$formatted.$decPart';
  }

  String _calculateAverage() {
    final total = double.tryParse(space.totalExpense) ?? 0.0;
    final memberCount = space.members?.length ?? 1;
    final avg = memberCount > 0 ? total / memberCount : total;
    return _formatAmount(avg);
  }
}
