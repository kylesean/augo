import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:augo/features/auth/models/user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserModel? user,
    String? token,
  }) = _AuthState;
}
