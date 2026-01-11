import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/comment_model.dart';
import '../../providers/comment_providers.dart';

final currentUserIdProvider = Provider<String>(
  (ref) => '1',
); // Dummy current user ID

class CommentItemWidget extends ConsumerWidget {
  final CommentModel comment;
  final String transactionId;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.transactionId,
  });

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.comment.confirmDeleteTitle),
          content: Text(t.comment.confirmDeleteContent),
          actions: <Widget>[
            FButton(
              style: FButtonStyle.outline(),
              onPress: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(t.common.cancel),
            ),
            FButton(
              style: FButtonStyle.destructive(),
              onPress: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(transactionCommentsProvider(transactionId).notifier)
                      .deleteComment(comment.id);
                  if (!context.mounted) return;
                  showFToast(
                    context: context,
                    title: Text(t.comment.success),
                    description: Text(t.comment.commentDeleted),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  showFToast(
                    context: context,
                    icon: const Icon(FIcons.triangleAlert),
                    title: Text(t.comment.error),
                    description: Text(
                      '${t.comment.deleteFailed}: ${e.toString()}',
                    ),
                  );
                }
              },
              child: Text(t.common.delete),
            ),
          ],
        );
      },
    );
  }

  void _showCommentActions(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colors;
    final String currentLoggedInUserId = ref.watch(currentUserIdProvider);
    final bool canDelete = comment.userId == currentLoggedInUserId;

    final List<Widget> actions = [];

    if (canDelete) {
      actions.add(
        FButton(
          style: FButtonStyle.ghost(),
          onPress: () {
            Navigator.of(context).pop();
            _showDeleteConfirmDialog(context, ref);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FIcons.trash2, size: 16, color: colorScheme.destructive),
              const SizedBox(width: 8),
              Text(
                t.comment.deleteComment,
                style: TextStyle(color: colorScheme.destructive),
              ),
            ],
          ),
        ),
      );
    }

    if (actions.isEmpty) {
      showFToast(
        context: context,
        title: Text(t.comment.hint),
        description: Text(t.comment.noActions),
      );
      return;
    }

    showModalBottomSheet(
      context: context, // Use the context of CommentItemWidget
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colors;
    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());

    final bool isSubComment = comment.parentCommentId != null;
    final double avatarIconSize = isSubComment ? 10 : 14;
    final String currentLoggedInUserId = ref.watch(currentUserIdProvider);
    final bool canDelete = comment.userId == currentLoggedInUserId;

    // Build username display, including reply target
    Widget buildUserNameDisplay() {
      final List<Widget> nameParts = [
        Text(
          comment.userName, // Current commenter
          style: theme.typography.sm.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.foreground,
          ),
        ),
      ];

      // Check if it's a child comment and has reply-to user info
      if (isSubComment &&
          comment.repliedToUserName != null &&
          comment.repliedToUserName!.isNotEmpty) {
        nameParts.addAll([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              FIcons.chevronRight,
              size: 12,
              color: colorScheme.mutedForeground,
            ),
          ),
          Flexible(
            // Use Flexible to avoid overflow for long usernames
            child: Text(
              comment.repliedToUserName!, // Person being replied to
              style: theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme
                    .primary, // Highlight reply target with primary color
              ),
              overflow: TextOverflow.ellipsis, // Ellipsis for overflow
            ),
          ),
        ]);
      }
      return Row(mainAxisSize: MainAxisSize.min, children: nameParts);
    }

    return Padding(
      padding: EdgeInsets.only(
        left: isSubComment ? 32.0 : 0, // Indentation for child comments
        top: isSubComment
            ? 6.0
            : 10.0, // Top padding for child comments can be smaller
        bottom: 6.0, // Unified bottom padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FAvatar(
                image: NetworkImage(comment.userAvatarUrl),
                fallback: Icon(
                  FIcons.circleUserRound,
                  size: avatarIconSize,
                  color: colorScheme.mutedForeground,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: buildUserNameDisplay()),
                        const SizedBox(width: 6),
                        Text(
                          timeago.format(comment.createdAt, locale: 'zh_CN'),
                          style: theme.typography.sm.copyWith(
                            fontSize: 11,
                            color: colorScheme.mutedForeground,
                          ),
                        ),
                        if (canDelete)
                          FButton.icon(
                            onPress: () => _showCommentActions(context, ref),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                FIcons.ellipsis,
                                color: colorScheme.mutedForeground,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.commentText,
                      style: theme.typography.sm.copyWith(
                        color: colorScheme.foreground,
                        height: 1.4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                      ), // Reduce top padding for reply button
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Align reply button to the right
                        children: [
                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () {
                              final currentReplyingTo = ref.read(
                                replyingToCommentIdProvider,
                              );
                              if (currentReplyingTo == comment.id) {
                                ref
                                    .read(replyingToCommentIdProvider.notifier)
                                    .set(null);
                                ref
                                    .read(replyingToUserNameProvider.notifier)
                                    .set(null);
                              } else {
                                ref
                                    .read(replyingToCommentIdProvider.notifier)
                                    .set(comment.id);
                                // When replying to a parent comment, the person being replied to is its author
                                // When replying to a child comment, the person being replied to is the author of that child comment
                                ref
                                    .read(replyingToUserNameProvider.notifier)
                                    .set(comment.userName);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0,
                              ), // Adjust padding
                              child: SizedBox(
                                height:
                                    24, // Give the link button a clear height
                                child: Text(
                                  t.comment.reply,
                                  style: theme.typography.sm.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.mutedForeground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Child comments are no longer rendered recursively by this Widget
        ],
      ),
    );
  }
}
