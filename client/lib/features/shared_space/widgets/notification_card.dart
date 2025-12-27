import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../models/shared_space_models.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return FCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：图标、标题和时间
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 通知图标
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(
                        notification.type,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      size: 20,
                      color: _getNotificationColor(notification.type),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 标题和消息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: notification.isRead
                                      ? colors.mutedForeground
                                      : colors.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: theme.typography.sm.copyWith(
                            color: notification.isRead
                                ? colors.mutedForeground
                                : colors.foreground,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // 删除按钮
                  if (onDelete != null)
                    FButton(
                      style: FButtonStyle.ghost(),
                      onPress: onDelete,
                      child: Icon(
                        FIcons.x,
                        size: 16,
                        color: colors.mutedForeground,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // 时间
              Row(
                children: [
                  Icon(FIcons.clock, size: 14, color: colors.mutedForeground),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(notification.createdAt),
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),

              // 邀请操作按钮
              if (notification.type == NotificationType.spaceInvite &&
                  onAccept != null &&
                  onReject != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FButton(
                        style: FButtonStyle.outline(),
                        onPress: onReject,
                        child: const Text('拒绝'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FButton(
                        onPress: onAccept,
                        child: const Text('接受'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.spaceInvite:
        return FIcons.userPlus;
      case NotificationType.newTransaction:
        return FIcons.receipt;
      case NotificationType.settlementUpdate:
        return FIcons.calculator;
      case NotificationType.memberJoined:
        return FIcons.userCheck;
      case NotificationType.memberLeft:
        return FIcons.userMinus;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.spaceInvite:
        return Colors.blue;
      case NotificationType.newTransaction:
        return Colors.green;
      case NotificationType.settlementUpdate:
        return Colors.orange;
      case NotificationType.memberJoined:
        return Colors.teal;
      case NotificationType.memberLeft:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未知时间';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
