import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:tabler_icons_next/tabler_icons_next.dart' as tabler;

/// Bottom navigation page - using Forui design system
///
/// Combines FScaffold + FBottomNavigationBar, following Forui best practices
/// Maintains original tabler icons usage for visual consistency
class BottomPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Use Forui theme access method
    final colors = context.theme.colors;

    return FScaffold(
      // Disable default content padding, maintain original full-screen layout
      childPad: false,
      // Use Forui bottom navigation bar
      footer: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: (index) => navigationShell.goBranch(index),
        children: [
          // Home
          FBottomNavigationBarItem(
            icon: _buildTablerIcon(
              icon: tabler.Home(
                width: 30,
                height: 30,
                strokeWidth: 1.4,
                color: colors.foreground,
              ),
              activeIcon: tabler.HomeFilled(
                width: 30,
                height: 30,
                strokeWidth: 1.4,
                color: colors.foreground,
              ),
              isActive: navigationShell.currentIndex == 0,
            ),
            label: const Text(''),
          ),
          // Explore
          FBottomNavigationBarItem(
            icon: _buildTablerIcon(
              icon: tabler.CreditCard(
                width: 30,
                height: 30,
                strokeWidth: 1.4,
                color: colors.foreground,
              ),
              activeIcon: tabler.CreditCardFilled(
                width: 30,
                height: 30,
                strokeWidth: 1.4,
                color: colors.foreground,
              ),
              isActive: navigationShell.currentIndex == 1,
            ),
            label: const Text(''),
          ),
          // AI Assistant
          FBottomNavigationBarItem(
            icon: _buildTablerIcon(
              icon: tabler.MessageChatbot(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              activeIcon: tabler.MessageChatbotFilled(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              isActive: navigationShell.currentIndex == 2,
            ),
            label: const Text(''),
          ),
          // Statistics
          FBottomNavigationBarItem(
            icon: _buildTablerIcon(
              icon: tabler.ChartPie3(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              activeIcon: tabler.ChartPie3Filled(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              isActive: navigationShell.currentIndex == 3,
            ),
            label: const Text(''),
          ),
          // Profile
          FBottomNavigationBarItem(
            icon: _buildTablerIcon(
              icon: tabler.User(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              activeIcon: tabler.UserFilled(
                strokeWidth: 1.4,
                width: 30,
                height: 30,
                color: colors.foreground,
              ),
              isActive: navigationShell.currentIndex == 4,
            ),
            label: const Text(''),
          ),
        ],
      ),
      // Main content area
      child: navigationShell,
    );
  }

  /// Build Tabler icon component
  ///
  /// Maintains original icon usage, displaying different icons based on active state
  Widget _buildTablerIcon({
    required Widget icon,
    required Widget activeIcon,
    required bool isActive,
  }) {
    return isActive ? activeIcon : icon;
  }
}
