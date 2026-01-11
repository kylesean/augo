import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../providers/auth_provider.dart';
import '../providers/verification_provider.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/i18n/strings.g.dart';

class RegisterStep2Page extends ConsumerStatefulWidget {
  final String contact;
  final String verificationCode;

  const RegisterStep2Page({
    super.key,
    required this.contact,
    required this.verificationCode,
  });

  @override
  ConsumerState<RegisterStep2Page> createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends ConsumerState<RegisterStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .register(
            account: widget.contact,
            password: _passwordController.text,
            verificationCode: widget.verificationCode,
          );
      if (!mounted) return;

      ToastService.success(description: Text(t.auth.registrationSuccess));

      ref.read(verificationProvider.notifier).reset();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      context.pushReplacement('/home');
    } on AppException catch (e) {
      if (!mounted) return;
      ToastService.showDestructive(
        title: Text(t.auth.registrationFailed),
        description: Text(e.message),
      );
    } catch (e) {
      if (!mounted) return;
      ToastService.showDestructive(
        title: Text(t.error.unknownError),
        description: Text(e.toString()),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FScaffold(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          t.auth.setAccountPassword,
                          style: theme.typography.xl2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.auth.loginSubtitle,
                          style: theme.typography.sm.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        FTextFormField.password(
                          controller: _passwordController,
                          label: Text(t.auth.password.label),
                          hint: t.auth.password.placeholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.auth.password.required;
                            }
                            if (value.length < 6) {
                              return t.auth.password.tooShort;
                            }
                            if (!value.contains(RegExp(r'[0-9]')) ||
                                !value.contains(RegExp(r'[a-zA-Z]'))) {
                              return t
                                  .auth
                                  .password
                                  .mustContainNumbersAndLetters;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        FTextFormField.password(
                          controller: _confirmPasswordController,
                          label: Text(t.auth.password.confirm),
                          hint: t.auth.password.confirmPlaceholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.auth.password.required;
                            }
                            if (value != _passwordController.text) {
                              return t.auth.password.mismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        FButton(
                          onPress: _isLoading ? null : _onRegisterPressed,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isLoading) ...[
                                SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colors.primaryForeground,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                _isLoading
                                    ? t.auth.registering
                                    : t.auth.completeRegistration,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 8,
            child: FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: () => context.pop(),
              child: const Icon(FIcons.chevronLeft),
            ),
          ),
        ],
      ),
    );
  }
}
