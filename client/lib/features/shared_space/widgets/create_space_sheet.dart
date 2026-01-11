import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/shared_space_provider.dart';
import '../models/shared_space_models.dart';

class CreateSpaceSheet extends ConsumerStatefulWidget {
  final void Function(SharedSpace) onSpaceCreated;

  const CreateSpaceSheet({super.key, required this.onSpaceCreated});

  @override
  ConsumerState<CreateSpaceSheet> createState() => _CreateSpaceSheetState();
}

class _CreateSpaceSheetState extends ConsumerState<CreateSpaceSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter a space name');
      return false;
    }
    if (name.length < 2) {
      setState(() => _nameError = 'Space name must be at least 2 characters');
      return false;
    }
    if (name.length > 50) {
      setState(() => _nameError = 'Space name cannot exceed 50 characters');
      return false;
    }
    setState(() => _nameError = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag indicator
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: colors.border.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title area
              Text(
                'Create Shared Space',
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new shared space to track expenses with friends',
                textAlign: TextAlign.center,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),

              // Space name input
              FTextField(
                controller: _nameController,
                label: const Text('Space Name'),
                hint: 'e.g., Graduation Trip',
                onChange: (_) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
              ),
              if (_nameError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      _nameError!,
                      style: theme.typography.sm.copyWith(
                        color: colors.destructive,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Space description input
              FTextField(
                controller: _descriptionController,
                label: const Text('Description (Optional)'),
                hint: 'Track our joint travel expenses',
                maxLines: 2,
              ),

              const SizedBox(height: 48),

              // Button area
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.outline(),
                      onPress: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: _isLoading ? null : _createSpace,
                      child: _isLoading
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createSpace() async {
    if (!_validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final space = await ref
          .read(sharedSpaceProvider.notifier)
          .createSpace(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (space != null) {
        widget.onSpaceCreated(space);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
