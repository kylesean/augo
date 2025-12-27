import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Transaction beneficiary enum (7 items)
///
/// Corresponds to backend TransactionSubject enum
/// Answers "Who is this money spent for?"
enum TransactionSubject {
  self('SELF', 'Self', FIcons.user),
  spouse('SPOUSE', 'Spouse', FIcons.heart),
  kids('KIDS', 'Kids', FIcons.baby),
  parents('PARENTS', 'Parents', FIcons.users),
  pets('PETS', 'Pets', FIcons.pawPrint),
  family('FAMILY', 'Family Shared', FIcons.house),
  social('SOCIAL', 'Social', FIcons.userPlus);

  final String key;
  final String label;
  final IconData icon;

  const TransactionSubject(this.key, this.label, this.icon);

  /// Get enum from key
  static TransactionSubject fromKey(String? key) {
    if (key == null || key.isEmpty) return self;
    try {
      return values.firstWhere((e) => e.key == key.toUpperCase());
    } catch (_) {
      return self;
    }
  }

  /// Get themed color based on theme
  Color themedColor(FThemeData theme) {
    const opacities = [1.0, 0.85, 0.7, 0.55, 0.4, 0.25, 0.15];
    final index = TransactionSubject.values.indexOf(this);
    final opacity = opacities[index % opacities.length];
    return theme.colors.primary.withValues(alpha: opacity);
  }
}

/// Transaction intent enum (4 items)
///
/// Corresponds to backend TransactionIntent enum
/// Answers "Why is this money spent?" - Financial health analysis
enum TransactionIntent {
  survival('SURVIVAL', 'Survival', FIcons.shieldCheck),
  enjoyment('ENJOYMENT', 'Enjoyment', FIcons.smile),
  development('DEVELOPMENT', 'Development', FIcons.trendingUp),
  obligation('OBLIGATION', 'Obligation', FIcons.fileCheck);

  final String key;
  final String label;
  final IconData icon;

  const TransactionIntent(this.key, this.label, this.icon);

  /// Get enum from key
  static TransactionIntent fromKey(String? key) {
    if (key == null || key.isEmpty) return survival;
    try {
      return values.firstWhere((e) => e.key == key.toUpperCase());
    } catch (_) {
      return survival; // Default to survival
    }
  }

  /// Get themed color based on theme
  Color themedColor(FThemeData theme) {
    const opacities = [1.0, 0.75, 0.5, 0.3];
    final index = TransactionIntent.values.indexOf(this);
    final opacity = opacities[index % opacities.length];
    return theme.colors.primary.withValues(alpha: opacity);
  }

  /// Get short description (for UI labels)
  String get shortDescription {
    switch (this) {
      case TransactionIntent.survival:
        return 'Necessity';
      case TransactionIntent.enjoyment:
        return 'Enjoyment';
      case TransactionIntent.development:
        return 'Investment';
      case TransactionIntent.obligation:
        return 'Obligation';
    }
  }
}
