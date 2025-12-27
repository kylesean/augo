import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth_service.dart';

part 'verification_provider.g.dart';

enum VerificationStatus { initial, sendingCode, codeSent, error }

class VerificationState {
  final VerificationStatus status;
  final String? errorMessage;

  VerificationState({
    this.status = VerificationStatus.initial,
    this.errorMessage,
  });

  VerificationState copyWith({
    VerificationStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VerificationState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class Verification extends _$Verification {
  @override
  VerificationState build() {
    return VerificationState();
  }

  Future<void> sendVerificationCode(String contact) async {
    try {
      state = state.copyWith(
        status: VerificationStatus.sendingCode,
        clearError: true,
      );
      final authService = ref.read(authServiceProvider);
      await authService.sendVerificationCode(contact);
      state = state.copyWith(status: VerificationStatus.codeSent);
    } catch (e) {
      state = state.copyWith(
        status: VerificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = VerificationState();
  }
}
