import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import '../providers/verification_provider.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/i18n/strings.g.dart';

class RegisterStep1Page extends ConsumerStatefulWidget {
  const RegisterStep1Page({super.key});

  @override
  ConsumerState<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends ConsumerState<RegisterStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onSendCodePressed() async {
    final contact = _contactController.text;
    if (contact.isEmpty) {
      ToastService.showWarning(description: Text(t.auth.email.required));
      return;
    }
    await ref.read(verificationProvider.notifier).sendVerificationCode(contact);
  }

  Future<void> _onNextPressed() async {
    if (_formKey.currentState!.validate()) {
      unawaited(
        context.pushNamed(
          'registerStep2',
          extra: {
            'contact': _contactController.text,
            'verificationCode': _codeController.text,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final verificationState = ref.watch(verificationProvider);
    final bool isSendingCode =
        verificationState.status == VerificationStatus.sendingCode;

    ref.listen<VerificationState>(verificationProvider, (previous, next) {
      if (next.status == VerificationStatus.codeSent) {
        ToastService.success(description: Text(t.auth.verificationCode.sent));
      } else if (next.status == VerificationStatus.error &&
          next.errorMessage != null) {
        ToastService.showDestructive(
          title: Text(t.auth.verificationCode.sendFailed),
          description: Text(next.errorMessage!),
        );
      }
    });

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
                          t.auth.createAccount,
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
                          controller: _contactController,
                          label: Text(t.auth.email.label),
                          hint: t.auth.email.placeholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            final trimmedValue = value?.trim() ?? '';
                            if (trimmedValue.isEmpty) {
                              return t.auth.email.required;
                            }
                            final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
                            final emailRegex = RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            );
                            if (!phoneRegex.hasMatch(trimmedValue) &&
                                !emailRegex.hasMatch(trimmedValue)) {
                              return t.auth.email.invalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        FTextFormField(
                          controller: _codeController,
                          label: Text(t.auth.verificationCode.label),
                          hint: t.auth.verificationCode.placeholder,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          suffixBuilder: (context, style, child) =>
                              GestureDetector(
                                onTap: isSendingCode
                                    ? null
                                    : _onSendCodePressed,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    isSendingCode
                                        ? t.auth.verificationCode.sending
                                        : t.auth.verificationCode.get,
                                    style: TextStyle(
                                      color: isSendingCode
                                          ? theme.colors.mutedForeground
                                          : theme.colors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          validator: (value) => null,
                        ),
                        const SizedBox(height: 32),
                        FButton(
                          onPress: isSendingCode ? null : _onNextPressed,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSendingCode) ...[
                                SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colors.primaryForeground,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(t.wizard.nextStep),
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
