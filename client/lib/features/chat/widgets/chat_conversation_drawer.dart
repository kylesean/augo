import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import '../providers/chat_history_provider.dart';
import '../providers/conversation_search_provider.dart';
import '../providers/conversation_search_state.dart';
import '../providers/paginated_conversation_provider.dart';
import '../models/conversation_info.dart';
import '../services/conversation_service.dart';
import 'conversation_item_skeleton.dart';
import 'authenticated_image.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/widgets/themed_icon.dart';
import '../../profile/providers/user_profile_provider.dart';

class ChatConversationDrawer extends ConsumerStatefulWidget {
  const ChatConversationDrawer({super.key});

  @override
  ConsumerState<ChatConversationDrawer> createState() =>
      _ChatConversationDrawerState();
}

class _ChatConversationDrawerState
    extends ConsumerState<ChatConversationDrawer> {
  @override
  void initState() {
    super.initState();
    // Ensure data is loaded immediately upon initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paginatedState = ref.read(paginatedConversationProvider);
      if (paginatedState.conversations.isEmpty && !paginatedState.isLoading) {
        ref.read(paginatedConversationProvider.notifier).loadFirstPage();
      }
    });
  }

  // Build skeleton screen list
  Widget _buildSkeletonList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 8,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return const ConversationItemSkeleton();
      },
    );
  }

  // Build empty state
  Widget _buildEmptyState(BuildContext context) {
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemedIcon.large(
              icon: FIcons.messageCircle,
              backgroundColor: theme.colors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              t.chat.noHistory,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.chat.startNewChat,
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build error state
  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemedIcon.large(
              icon: FIcons.x,
              backgroundColor: theme.colors.destructive.withValues(alpha: 0.1),
              iconColor: theme.colors.destructive,
            ),
            const SizedBox(height: 16),
            Text(
              t.common.loadFailed,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colors.destructive,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ref.invalidate(conversationListProvider);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      t.common.retry,
                      style: theme.typography.sm.copyWith(
                        color: theme.colors.foreground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build conversation list
  Widget _buildConversationList(
    BuildContext context,
    List<dynamic> conversations,
    String? currentConversationId,
    WidgetRef ref,
  ) {
    final theme = context.theme;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: conversations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        final isSelected = conversation.id == currentConversationId;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? theme.colors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: theme.colors.border) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // If the clicked item is not the current session
                if (!isSelected) {
                  context.goNamed(
                    'conversation',
                    pathParameters: {'conversationId': conversation.id},
                  );
                }
                // Safely close the drawer
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Session icon - using ThemedIcon for design consistency
                    ThemedIcon(
                      icon: FIcons.messageCircle,
                      backgroundColor: isSelected
                          ? theme.colors.primary.withValues(alpha: 0.15)
                          : theme.colors.secondary,
                      iconColor: isSelected
                          ? theme.colors.primary
                          : theme.colors.mutedForeground,
                    ),
                    const SizedBox(width: 12),
                    // Session info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.title,
                            style: theme.typography.sm.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colors.primary
                                  : theme.colors.foreground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat(
                              'M/d HH:mm',
                              TranslationProvider.of(
                                context,
                              ).locale.languageCode,
                            ).format(conversation.updatedAt),
                            style: theme.typography.xs.copyWith(
                              color: theme.colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final paginatedState = ref.watch(paginatedConversationProvider);
    final currentConversationId = ref.watch(
      chatHistoryProvider.select((state) => state.currentConversationId),
    );
    final searchState = ref.watch(conversationSearchProvider);

    // If in fullscreen search mode, use TweenAnimationBuilder for smooth transition
    if (searchState.mode == SearchMode.fullscreenSearch) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: theme.colors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2 * value),
                  blurRadius: 10 * value,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: _buildFullscreenSearchMode(
                context,
                ref,
                theme,
                searchState,
                paginatedState,
                currentConversationId,
              ),
            ),
          );
        },
      );
    }

    return Drawer(
      backgroundColor: theme.colors.background,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: searchState.mode == SearchMode.search
            ? _buildSearchMode(context, ref, theme)
            : _buildNormalMode(
                context,
                ref,
                theme,
                paginatedState,
                currentConversationId,
              ),
      ),
    );
  }

  // Normal mode interface
  Widget _buildNormalMode(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    PaginatedConversationState paginatedState,
    String? currentConversationId,
  ) {
    return Column(
      children: [
        // Top: Search box and new chat button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search box - Use Hero for smooth transition
              Hero(
                tag: 'search_box',
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(conversationSearchProvider.notifier)
                          .enterFullscreenSearchMode();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colors.background,
                        border: Border.all(color: theme.colors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FIcons.search,
                            size: 16,
                            color: theme.colors.mutedForeground,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.chat.searchHint,
                              style: theme.typography.sm.copyWith(
                                color: theme.colors.mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Library button - Use Forui FItemGroup + FItem (title) style, maintain systematic spacing and divider
              FItemGroup(
                divider: FItemDivider.none,
                children: [
                  FItem(
                    prefix: Icon(
                      FIcons.database,
                      size: 16,
                      color: theme.colors.mutedForeground,
                    ),
                    title: Text(t.chat.library, style: theme.typography.sm),
                    onPress: () {
                      // TODO: Open library
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Middle: Conversation list
        Expanded(
          child: _buildPaginatedConversationList(
            context,
            ref,
            theme,
            paginatedState,
            currentConversationId,
          ),
        ),
        // Bottom: User info
        _buildUserInfo(context, ref, theme),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref, FThemeData theme) {
    final userState = ref.watch(userProfileProvider);
    final user = userState.user;

    return Container(
      decoration: const BoxDecoration(border: null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('/profile');
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _buildAvatarContent(
                      user?.avatarUrl,
                      theme,
                      theme.colors,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.username ?? '...',
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        t.chat.viewProfile,
                        style: theme.typography.xs.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FIcons.chevronRight,
                  size: 16,
                  color: theme.colors.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// build avatar content
  Widget _buildAvatarContent(
    String? avatarUrl,
    FThemeData theme,
    FColors colors,
  ) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // 从 URL 中提取 attachmentId (URL 格式: http://.../view/{id} 或 /api/v1/files/view/{id})
      try {
        final uri = Uri.parse(avatarUrl);
        final pathSegments = uri.pathSegments;
        final attachmentId = pathSegments.isNotEmpty ? pathSegments.last : '';

        if (attachmentId.isNotEmpty) {
          return AuthenticatedImage(
            attachmentId: attachmentId,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(FIcons.user, size: 16, color: colors.mutedForeground);
            },
          );
        }
      } catch (e) {
        debugPrint('❌ Error parsing avatar URL: $e');
      }
    }

    return Icon(FIcons.user, size: 16, color: colors.mutedForeground);
  }

  // Build category column
  Widget _buildCategoryColumn(
    BuildContext context,
    FThemeData theme,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: theme.colors.foreground),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colors.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build paginated conversation list
  Widget _buildPaginatedConversationList(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    PaginatedConversationState paginatedState,
    String? currentConversationId,
  ) {
    if (paginatedState.isLoading && paginatedState.conversations.isEmpty) {
      return _buildSkeletonList(context);
    }

    if (paginatedState.error != null && paginatedState.conversations.isEmpty) {
      return _buildErrorState(context, paginatedState.error!, ref);
    }

    if (paginatedState.conversations.isEmpty) {
      return _buildEmptyState(context);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Load more when scrolling to the bottom
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            paginatedState.hasMore &&
            !paginatedState.isLoadingMore) {
          ref.read(paginatedConversationProvider.notifier).loadNextPage();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(paginatedConversationProvider.notifier).refresh();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount:
              paginatedState.conversations.length +
              (paginatedState.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // If it's the last item and there's more data, show loading indicator
            if (index == paginatedState.conversations.length) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: paginatedState.isLoadingMore
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                ),
              );
            }

            final conversation = paginatedState.conversations[index];
            return _buildSingleConversationItem(
              context,
              conversation,
              currentConversationId,
              ref,
            );
          },
        ),
      ),
    );
  }

  // Build single conversation item
  Widget _buildSingleConversationItem(
    BuildContext context,
    ConversationInfo conversation,
    String? currentConversationId,
    WidgetRef ref,
  ) {
    final theme = context.theme;
    final isSelected = conversation.id == currentConversationId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? theme.colors.secondary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: theme.colors.border) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isSelected) {
              context.goNamed(
                'conversation',
                pathParameters: {'conversationId': conversation.id},
              );
            }
            // Safely close Drawer to avoid errors when stack is empty
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          onLongPress: () => _showDeleteConfirmation(
            context,
            ref,
            conversation.id,
            conversation.title,
            isSelected,
          ),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Display text information only, no left message icon
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? theme.colors.primary
                              : theme.colors.foreground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(
                          'M/d HH:mm',
                          TranslationProvider.of(context).locale.languageCode,
                        ).format(conversation.updatedAt),
                        style: theme.typography.xs.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
    bool isSelected,
  ) async {
    // Haptic feedback on long press
    await HapticFeedback.mediumImpact();

    if (!context.mounted) return;

    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (dialogContext) => FDialog(
        direction: Axis.horizontal,
        title: Text(t.chat.deleteConversation),
        body: Text(t.chat.deleteConversationConfirm),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.common.cancel),
          ),
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.common.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _performDelete(context, ref, id, title, isSelected);
    }
  }

  /// Perform the actual delete operation
  Future<void> _performDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
    bool isSelected,
  ) async {
    final service = ref.read(conversationServiceProvider);
    final success = await service.deleteConversation(id);

    if (!context.mounted) return;

    if (success) {
      await HapticFeedback.lightImpact();
      if (!context.mounted) return;

      // Refresh the conversation list
      ref.read(paginatedConversationProvider.notifier).refresh();

      // If we are in search mode, refresh search results as well
      final searchState = ref.read(conversationSearchProvider);
      if (searchState.mode != SearchMode.normal &&
          searchState.query.isNotEmpty) {
        ref
            .read(conversationSearchProvider.notifier)
            .updateQuery(searchState.query);
      }

      // If we deleted the current conversation, navigate to new chat and reset history
      if (isSelected) {
        // Reset chat history state
        ref.read(chatHistoryProvider.notifier).createNewConversation();
        context.goNamed('chat');
      }

      // Show success toast
      ToastService.success(description: Text(t.chat.conversationDeleted));
    } else {
      await HapticFeedback.heavyImpact();
      if (!context.mounted) return;

      ToastService.showDestructive(
        description: Text(t.chat.deleteConversationFailed),
      );
    }
  }

  // Search mode interface
  Widget _buildSearchMode(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
  ) {
    final searchState = ref.watch(conversationSearchProvider);
    final paginatedState = ref.watch(paginatedConversationProvider);
    final currentConversationId = ref.watch(
      chatHistoryProvider.select((state) => state.currentConversationId),
    );

    return Column(
      children: [
        // Top: Search box and cancel button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SearchTextField(
                  searchState: searchState,
                  onChanged: (value) {
                    ref
                        .read(conversationSearchProvider.notifier)
                        .updateQuery(value);
                  },
                  onClear: () {
                    ref.read(conversationSearchProvider.notifier).clearSearch();
                  },
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  ref
                      .read(conversationSearchProvider.notifier)
                      .exitSearchMode();
                },
                child: Text(
                  t.common.cancel,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content area: Display search results if there's a search query, otherwise show original conversation list
        Expanded(
          child: searchState.query.trim().isEmpty
              ? _buildPaginatedConversationList(
                  context,
                  ref,
                  theme,
                  paginatedState,
                  currentConversationId,
                )
              : _buildSearchResults(context, ref, theme, searchState),
        ),
      ],
    );
  }

  // Build search results
  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    ConversationSearchState searchState,
  ) {
    if (searchState.isLoading) {
      return _buildSkeletonList(context);
    }

    if (searchState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemedIcon.large(
                icon: FIcons.triangleAlert,
                backgroundColor: theme.colors.destructive.withValues(
                  alpha: 0.1,
                ),
                iconColor: theme.colors.destructive,
              ),
              const SizedBox(height: 16),
              Text(
                t.chat.searchFailed,
                style: theme.typography.base.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colors.destructive,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                searchState.error!,
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!searchState.hasSearched) {
      return const SizedBox.shrink(); // Don't show anything when not searching, as original list will be displayed
    }

    if (searchState.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThemedIcon.large(
                icon: FIcons.search,
                backgroundColor: theme.colors.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                t.chat.noRelatedFound,
                style: theme.typography.base.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.chat.tryOtherKeywords,
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: searchState.results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final result = searchState.results[index];
        return _buildSearchResultItem(
          context,
          ref,
          theme,
          result,
          searchState.query,
        );
      },
    );
  }

  // Build search suggestions
  Widget _buildSearchSuggestions(BuildContext context, FThemeData theme) {
    final suggestions = [
      {'icon': FIcons.hash, 'title': 'First Principles Engine Breakdown'},
      {'icon': FIcons.terminal, 'title': 'Linux Ubuntu Command Master'},
      {'icon': FIcons.circle, 'title': 'Laravel GPT'},
      {'icon': FIcons.code, 'title': 'Technical Guidance Master'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: suggestions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(
                suggestion['icon'] as IconData,
                size: 20,
                color: theme.colors.mutedForeground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  suggestion['title'] as String,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.foreground,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build search result item
  Widget _buildSearchResultItem(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    ConversationSearchResult result,
    String query,
  ) {
    return GestureDetector(
      onTap: () {
        // If there's a messageId, navigate to specific message, otherwise navigate to conversation
        if (result.messageId != null) {
          context.goNamed(
            'conversation',
            pathParameters: {'conversationId': result.id},
            queryParameters: {'messageId': result.messageId},
          );
        } else {
          context.goNamed(
            'conversation',
            pathParameters: {'conversationId': result.id},
          );
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      onLongPress: () {
        final currentConversationId = ref.read(
          chatHistoryProvider.select((state) => state.currentConversationId),
        );
        _showDeleteConfirmation(
          context,
          ref,
          result.id,
          result.title,
          result.id == currentConversationId,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title (with highlight) - Limit 1 line
            if (result.title.isNotEmpty)
              _buildHighlightedText(
                result.title,
                query,
                result.highlights.where((h) => h.field == 'title').toList(),
                theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colors.foreground,
                  height: 1.3,
                ),
                theme.colors.secondary,
                maxLines: 1,
              ),
            if (result.title.isNotEmpty) const SizedBox(height: 6),
            // Content snippet (with highlight) - Limit 2 lines
            _buildHighlightedText(
              result.snippet,
              query,
              result.highlights.where((h) => h.field == 'snippet').toList(),
              theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
                height: 1.4,
              ),
              theme.colors.secondary,
              maxLines: 2,
            ),
            const SizedBox(height: 6),
            // Time
            Text(
              result.updatedAt != null
                  ? 'Updated ${_formatDate(result.updatedAt!)}'
                  : result.createdAt != null
                  ? 'Created ${_formatDate(result.createdAt!)}'
                  : '',
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build highlighted text
  Widget _buildHighlightedText(
    String text,
    String query,
    List<HighlightRange> highlights,
    TextStyle baseStyle,
    Color highlightColor, {
    int maxLines = 2,
  }) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    if (highlights.isEmpty || query.isEmpty) {
      return Text(
        text,
        style: baseStyle,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final highlight in highlights) {
      // Add text before highlight
      if (currentIndex < highlight.start) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, highlight.start),
            style: baseStyle,
          ),
        );
      }

      // Add highlighted text
      spans.add(
        TextSpan(
          text: text.substring(highlight.start, highlight.end),
          style: baseStyle.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      currentIndex = highlight.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: baseStyle));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Build fullscreen search mode
  Widget _buildFullscreenSearchMode(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    ConversationSearchState searchState,
    PaginatedConversationState paginatedState,
    String? currentConversationId,
  ) {
    return Column(
      children: [
        // Top search bar - Use Hero for smooth transition with drawer search box
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Search box - Use Hero to share animation with drawer mode
              Expanded(
                child: Hero(
                  tag: 'search_box',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colors.background,
                        border: Border.all(color: theme.colors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FIcons.search,
                            size: 16,
                            color: theme.colors.mutedForeground,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: _FullscreenSearchTextField()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Cancel button
              GestureDetector(
                onTap: () {
                  ref
                      .read(conversationSearchProvider.notifier)
                      .exitSearchMode();
                },
                child: Text(
                  t.common.cancel,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search result content area - Use unified conversation list component for consistent skeleton screen and scroll loading
        Expanded(
          child: searchState.query.trim().isEmpty
              ? _buildPaginatedConversationList(
                  context,
                  ref,
                  theme,
                  paginatedState,
                  currentConversationId,
                )
              : _buildSearchResults(context, ref, theme, searchState),
        ),
      ],
    );
  }

  // Build fullscreen conversation list (simplified version, no icons, no dates)
  Widget _buildFullscreenConversationList(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    PaginatedConversationState paginatedState,
    String? currentConversationId,
  ) {
    if (paginatedState.isLoading && paginatedState.conversations.isEmpty) {
      return _buildSkeletonList(context);
    }

    if (paginatedState.error != null && paginatedState.conversations.isEmpty) {
      return _buildErrorState(context, paginatedState.error!, ref);
    }

    if (paginatedState.conversations.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: paginatedState.conversations.length,
      itemBuilder: (context, index) {
        final conversation = paginatedState.conversations[index];
        final isSelected = conversation.id == currentConversationId;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? theme.colors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: theme.colors.border) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!isSelected) {
                  context.goNamed(
                    'conversation',
                    pathParameters: {'conversationId': conversation.id},
                  );
                }
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  conversation.title,
                  style: theme.typography.sm.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? theme.colors.primary
                        : theme.colors.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Format date display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}

/// Custom search text field component
class _SearchTextField extends StatefulWidget {
  final ConversationSearchState searchState;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchTextField({
    required this.searchState,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchState.query);
    _focusNode = FocusNode();

    // Listen for focus changes
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // When search box gains focus, trigger fullscreen search mode
      // Use WidgetsBinding to ensure execution in next frame, avoiding state modification during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          final ref = ProviderScope.containerOf(
            context,
          ).read(conversationSearchProvider.notifier);
          ref.enterFullscreenSearchMode();
        }
      });
    }
  }

  @override
  void didUpdateWidget(_SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync provider's query when not focused, to prevent overwriting input and cursor during rebuild
    if (!_focusNode.hasFocus && widget.searchState.query != _controller.text) {
      _controller.text = widget.searchState.query;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              FIcons.search,
              size: 16,
              color: theme.colors.mutedForeground,
            ),
          ),
          // Input field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              style: theme.typography.sm,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: t.common.search,
                hintStyle: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          // Clear button
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onClear();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  FIcons.x,
                  size: 16,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Fullscreen search text field component
class _FullscreenSearchTextField extends ConsumerStatefulWidget {
  const _FullscreenSearchTextField();

  @override
  ConsumerState<_FullscreenSearchTextField> createState() =>
      _FullscreenSearchTextFieldState();
}

class _FullscreenSearchTextFieldState
    extends ConsumerState<_FullscreenSearchTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final searchState = ref.read(conversationSearchProvider);
    _controller = TextEditingController(text: searchState.query);
    _focusNode = FocusNode();

    // Auto-focus search box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(_FullscreenSearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Don't force sync controller in fullscreen input mode, to avoid cursor jumping when rebuild is triggered by query return
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final query = ref.watch(conversationSearchProvider.select((s) => s.query));

    // Only sync external query to controller when not focused, to prevent misalignment from query return write-back
    if (!_focusNode.hasFocus && query != _controller.text) {
      _controller.text = query;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            style: theme.typography.sm,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: t.common.search,
              hintStyle: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              // Only push changes to provider, don't write back to controller, to avoid circular overwrites
              ref.read(conversationSearchProvider.notifier).updateQuery(value);
            },
          ),
        ),
        // Clear button
        if (_controller.text.isNotEmpty)
          GestureDetector(
            onTap: () {
              // Clear controller and provider, maintain focus
              _controller.clear();
              ref.read(conversationSearchProvider.notifier).clearSearch();
              _focusNode.requestFocus();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: theme.colors.mutedForeground.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(FIcons.x, size: 10, color: theme.colors.background),
            ),
          ),
      ],
    );
  }
}
