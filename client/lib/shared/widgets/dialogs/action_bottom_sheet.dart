// shared/widgets/dialogs/action_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../../models/action_item_model.dart';
import 'package:forui/forui.dart'; // 1. Import forui

class ActionBottomSheet extends StatelessWidget {
  final List<ActionItem> actions;
  final List<ActionItem>?
  destructiveActions; // Handle destructive actions separately

  const ActionBottomSheet({
    super.key,
    required this.actions,
    this.destructiveActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme; // 2. Get Forui theme
    final colors = theme.colors;

    // 3. Get colors and styles from theme - Fixed color configuration
    final Color sheetBackgroundColor =
        colors.background; // Use background color for sheet background
    final Color sectionBackgroundColor =
        colors.background; // Use background color for section background
    final Color itemTextColor = colors
        .foreground; // Use foreground color to ensure text is clearly visible
    final Color destructiveItemColor =
        colors.destructive; // Destructive actions use destructive color
    final Color iconColor =
        colors.mutedForeground; // Icons use muted foreground color
    final Color dividerColor = colors.border;
    final Color handleColor = colors.mutedForeground.withValues(
      alpha: 0.4,
    ); // Handle color

    Widget buildActionItem(
      ActionItem item,
      BuildContext sheetContext, {
      bool isDestructive = false,
    }) {
      return Container(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(sheetContext);
            item.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: theme.typography.base.copyWith(
                      color: isDestructive
                          ? destructiveItemColor
                          : (item.color ?? itemTextColor),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  item.icon,
                  color: isDestructive
                      ? destructiveItemColor
                      : (item.color ?? iconColor),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildActionSection(
      List<ActionItem> items, {
      bool isDestructive = false,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: sectionBackgroundColor,
          borderRadius: theme.style.borderRadius,
          border: Border.all(color: dividerColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              buildActionItem(items[i], context, isDestructive: isDestructive),
              if (i < items.length - 1)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 1,
                  color: dividerColor,
                ),
            ],
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: sheetBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag indicator
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Main action items area
            if (actions.isNotEmpty) ...[
              buildActionSection(actions),
              const SizedBox(height: 8.0),
            ],

            // Destructive action items area
            if (destructiveActions != null &&
                destructiveActions!.isNotEmpty) ...[
              buildActionSection(destructiveActions!, isDestructive: true),
              const SizedBox(height: 8.0),
            ],

            // Bottom spacing
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
