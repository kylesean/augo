import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../models/shared_space_models.dart';

class SharedSpaceCard extends StatelessWidget {
  final SharedSpace space;
  final VoidCallback onTap;

  const SharedSpaceCard({super.key, required this.space, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.foreground.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 背景装饰
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 空间图标
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            FIcons.users,
                            size: 26,
                            color: colorScheme.primaryForeground,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 空间信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                space.name,
                                style: theme.typography.lg.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                space.description ?? '暂无描述',
                                style: theme.typography.sm.copyWith(
                                  color: colorScheme.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // 箭头图标
                        Icon(
                          FIcons.chevronRight,
                          size: 18,
                          color: colorScheme.mutedForeground.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 底部信息
                    Row(
                      children: [
                        // 成员数量
                        _buildInfoChip(
                          context,
                          icon: FIcons.users,
                          label: '${space.members?.length ?? 1}位成员',
                        ),
                        const SizedBox(width: 12),

                        // 交易数量
                        _buildInfoChip(
                          context,
                          icon: FIcons.receipt,
                          label: '${space.transactionCount}笔明细',
                        ),

                        const Spacer(),

                        // 角色标识
                        _buildRoleBadge(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colorScheme.mutedForeground),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.typography.xs.copyWith(
            color: colorScheme.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    // TODO: 这里需要从认证状态获取当前用户ID来判断是否是创建者
    // 暂时显示创建者信息
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FIcons.crown, size: 12, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            '创建者',
            style: theme.typography.sm.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
