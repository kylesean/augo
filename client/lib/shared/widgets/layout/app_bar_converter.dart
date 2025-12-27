import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

/// Helper function to convert FHeader.nested to AppBar
class AppBarConverter {
  /// Build a standard AppBar to replace FHeader.nested
  static AppBar buildAppBar({
    required BuildContext context,
    required Widget title,
    List<Widget>? actions,
    VoidCallback? onBack,
    bool showBackButton = true,
  }) {
    return AppBar(
      title: title,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
      actions: actions,
    );
  }

  /// Convert FHeaderAction to IconButton
  static IconButton convertToIconButton(FHeaderAction action) {
    return IconButton(
      icon: action.icon,
      onPressed: action.onPress,
    );
  }
}