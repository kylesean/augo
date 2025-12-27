import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/shared_space_models.dart';
import '../services/notification_service.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;
  final int currentPage;
  final bool hasMore;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
    this.currentPage = 1,
    this.hasMore = true,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
    int? currentPage,
    bool? hasMore,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  late final NotificationService _service;
  bool _mounted = true;
  static final _logger = Logger('NotificationNotifier');

  @override
  NotificationState build() {
    _mounted = true;
    _service = ref.watch(notificationServiceProvider);
    ref.onDispose(() => _mounted = false);
    return const NotificationState();
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      state = const NotificationState(isLoading: true);
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = refresh ? 1 : state.currentPage;
      final response = await _service.getNotifications(page: page);

      final newNotifications = refresh
          ? response.notifications
          : [...state.notifications, ...response.notifications];
      final hasMore = response.notifications.length >= 20; // 假设每页20条

      if (_mounted) {
        state = state.copyWith(
          notifications: newNotifications,
          isLoading: false,
          error: null,
          unreadCount: response.unreadCount,
          currentPage: page + 1,
          hasMore: hasMore,
        );
      }
    } catch (e) {
      String errorMessage = '加载通知失败';
      if (e is AppException) {
        errorMessage = e.message;
      }

      if (_mounted) {
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    }
  }

  Future<void> loadUnreadCount() async {
    try {
      final count = await _service.getUnreadCount();
      if (_mounted) {
        state = state.copyWith(unreadCount: count);
      }
    } catch (e) {
      _logger.warning('加载未读通知数量失败', e);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);

      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId && !notification.isRead) {
          return notification.copyWith(isRead: true, readAt: DateTime.now());
        }
        return notification;
      }).toList();

      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;

      if (_mounted) {
        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
        );
      }
    } catch (e) {
      String errorMessage = '标记已读失败';
      if (e is AppException) {
        errorMessage = e.message;
      }

      if (_mounted) {
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _service.markAllAsRead();

      final updatedNotifications = state.notifications.map((notification) {
        if (!notification.isRead) {
          return notification.copyWith(isRead: true, readAt: DateTime.now());
        }
        return notification;
      }).toList();

      if (_mounted) {
        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: 0,
        );
      }
    } catch (e) {
      String errorMessage = '标记全部已读失败';
      if (e is AppException) {
        errorMessage = e.message;
      }

      if (_mounted) {
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _service.deleteNotification(notificationId);

      final notification = state.notifications.firstWhere(
        (n) => n.id == notificationId,
        orElse: () => throw Exception('通知不存在'),
      );

      final updatedNotifications = state.notifications
          .where((n) => n.id != notificationId)
          .toList();

      final newUnreadCount = !notification.isRead && state.unreadCount > 0
          ? state.unreadCount - 1
          : state.unreadCount;

      if (_mounted) {
        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
        );
      }
    } catch (e) {
      String errorMessage = '删除通知失败';
      if (e is AppException) {
        errorMessage = e.message;
      }

      if (_mounted) {
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  Future<bool> respondToSpaceInvite(
    String spaceId,
    String action,
    String notificationId,
  ) async {
    try {
      await _service.respondToSpaceInvite(spaceId, action);

      if (action == 'reject') {
        await deleteNotification(notificationId);
      } else {
        await markAsRead(notificationId);
      }

      return true;
    } catch (e) {
      String errorMessage = '响应邀请失败';
      if (e is AppException) {
        errorMessage = e.message;
      }

      if (_mounted) {
        state = state.copyWith(error: errorMessage);
      }
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});
