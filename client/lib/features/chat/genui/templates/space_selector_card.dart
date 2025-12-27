import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:augo/i18n/strings.g.dart';

/// SpaceSelectorCard Data Layer
class SpaceSelectorData {
  final List<Map<String, dynamic>> matchedSpaces;
  final List<Map<String, dynamic>> allSpaces;
  final List<String> pendingTransactionIds;
  final String surfaceId;
  final String? matchKeyword;
  final String? message;
  final bool isConfirmed;

  SpaceSelectorData({
    required this.matchedSpaces,
    required this.allSpaces,
    required this.pendingTransactionIds,
    required this.surfaceId,
    this.matchKeyword,
    this.message,
    this.isConfirmed = false,
  });

  factory SpaceSelectorData.fromJson(Map<String, dynamic> json) {
    return SpaceSelectorData(
      matchedSpaces: (json['matched_spaces'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      allSpaces: (json['all_spaces'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      pendingTransactionIds: (json['pending_transaction_ids'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      surfaceId: json['_surfaceId'] as String? ?? 'unknown',
      matchKeyword: json['match_keyword'] as String?,
      message: json['message'] as String?,
      isConfirmed: json['_isConfirmed'] == true,
    );
  }

  /// Get the spaces to display (matched spaces if available, otherwise all)
  List<Map<String, dynamic>> get displaySpaces =>
      matchedSpaces.isNotEmpty ? matchedSpaces : allSpaces;
}

/// SpaceSelectorCard - GenUI Component for shared space selection
///
/// Following GenUI 4-layer architecture:
/// - Data Layer: SpaceSelectorData
/// - Widget Layer: SpaceSelectorCard (this file)
/// - Event Layer: space_events.dart
/// - Registry Layer: genui_event_registry.dart
class SpaceSelectorCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent) dispatchEvent;

  const SpaceSelectorCard({
    super.key,
    required this.data,
    required this.dispatchEvent,
  });

  @override
  State<SpaceSelectorCard> createState() => _SpaceSelectorCardState();
}

class _SpaceSelectorCardState extends State<SpaceSelectorCard> {
  // Static cache for confirmed state persistence across rebuilds
  static final Map<String, int?> _confirmedSpaceCache = {};

  late SpaceSelectorData _model;
  int? _selectedSpaceId;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _model = SpaceSelectorData.fromJson(widget.data);

    // Restore from cache if available
    final cachedSpaceId = _confirmedSpaceCache[_model.surfaceId];
    if (cachedSpaceId != null) {
      _selectedSpaceId = cachedSpaceId;
      _isConfirmed = true;
    } else if (_model.isConfirmed) {
      _isConfirmed = true;
    }
  }

  bool get _isValid => _selectedSpaceId != null;

  Map<String, dynamic>? get _selectedSpace {
    if (_selectedSpaceId == null) return null;
    try {
      return _model.displaySpaces.firstWhere(
        (s) => s['id'] == _selectedSpaceId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(theme, colors),
              const SizedBox(height: 16),
              if (_model.message != null) ...[
                _buildMessage(theme, colors),
                const SizedBox(height: 16),
              ],
              _buildSpaceList(theme, colors),
              const SizedBox(height: 24),
              _buildConfirmButton(theme, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(FIcons.users, color: colors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          t.chat.genui.transactionGroupReceipt.selectSpace,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        if (_isConfirmed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.semantic.successBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FIcons.check,
                  color: theme.semantic.successAccent,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  t.chat.genui.spaceSelector.selected,
                  style: theme.typography.xs.copyWith(
                    color: theme.semantic.successAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMessage(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(FIcons.info, size: 16, color: colors.mutedForeground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _model.message!,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceList(FThemeData theme, FColors colors) {
    final spaces = _model.displaySpaces;

    if (spaces.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.muted.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            t.chat.genui.transactionCard.noSpace,
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
        ),
      );
    }

    return Column(
      children: spaces.map((space) {
        final spaceId = space['id'] as int?;
        final isSelected = _selectedSpaceId == spaceId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSpaceItem(
            space: space,
            isSelected: isSelected,
            theme: theme,
            colors: colors,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpaceItem({
    required Map<String, dynamic> space,
    required bool isSelected,
    required FThemeData theme,
    required FColors colors,
  }) {
    final spaceId = space['id'] as int?;
    final name =
        space['name'] as String? ?? t.chat.genui.spaceSelector.unnamedSpace;
    final description = space['description'] as String?;
    final role = space['role'] as String?;

    return GestureDetector(
      onTap: _isConfirmed
          ? null
          : () {
              setState(() {
                _selectedSpaceId = spaceId;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.muted.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.5)
                : colors.border.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.mutedForeground,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Space info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? colors.primary
                              : colors.foreground,
                        ),
                      ),
                      if (role != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(
                              role,
                              colors,
                              theme.semantic,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getRoleLabel(role),
                            style: theme.typography.xs.copyWith(
                              color: _getRoleColor(
                                role,
                                colors,
                                theme.semantic,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Check icon for selected
            if (isSelected && !_isConfirmed)
              Icon(FIcons.check, size: 18, color: colors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(FThemeData theme, FColors colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: FButton(
        onPress: _isValid && !_isConfirmed ? _onConfirm : null,
        style: _isConfirmed ? FButtonStyle.outline() : FButtonStyle.primary(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isConfirmed) ...[
              const Icon(FIcons.link, size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              _isConfirmed
                  ? t.chat.genui.spaceSelector.linked
                  : t.chat.genui.transactionGroupReceipt.confirmAssociate,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role, FColors colors, AppSemanticColors semantic) {
    switch (role.toLowerCase()) {
      case 'owner':
        return semantic.warningAccent;
      case 'admin':
        return colors.primary;
      default:
        return colors.mutedForeground;
    }
  }

  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return t.chat.genui.spaceSelector.roleOwner;
      case 'admin':
        return t.chat.genui.spaceSelector.roleAdmin;
      case 'member':
        return t.chat.genui.spaceSelector.roleMember;
      default:
        return role;
    }
  }

  void _onConfirm() {
    if (_selectedSpaceId == null) return;

    setState(() => _isConfirmed = true);

    // Cache the selection
    _confirmedSpaceCache[_model.surfaceId] = _selectedSpaceId;

    final selectedSpace = _selectedSpace;

    widget.dispatchEvent(
      UserActionEvent(
        name: 'space_selected',
        sourceComponentId: 'SpaceSelectorCard',
        context: {
          'surface_id': _model.surfaceId,
          'space_id': _selectedSpaceId,
          'space_name': selectedSpace?['name'] ?? '',
          'transaction_ids': _model.pendingTransactionIds,
        },
      ),
    );
  }
}
