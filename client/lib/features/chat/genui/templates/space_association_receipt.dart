import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';

/// SpaceAssociationReceipt Data Layer
class SpaceAssociationReceiptData {
  final Map<String, dynamic> space;
  final Map<String, dynamic> association;
  final String surfaceId;
  final String? message;

  SpaceAssociationReceiptData({
    required this.space,
    required this.association,
    required this.surfaceId,
    this.message,
  });

  factory SpaceAssociationReceiptData.fromJson(Map<String, dynamic> json) {
    return SpaceAssociationReceiptData(
      space: (json['space'] as Map<String, dynamic>?) ?? {},
      association: (json['association'] as Map<String, dynamic>?) ?? {},
      surfaceId: json['_surfaceId'] as String? ?? 'unknown',
      message: json['message'] as String?,
    );
  }

  String get spaceName => space['name'] as String? ?? '共享空间';
  int get spaceId => space['id'] as int? ?? 0;
  int get totalCount => association['total_count'] as int? ?? 0;
  int get successCount => association['success_count'] as int? ?? 0;
  int get failedCount => association['failed_count'] as int? ?? 0;
  bool get isFullySuccessful => failedCount == 0 && successCount > 0;
}

/// SpaceAssociationReceipt - Confirmation component after space association
///
/// Displayed after user selects a space from SpaceSelectorCard
/// and direct_execute completes the association.
class SpaceAssociationReceipt extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent) dispatchEvent;

  const SpaceAssociationReceipt({
    super.key,
    required this.data,
    required this.dispatchEvent,
  });

  @override
  Widget build(BuildContext context) {
    final model = SpaceAssociationReceiptData.fromJson(data);
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
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
              _buildHeader(model, theme, colors),
              const SizedBox(height: 20),
              _buildContent(model, theme, colors),
              if (model.message != null) ...[
                const SizedBox(height: 16),
                _buildMessage(model.message!, theme, colors),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    SpaceAssociationReceiptData model,
    FThemeData theme,
    FColors colors,
  ) {
    final semantic = theme.semantic;
    final isSuccess = model.isFullySuccessful;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSuccess
                ? semantic.successBackground
                : semantic.warningBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSuccess ? FIcons.check : FIcons.triangleAlert,
            color: isSuccess ? semantic.successAccent : semantic.warningAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '关联成功',
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '已关联到「${model.spaceName}」',
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    SpaceAssociationReceiptData model,
    FThemeData theme,
    FColors colors,
  ) {
    final semantic = theme.semantic;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: '总计',
            value: model.totalCount.toString(),
            theme: theme,
            colors: colors,
          ),
          Container(
            width: 1,
            height: 40,
            color: colors.border.withValues(alpha: 0.5),
          ),
          _buildStatItem(
            label: '成功',
            value: model.successCount.toString(),
            valueColor: semantic.successAccent,
            theme: theme,
            colors: colors,
          ),
          if (model.failedCount > 0) ...[
            Container(
              width: 1,
              height: 40,
              color: colors.border.withValues(alpha: 0.5),
            ),
            _buildStatItem(
              label: '失败',
              value: model.failedCount.toString(),
              valueColor: colors.destructive,
              theme: theme,
              colors: colors,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    Color? valueColor,
    required FThemeData theme,
    required FColors colors,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: theme.typography.xl.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? colors.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.typography.xs.copyWith(color: colors.mutedForeground),
        ),
      ],
    );
  }

  Widget _buildMessage(String message, FThemeData theme, FColors colors) {
    final semantic = theme.semantic;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: semantic.successBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(FIcons.check, size: 16, color: semantic.successAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.typography.sm.copyWith(
                color: semantic.successAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
