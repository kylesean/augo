// features/transaction_detail/widgets/comment_input_bar.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart'; // Import forui
import 'package:augo/i18n/strings.g.dart';

// Assuming these Providers are imported from outside
// Core logic migrated to transactionCommentsProvider
import '../../providers/comment_providers.dart';

class CommentInputBar extends ConsumerStatefulWidget {
  final String transactionId;
  const CommentInputBar({super.key, required this.transactionId});

  @override
  ConsumerState<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends ConsumerState<CommentInputBar> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<String?>(replyingToCommentIdProvider, (previous, next) {
      if (next != null && (previous == null || previous != next)) {
        if (!_commentFocusNode.hasFocus) {
          _commentFocusNode.requestFocus();
        }
        final currentReplyingToName = ref.read(replyingToUserNameProvider);
        // Get the comment being replied to, to determine its parentCommentId later
        final allComments =
            ref
                .read(transactionCommentsProvider(widget.transactionId))
                .asData
                ?.value ??
            [];
        final repliedToComment = allComments.firstWhereOrNull(
          (c) => c.id == next,
        );

        if (currentReplyingToName != null && repliedToComment != null) {
          // When pre-filling, could consider showing reply chain, e.g., "@UserA > @UserB"
          // But for simplicity, we still only show the directly replied username
          final newText = "@$currentReplyingToName ";
          _commentController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    });
  }

  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    final directlyRepliedToCommentId = ref.read(replyingToCommentIdProvider);
    String?
    effectiveParentCommentId; // This is the parentCommentId to pass to backend

    if (directlyRepliedToCommentId != null) {
      // Need to get all comments to find the one being replied to, and determine its parentCommentId
      final allComments =
          ref
              .read(transactionCommentsProvider(widget.transactionId))
              .asData
              ?.value ??
          [];
      final repliedToComment = allComments.firstWhereOrNull(
        (c) => c.id == directlyRepliedToCommentId,
      );

      if (repliedToComment != null) {
        if (repliedToComment.parentCommentId == null) {
          // If replying directly to a parent comment, parentCommentId is this parent comment's id
          effectiveParentCommentId = repliedToComment.id;
        } else {
          // If replying to a child comment, parentCommentId should be its parentCommentId (top-level id)
          effectiveParentCommentId = repliedToComment.parentCommentId;
        }
      } else {
        // Theoretically shouldn't happen as replyingToCommentIdProvider should match an existing comment
        // But as fallback, don't set parentCommentId, making it a new parent comment
        effectiveParentCommentId = null;
      }
    } else {
      // No reply target, this is a new parent comment
      effectiveParentCommentId = null;
    }

    try {
      await ref
          .read(transactionCommentsProvider(widget.transactionId).notifier)
          .addComment(commentText, effectiveParentCommentId);

      _commentController.clear();
      ref.read(replyingToCommentIdProvider.notifier).set(null);
      ref.read(replyingToUserNameProvider.notifier).set(null);
      _commentFocusNode.unfocus();
    } catch (e) {
      if (mounted) {
        showFToast(
          context: context,
          icon: const Icon(FIcons.triangleAlert),
          title: Text(t.comment.error),
          description: Text('${t.comment.commentFailed}: ${e.toString()}'),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ... dispose and build methods ...
  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final replyingToName = ref.watch(replyingToUserNameProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyingToName != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 6.0,
                left: 4.0,
                right: 4.0,
              ),
              child: Row(
                children: [
                  Text(
                    t.comment.replyToPrefix(
                      name: replyingToName,
                    ), // Displays the author name of the comment being replied to
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  const Spacer(),
                  FButton.icon(
                    onPress: () {
                      ref.read(replyingToCommentIdProvider.notifier).set(null);
                      ref.read(replyingToUserNameProvider.notifier).set(null);
                      _commentFocusNode.unfocus();
                      _commentController.clear();
                    },
                    child: Icon(
                      FIcons.x,
                      color: colors.mutedForeground,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FTextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  hint: t.comment.addNote,
                  onTap: () {
                    // Logic here ensures existing reply state is cleared when user clicks input directly
                    // If focused via "Reply" button, replyingToCommentIdProvider already has value
                    if (ref.read(replyingToCommentIdProvider) == null &&
                        _commentFocusNode.hasFocus) {
                      // If no reply target and focus is in input, user might want to start new comment, no action
                    } else if (ref.read(replyingToCommentIdProvider) != null &&
                        !_commentFocusNode.hasFocus) {
                      // If reply target exists but no focus, focus it on click
                      // (Usually handled internally by ShadInput)
                    } else if (ref.read(replyingToCommentIdProvider) == null &&
                        !_commentFocusNode.hasFocus) {
                      // User clicks empty input direktly, clear any lingering reply state
                      ref.read(replyingToCommentIdProvider.notifier).set(null);
                      ref.read(replyingToUserNameProvider.notifier).set(null);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              _isSubmitting
                  ? SizedBox(
                      width: 36,
                      height: 36,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : FButton.icon(
                      onPress: _submitComment,
                      child: Icon(FIcons.send),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
