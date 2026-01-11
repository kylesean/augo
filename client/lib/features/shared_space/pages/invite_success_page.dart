import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../shared/services/toast_service.dart';
import '../models/shared_space_models.dart';
import '../services/shared_space_service.dart';
import 'dart:async';

class InviteSuccessPage extends ConsumerStatefulWidget {
  final SharedSpace space;

  const InviteSuccessPage({super.key, required this.space});

  @override
  ConsumerState<InviteSuccessPage> createState() => _InviteSuccessPageState();
}

class _InviteSuccessPageState extends ConsumerState<InviteSuccessPage> {
  InviteCode? _inviteCode;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_generateInviteCode());
  }

  Future<void> _generateInviteCode() async {
    try {
      final service = ref.read(sharedSpaceServiceProvider);
      final inviteCode = await service.generateInviteCode(widget.space.id);
      if (mounted) {
        setState(() {
          _inviteCode = inviteCode;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[InviteSuccessPage] Error: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to generate invite code';
          _isLoading = false;
        });
      }
    }
  }

  void _copyCode() {
    if (_inviteCode != null) {
      unawaited(Clipboard.setData(ClipboardData(text: _inviteCode!.code)));
      ToastService.show(description: const Text('Invite code copied'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('Created Successfully', style: theme.typography.lg),
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        elevation: 0,
        centerTitle: true,
        leading: FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: () => context.pop(),
          child: const Icon(FIcons.x, size: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Compact success indicator
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(FIcons.check, size: 24, color: colors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Space Created Successfully',
                          style: theme.typography.lg.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.space.name,
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Invite code content area
              Expanded(child: _buildContent(context)),

              // Bottom buttons
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.outline(),
                      onPress: () {
                        context.pop();
                        context.pop();
                      },
                      child: const Text('Invite Later'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: () {
                        context.pop();
                        unawaited(
                          context.push(
                            '/profile/shared-space/${widget.space.id}',
                          ),
                        );
                      },
                      child: const Text('Enter Space'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.primary),
            const SizedBox(height: 16),
            Text(
              'Generating invite code...',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FIcons.circleAlert, size: 48, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              'Failed to generate invite code',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            FButton(
              style: FButtonStyle.outline(),
              onPress: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                unawaited(_generateInviteCode());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_inviteCode == null) return const SizedBox.shrink();

    // Success state: show invite code and QR code
    return SingleChildScrollView(
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.border.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: 'augo://join-space/${_inviteCode!.code}',
              version: QrVersions.auto,
              size: 180,
              padding: EdgeInsets.zero,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: colors.foreground,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: colors.foreground,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Invite Code
          Text(
            'Invite Code',
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _copyCode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _inviteCode!.code,
                    style: theme.typography.xl2.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(FIcons.copy, size: 18, color: colors.mutedForeground),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Valid for 24 hours · Tap to copy',
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
