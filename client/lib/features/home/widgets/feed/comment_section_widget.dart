// features/home/widgets/feed/comment_section_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

import '../../models/comment_model.dart';
import '../../providers/comment_providers.dart';
import 'comment_item_widget.dart';

class CommentSectionWidget extends ConsumerWidget {
  final String transactionId;

  const CommentSectionWidget({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colors;
    final commentsAsyncValue = ref.watch(
      transactionCommentsProvider(transactionId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
            bottom: 12.0,
          ),
          child: Text(
            t.comment.note,
            style: theme.typography.xl.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        commentsAsyncValue.when(
          data: (allComments) {
            // allComments is a flat list of comments
            if (allComments.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: Text(
                    t.comment.noNote,
                    style: theme.typography.base.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                ),
              );
            }

            // 1. Split comments into parent comments and a mapping of replies
            final parentComments = <CommentModel>[];
            final Map<String, List<CommentModel>> repliesMap = {};

            for (final comment in allComments) {
              if (comment.parentCommentId == null) {
                parentComments.add(comment);
              } else {
                repliesMap
                    .putIfAbsent(comment.parentCommentId!, () => [])
                    .add(comment);
              }
            }
            // Optional: Sort parent and child comments (e.g., by creation time)
            parentComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            repliesMap.forEach((key, value) {
              value.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            });

            // 2. Build list of widgets containing parent comments and their replies
            final List<Widget> commentWidgets = [];
            for (final parent in parentComments) {
              commentWidgets.add(
                Padding(
                  // Padding for parent comment
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: CommentItemWidget(
                    comment: parent,
                    transactionId: transactionId,
                    // isSubComment: false, // Internal logic in CommentItemWidget handles this via parentCommentId
                  ),
                ),
              );
              // Find and add all replies under this parent comment
              final replies = repliesMap[parent.id] ?? [];
              for (final reply in replies) {
                commentWidgets.add(
                  Padding(
                    // Padding for child comment (CommentItemWidget has internal indentation)
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0,
                    ), // Vertical spacing for replies can be smaller
                    child: CommentItemWidget(
                      comment: reply,
                      transactionId: transactionId,
                      // isSubComment: true,
                    ),
                  ),
                );
              }
              // Add divider after each parent comment and its replies (optional)
              if (replies.isNotEmpty ||
                  parentComments.indexOf(parent) < parentComments.length - 1) {
                commentWidgets.add(
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: FDivider(),
                  ),
                );
              }
            }
            // Remove the last divider if it exists
            if (commentWidgets.isNotEmpty &&
                commentWidgets.last is Padding &&
                (commentWidgets.last as Padding).child is FDivider) {
              commentWidgets.removeLast();
            }

            // Use Column instead of ListView.builder since it shouldn't be nested inside CustomScrollView slivers
            // For single-level replies with reasonable amount of comments, Column is acceptable performance-wise.
            return Column(children: commentWidgets);
          },
          loading: () =>
              const SizedBox.shrink(), // Skeleton screen handles loading state
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                '${t.comment.loadFailed}: ${err.toString()}',
                style: theme.typography.base.copyWith(
                  color: colorScheme.destructive,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
