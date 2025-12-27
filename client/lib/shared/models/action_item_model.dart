// shared/models/action_item_model.dart (or similar location)
import 'package:flutter/material.dart';

class ActionItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color; // To override theme color if needed
  final bool isDestructive; // New field

  ActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.isDestructive = false, // Default to false
  });
}
