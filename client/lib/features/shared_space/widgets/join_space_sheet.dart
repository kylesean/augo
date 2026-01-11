import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/shared_space_provider.dart';
import '../models/shared_space_models.dart';

class JoinSpaceSheet extends ConsumerStatefulWidget {
  final Function(SharedSpace) onSpaceJoined;
  final String? initialCode;

  const JoinSpaceSheet({
    super.key,
    required this.onSpaceJoined,
    this.initialCode,
  });

  @override
  ConsumerState<JoinSpaceSheet> createState() => _JoinSpaceSheetState();
}

class _JoinSpaceSheetState extends ConsumerState<JoinSpaceSheet> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _codeError;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 如果有初始邀请码，设置到输入框中
    if (widget.initialCode != null) {
      _codeController.text = widget.initialCode!.toUpperCase();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  bool _validate() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _codeError = '请输入邀请码');
      return false;
    }
    if (code.length < 6 || code.length > 16) {
      setState(() => _codeError = '邀请码格式不正确');
      return false;
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
      setState(() => _codeError = '邀请码只能包含字母和数字');
      return false;
    }
    setState(() => _codeError = null);
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
              // 顶部拖拽指示器
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: colors.border.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 标题区域
              Text(
                '加入共享空间',
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '输入朋友分享的邀请码，立即开启协同记账',
                textAlign: TextAlign.center,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),

              // 邀请码输入
              FTextField(
                controller: _codeController,
                label: const Text('邀请码'),
                hint: '请输入邀请码，例如：A8K2F9G7',
                onChange: (value) {
                  if (_codeError != null || _errorMessage != null) {
                    setState(() {
                      _codeError = null;
                      _errorMessage = null;
                    });
                  }
                  final upperValue = value.toUpperCase();
                  if (upperValue != value) {
                    _codeController.value = _codeController.value.copyWith(
                      text: upperValue,
                      selection: TextSelection.collapsed(
                        offset: upperValue.length,
                      ),
                    );
                  }
                },
              ),
              if (_codeError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      _codeError!,
                      style: theme.typography.sm.copyWith(
                        color: colors.destructive,
                      ),
                    ),
                  ),
                ),

              // 错误信息显示
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                FAlert(
                  style: FAlertStyle.destructive(),
                  icon: const Icon(FIcons.circleAlert, size: 16),
                  title: Text(_errorMessage!),
                ),
              ],

              const SizedBox(height: 48),

              // 按钮区域
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.outline(),
                      onPress: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: _isLoading ? null : _joinSpace,
                      child: _isLoading
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('加入'),
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

  Future<void> _joinSpace() async {
    if (!_validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final space = await ref
          .read(sharedSpaceProvider.notifier)
          .joinSpaceWithCode(_codeController.text.trim().toUpperCase());

      if (space != null) {
        widget.onSpaceJoined(space);
      } else {
        // 如果返回null，说明有错误，错误信息已经在provider中处理
        final error = ref.read(sharedSpaceProvider).error;
        if (error != null) {
          setState(() {
            _errorMessage = error;
          });
        }
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
