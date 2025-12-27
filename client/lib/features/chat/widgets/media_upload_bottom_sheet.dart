// features/chat/widgets/media_upload_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';
import '../services/media_picker_service.dart';
import '../../../../i18n/strings.g.dart';

/// Media upload bottom sheet interface
/// Simplified three-option UI layout: camera, photos, files
class MediaUploadBottomSheet {
  /// Show media selection menu
  static Future<void> show(
    BuildContext context, {
    required Function(List<XFile>) onFilesSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return _MediaSelectionSheet(onFilesSelected: onFilesSelected);
      },
    );
  }
}

/// Media selection interface component
class _MediaSelectionSheet extends StatelessWidget {
  final Function(List<XFile>) onFilesSelected;

  const _MediaSelectionSheet({required this.onFilesSelected});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Three options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Camera
                Expanded(
                  child: _buildOptionButton(
                    theme,
                    colors,
                    t.media.camera,
                    FIcons.camera,
                    () => _handleTakePhoto(context),
                  ),
                ),
                const SizedBox(width: 12),

                // Photos
                Expanded(
                  child: _buildOptionButton(
                    theme,
                    colors,
                    t.media.photos,
                    FIcons.image,
                    () => _handleSelectPhotos(context),
                  ),
                ),
                const SizedBox(width: 12),

                // Files
                Expanded(
                  child: _buildOptionButton(
                    theme,
                    colors,
                    t.media.files,
                    FIcons.paperclip,
                    () => _handleSelectFiles(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Build option button
  Widget _buildOptionButton(
    FThemeData theme,
    FColors colors,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: colors.foreground),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.typography.base.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle take photo
  void _handleTakePhoto(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = context.theme.colors.destructive;
    Navigator.of(context).pop();

    MediaPickerService.takePhoto()
        .then((photo) {
          onFilesSelected([photo]);
        })
        .catchError((e) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text('${t.common.error}: $e'),
              backgroundColor: errorColor,
            ),
          );
        });
  }

  /// Handle select photos
  void _handleSelectPhotos(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = context.theme.colors.destructive;
    Navigator.of(context).pop();

    MediaPickerService.pickGalleryPhotos()
        .then((photos) {
          if (photos.isNotEmpty) {
            onFilesSelected(photos);
          }
        })
        .catchError((e) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text('${t.common.error}: $e'),
              backgroundColor: errorColor,
            ),
          );
        });
  }

  /// Handle select files
  void _handleSelectFiles(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = context.theme.colors.destructive;
    Navigator.of(context).pop();

    MediaPickerService.pickFiles()
        .then((files) {
          if (files.isNotEmpty) {
            onFilesSelected(files);
          }
        })
        .catchError((e) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text('${t.common.error}: $e'),
              backgroundColor: errorColor,
            ),
          );
        });
  }
}
