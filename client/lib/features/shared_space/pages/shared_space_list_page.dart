import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import '../providers/shared_space_provider.dart';
import '../models/shared_space_models.dart';
import '../widgets/shared_space_card.dart';
import '../widgets/create_space_sheet.dart';
import '../widgets/join_space_sheet.dart';
import '../../../shared/services/toast_service.dart';
import 'dart:async';

class SharedSpaceListPage extends ConsumerStatefulWidget {
  const SharedSpaceListPage({super.key});

  @override
  ConsumerState<SharedSpaceListPage> createState() =>
      _SharedSpaceListPageState();
}

class _SharedSpaceListPageState extends ConsumerState<SharedSpaceListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(sharedSpaceProvider.notifier).loadSpaces(refresh: true),
      );

      _checkForInviteCode();
    });
  }

  void _checkForInviteCode() {
    final uri = GoRouterState.of(context).uri;
    final joinCode = uri.queryParameters['join_code'];
    if (joinCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showJoinSpaceSheetWithCode(joinCode);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      unawaited(ref.read(sharedSpaceProvider.notifier).loadSpaces());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;
    final state = ref.watch(sharedSpaceProvider);

    ref.listen<String?>(sharedSpaceProvider.select((state) => state.error), (
      previous,
      error,
    ) {
      if (error != null) {
        ToastService.showDestructive(description: Text(error));
        ref.read(sharedSpaceProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Shared Space',
          style: theme.typography.xl.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.foreground,
        elevation: 0,
        actions: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: _showJoinSpaceSheet,
            child: Icon(
              FIcons.userPlus,
              size: 20,
              color: colorScheme.foreground,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () async {
          await ref
              .read(sharedSpaceProvider.notifier)
              .loadSpaces(refresh: true);
        },
        child: state.spaces.isEmpty && !state.isLoading
            ? _buildEmptyState(context)
            : _buildSpacesList(context, state),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateSpaceSheet,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.primaryForeground,
        shape: const CircleBorder(),
        elevation: 2,
        child: const Icon(FIcons.plus, size: 24),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  FIcons.users,
                  size: 60,
                  color: colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Managing joint expenses never been easier',
              style: theme.typography.xl.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create a shared space and easily sync joint\ndebts and expenses with partners or friends',
              style: theme.typography.base.copyWith(
                color: colorScheme.mutedForeground,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            FButton(
              onPress: _showCreateSpaceSheet,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Get Started'),
              ),
            ),
            const SizedBox(height: 16),
            FButton(
              style: FButtonStyle.ghost(),
              onPress: _showJoinSpaceSheet,
              child: Text(
                'Have an invite code? Tap to join',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacesList(BuildContext context, SharedSpaceState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: state.spaces.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.spaces.length) {
          // Loading indicator
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final space = state.spaces[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SharedSpaceCard(
            space: space,
            onTap: () => _navigateToSpaceDetail(space.id),
          ),
        );
      },
    );
  }

  void _showCreateSpaceSheet() {
    unawaited(
      showFSheet<void>(
        context: context,
        side: FLayout.btt,
        builder: (context) => CreateSpaceSheet(
          onSpaceCreated: (space) {
            Navigator.of(context).pop();
            _navigateToInviteSuccess(space);
          },
        ),
      ),
    );
  }

  void _showJoinSpaceSheet() {
    unawaited(
      showFSheet<void>(
        context: context,
        side: FLayout.btt,
        builder: (context) => JoinSpaceSheet(
          onSpaceJoined: (space) {
            Navigator.of(context).pop();
            ToastService.show(
              description: Text('Successfully joined "${space.name}"!'),
            );
            _navigateToSpaceDetail(space.id);
          },
        ),
      ),
    );
  }

  void _showJoinSpaceSheetWithCode(String inviteCode) {
    unawaited(
      showFSheet<void>(
        context: context,
        side: FLayout.btt,
        builder: (context) => JoinSpaceSheet(
          initialCode: inviteCode,
          onSpaceJoined: (space) {
            Navigator.of(context).pop();
            ToastService.show(
              description: Text('Successfully joined "${space.name}"!'),
            );
            _navigateToSpaceDetail(space.id);
          },
        ),
      ),
    );
  }

  void _navigateToSpaceDetail(String spaceId) {
    unawaited(context.push('/profile/shared-space/$spaceId'));
  }

  void _navigateToInviteSuccess(SharedSpace space) {
    unawaited(
      context.push('/profile/shared-space/invite-success', extra: space),
    );
  }
}
