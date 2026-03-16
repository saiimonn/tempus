part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final bool isPasswordVisible;
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    required this.isPasswordVisible,
    required this.status,
    this.errorMessage,
  });
  
  @override
  List<Object?> get props => [isPasswordVisible, status, errorMessage];

  const AuthState.initial()
    : isPasswordVisible = false,
      status = AuthStatus.initial,
      errorMessage = null;

  AuthState copyWith({
    bool? isPasswordVisible,
    AuthStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
