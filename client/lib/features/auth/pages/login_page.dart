import 'dart:async';
import 'package:augo/core/network/exceptions/app_exception.dart';
import 'package:augo/features/auth/providers/auth_provider.dart';
import 'package:augo/features/auth/providers/verification_provider.dart'; // Import new verification code Provider
import 'package:augo/shared/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/i18n/strings.g.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Local loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // Call the Notifier's login method, which rethrows exceptions on failure
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      // If await passes successfully, login was successful
      if (!mounted) return;

      // Show success message
      ToastService.success(description: Text(t.auth.loginSuccess));

      // Delay briefly before navigation to ensure state updates complete
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      // Use pushReplacement instead of go to avoid returning to login page
      if (mounted) {
        unawaited(GoRouter.of(this.context).pushReplacement('/home'));
      }
    } on AppException catch (e) {
      if (!mounted) return;
      ToastService.showDestructive(
        title: Text(t.auth.loginFailed),
        description: Text(e.message),
      );
    } catch (e) {
      if (!mounted) return;
      ToastService.showDestructive(
        title: Text(t.error.unknownError),
        description: Text(t.auth.pleaseTryAgain),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                          t.auth.welcomeBack,
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
                        FTextFormField.email(
                          controller: _emailController,
                          label: Text(t.auth.email.label),
                          hint: t.auth.email.placeholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.auth.email.required;
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return t.auth.email.invalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        FTextFormField.password(
                          controller: _passwordController,
                          label: Text(t.auth.password.label),
                          hint: t.auth.password.placeholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.auth.password.required;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        FButton(
                          onPress: _isLoading
                              ? null
                              : () => _onLoginPressed(context),
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
                                _isLoading ? t.auth.loggingIn : t.auth.login,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        FButton(
                          style: FButtonStyle.ghost(),
                          onPress: () {
                            // Reset verification code state to avoid state residue when entering registration process next time
                            ref.read(verificationProvider.notifier).reset();
                            context.pushNamed('registerStep1');
                          },
                          child: Text(t.auth.noAccount),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, left: 0, child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
