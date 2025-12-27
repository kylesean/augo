import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/shared/widgets/themed_icon.dart';

/// A themed icon badge - wrapper around ThemedIcon for GenUI compatibility
///
/// This is a Layer 1 (Atom) component that delegates to the unified
/// ThemedIcon component for consistent styling across the app.
///
/// Example:
/// ```dart
/// IconBadge(icon: FIcons.wallet)
/// IconBadge(icon: FIcons.wallet, size: 44)
/// ```
class IconBadge extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// Size of the badge (width and height). Defaults to 44.
  final double size;

  const IconBadge({super.key, required this.icon, this.size = 44});

  /// Creates an IconBadge from account type data
  factory IconBadge.fromAccountType({
    Key? key,
    required String? accountType,
    required FColors colors,
    double size = 44,
  }) {
    final iconData = _getAccountTypeIcon(accountType);
    return IconBadge(key: key, icon: iconData, size: size);
  }

  static IconData _getAccountTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'bank':
      case 'bank_card':
        return FIcons.landmark;
      case 'cash':
        return FIcons.wallet;
      case 'investment':
        return FIcons.trendingUp;
      case 'credit_card':
        return FIcons.creditCard;
      default:
        return FIcons.wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map size to ThemedIconSize
    final themedSize = switch (size) {
      <= 30 => ThemedIconSize.compact,
      <= 36 => ThemedIconSize.standard,
      _ => ThemedIconSize.large,
    };

    return ThemedIcon(icon: icon, size: themedSize);
  }
}
