import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Empty state alert atom
///
/// Use forui's FAlert component to display various "no data" empty states.
///
/// Design principles:
/// - Use FAlert instead of FCard, more lightweight and concise
/// - Only display icon and title, do not display redundant description (description provided by AI text)
/// - Support optional action buttons
class EmptyStateAlert extends StatelessWidget {
  /// Icon
  final IconData icon;

  /// Title text
  final String title;

  /// Action button text (optional)
  final String? actionText;

  /// Action callback (optional)
  final VoidCallback? onAction;

  /// Whether to use destructive style
  final bool isDestructive;

  const EmptyStateAlert({
    super.key,
    required this.icon,
    required this.title,
    this.actionText,
    this.onAction,
    this.isDestructive = false,
  });

  factory EmptyStateAlert.budget({
    String title = '暂无预算',
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateAlert(
      icon: FIcons.chartPie,
      title: title,
      actionText: actionText,
      onAction: onAction,
    );
  }

  factory EmptyStateAlert.transaction({
    String title = '暂无交易记录',
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateAlert(
      icon: FIcons.receiptText,
      title: title,
      actionText: actionText,
      onAction: onAction,
    );
  }

  factory EmptyStateAlert.account({
    String title = '暂无账户',
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyStateAlert(
      icon: FIcons.wallet,
      title: title,
      actionText: actionText,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FAlert(
      icon: Icon(icon),
      title: Text(title),
      style: isDestructive ? FAlertStyle.destructive() : FAlertStyle.primary(),
      subtitle: actionText != null && onAction != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: GestureDetector(
                onTap: onAction,
                child: Text(
                  actionText!,
                  style: TextStyle(
                    color: context.theme.colors.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
