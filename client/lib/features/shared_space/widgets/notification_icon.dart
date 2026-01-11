import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import '../providers/notification_provider.dart';
import 'dart:async';

class NotificationIcon extends ConsumerStatefulWidget {
  const NotificationIcon({super.key});

  @override
  ConsumerState<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends ConsumerState<NotificationIcon> {
  @override
  void initState() {
    super.initState();
    // 初始加载未读数量
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(notificationProvider.notifier).loadUnreadCount());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final unreadCount = ref.watch(unreadCountProvider);

    return FButton.icon(
      style: FButtonStyle.ghost(),
      onPress: () => _navigateToNotifications(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(FIcons.bell, color: colors.foreground, size: 20),
          if (unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16),
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colors.destructive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: theme.typography.xs.copyWith(
                      color: colors.destructiveForeground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    unawaited(context.push('/notifications'));
  }
}
