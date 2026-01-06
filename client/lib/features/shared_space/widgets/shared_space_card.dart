import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/auth/providers/auth_provider.dart';
import '../models/shared_space_models.dart';

class SharedSpaceCard extends ConsumerWidget {
  final SharedSpace space;
  final VoidCallback onTap;

  const SharedSpaceCard({super.key, required this.space, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // background decoration
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
                        // space icon
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

                        // space info
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

                        // arrow icon
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

                    // bottom info
                    Row(
                      children: [
                        // member count
                        _buildInfoChip(
                          context,
                          icon: FIcons.users,
                          label: '${space.members?.length ?? 1}位成员',
                        ),
                        const SizedBox(width: 12),

                        // transaction count
                        _buildInfoChip(
                          context,
                          icon: FIcons.receipt,
                          label: '${space.transactionCount}笔明细',
                        ),

                        const Spacer(),

                        // role badge
                        _buildRoleBadge(context, ref),
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

  Widget _buildRoleBadge(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    // Get current user ID from auth state
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.id;

    // Check if current user is the creator of this space
    final isCreator =
        currentUserId != null && currentUserId == space.creator.id;

    // Determine badge appearance based on role
    final (
      IconData icon,
      String label,
      Color bgColor,
      Color fgColor,
    ) = isCreator
        ? (
            FIcons.crown,
            '创建者',
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.primary,
          )
        : (
            FIcons.user,
            '成员',
            colorScheme.secondary.withValues(alpha: 0.1),
            colorScheme.secondaryForeground,
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.typography.sm.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
