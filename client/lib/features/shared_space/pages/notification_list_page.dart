import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import '../providers/notification_provider.dart';
import '../providers/shared_space_provider.dart';
import '../widgets/notification_card.dart';
import '../models/shared_space_models.dart';
import '../../../shared/services/toast_service.dart';

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({super.key});

  @override
  ConsumerState<NotificationListPage> createState() =>
      _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).loadNotifications(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationProvider.notifier).loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(notificationProvider);

    ref.listen<String?>(notificationProvider.select((state) => state.error), (
      previous,
      error,
    ) {
      if (error != null) {
        ToastService.showDestructive(description: Text(error));
        ref.read(notificationProvider.notifier).clearError();
      }
    });

    return FScaffold(
      header: FHeader(
        title: Text(
          'Notifications',
          style: theme.typography.xl.copyWith(color: colors.foreground),
        ),
        suffixes: [
          if (state.unreadCount > 0)
            FHeaderAction(
              icon: Icon(FIcons.checkCheck),
              onPress: _markAllAsRead,
            ),
        ],
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(notificationProvider.notifier)
              .loadNotifications(refresh: true);
        },
        child: state.notifications.isEmpty && !state.isLoading
            ? _buildEmptyState(context)
            : _buildNotificationsList(context, state),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(FIcons.bell, size: 40, color: colors.mutedForeground),
            ),
            const SizedBox(height: 24),
            Text(
              'No notifications',
              style: theme.typography.xl.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 8),
            Text(
              'When you have new invites or activities,\nyou will receive notifications here',
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: state.notifications.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.notifications.length) {
          // Loading indicator
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final notification = state.notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NotificationCard(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
            onAccept: notification.type == NotificationType.spaceInvite
                ? () => _handleInviteResponse(notification, 'accept')
                : null,
            onReject: notification.type == NotificationType.spaceInvite
                ? () => _handleInviteResponse(notification, 'reject')
                : null,
            onDelete: () => _deleteNotification(notification.id),
          ),
        );
      },
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read
    if (!notification.isRead) {
      ref.read(notificationProvider.notifier).markAsRead(notification.id);
    }

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.spaceInvite:
        // Invite notification, no extra navigation, user can act directly on card
        break;
      case NotificationType.newTransaction:
        // New transaction notification, navigate to transaction detail
        final transactionId = notification.data?['transactionId'] as String?;
        if (transactionId != null) {
          context.push('/home/transaction/$transactionId');
        }
        break;
      case NotificationType.settlementUpdate:
        // Settlement update notification, navigate to space detail
        final spaceId = notification.data?['spaceId'] as String?;
        if (spaceId != null) {
          context.push('/profile/shared-space/$spaceId');
        }
        break;
      case NotificationType.memberJoined:
      case NotificationType.memberLeft:
        // Member change notification, navigate to space settings
        final spaceId = notification.data?['spaceId'] as String?;
        if (spaceId != null) {
          context.push('/profile/shared-space/$spaceId/settings');
        }
        break;
    }
  }

  Future<void> _handleInviteResponse(
    NotificationModel notification,
    String action,
  ) async {
    final spaceId = notification.data?['spaceId'] as String?;
    if (spaceId == null) {
      ToastService.showDestructive(
        description: const Text('Incomplete invite info'),
      );
      return;
    }

    final success = await ref
        .read(notificationProvider.notifier)
        .respondToSpaceInvite(spaceId, action, notification.id);

    if (success) {
      if (action == 'accept') {
        ToastService.show(description: const Text('Invite accepted!'));

        // Refresh shared space list
        ref.read(sharedSpaceProvider.notifier).loadSpaces(refresh: true);

        // Navigate to space detail
        if (mounted) {
          context.push('/profile/shared-space/$spaceId');
        }
      } else {
        ToastService.show(description: const Text('Invite rejected'));
      }
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    await ref
        .read(notificationProvider.notifier)
        .deleteNotification(notificationId);
  }

  Future<void> _markAllAsRead() async {
    await ref.read(notificationProvider.notifier).markAllAsRead();
    ToastService.show(
      description: const Text('All notifications marked as read'),
    );
  }
}
