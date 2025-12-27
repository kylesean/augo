import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/shared_space_models.dart';
import '../services/shared_space_service.dart';

part 'shared_space_provider.g.dart';

class SharedSpaceState {
  final List<SharedSpace> spaces;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const SharedSpaceState({
    this.spaces = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  SharedSpaceState copyWith({
    List<SharedSpace>? spaces,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return SharedSpaceState(
      spaces: spaces ?? this.spaces,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@riverpod
class SharedSpaceNotifier extends _$SharedSpaceNotifier {
  @override
  SharedSpaceState build() {
    return const SharedSpaceState();
  }

  Future<void> loadSpaces({bool refresh = false}) async {
    final service = ref.read(sharedSpaceServiceProvider);
    if (refresh) {
      state = const SharedSpaceState(isLoading: true);
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = refresh ? 1 : state.currentPage;
      final response = await service.getSharedSpaces(page: page);

      final newSpaces = refresh
          ? response.spaces
          : [...state.spaces, ...response.spaces];
      final hasMore = newSpaces.length < response.total;

      state = state.copyWith(
        spaces: newSpaces,
        isLoading: false,
        error: null,
        currentPage: page + 1,
        hasMore: hasMore,
      );
    } catch (e) {
      String errorMessage = '加载共享空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  Future<SharedSpace?> createSpace({
    required String name,
    String? description,
  }) async {
    final service = ref.read(sharedSpaceServiceProvider);
    try {
      final newSpace = await service.createSharedSpace(
        name: name,
        description: description,
      );

      state = state.copyWith(spaces: [newSpace, ...state.spaces]);

      return newSpace;
    } catch (e) {
      String errorMessage = '创建空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(error: errorMessage);
      return null;
    }
  }

  Future<SharedSpace?> joinSpaceWithCode(String inviteCode) async {
    final service = ref.read(sharedSpaceServiceProvider);
    try {
      final space = await service.joinSpaceWithCode(inviteCode);

      final existingIndex = state.spaces.indexWhere((s) => s.id == space.id);
      if (existingIndex == -1) {
        state = state.copyWith(spaces: [space, ...state.spaces]);
      } else {
        final updatedSpaces = [...state.spaces];
        updatedSpaces[existingIndex] = space;
        state = state.copyWith(spaces: updatedSpaces);
      }

      return space;
    } catch (e) {
      String errorMessage = '加入空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(error: errorMessage);
      return null;
    }
  }

  Future<bool> leaveSpace(String spaceId) async {
    final service = ref.read(sharedSpaceServiceProvider);
    try {
      await service.leaveSpace(spaceId);

      state = state.copyWith(
        spaces: state.spaces.where((space) => space.id != spaceId).toList(),
      );

      return true;
    } catch (e) {
      String errorMessage = '离开空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(error: errorMessage);
      return false;
    }
  }

  Future<bool> deleteSpace(String spaceId) async {
    final service = ref.read(sharedSpaceServiceProvider);
    try {
      await service.deleteSpace(spaceId);

      state = state.copyWith(
        spaces: state.spaces.where((space) => space.id != spaceId).toList(),
      );

      return true;
    } catch (e) {
      String errorMessage = '删除空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(error: errorMessage);
      return false;
    }
  }

  Future<bool> updateSpace(
    String spaceId, {
    String? name,
    String? description,
  }) async {
    final service = ref.read(sharedSpaceServiceProvider);
    try {
      final updatedSpace = await service.updateSpace(
        spaceId,
        name: name,
        description: description,
      );

      final updatedSpaces = state.spaces.map((space) {
        return space.id == spaceId ? updatedSpace : space;
      }).toList();

      state = state.copyWith(spaces: updatedSpaces);
      return true;
    } catch (e) {
      String errorMessage = '更新空间失败';
      if (e is AppException) {
        errorMessage = e.message;
      }
      state = state.copyWith(error: errorMessage);
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

@riverpod
Future<SharedSpace> spaceDetail(Ref ref, String spaceId) async {
  final service = ref.watch(sharedSpaceServiceProvider);
  return service.getSharedSpaceDetail(spaceId);
}

@riverpod
Future<Settlement> spaceSettlement(Ref ref, String spaceId) async {
  final service = ref.watch(sharedSpaceServiceProvider);
  return service.getSpaceSettlement(spaceId);
}

@riverpod
Future<SpaceTransactionListResponse> spaceTransactions(
  Ref ref,
  String spaceId, {
  int page = 1,
  int limit = 20,
}) async {
  final service = ref.watch(sharedSpaceServiceProvider);
  return service.getSpaceTransactions(spaceId, page: page, limit: limit);
}
