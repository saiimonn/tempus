sealed class AuthEvent {
  const AuthEvent();
}

class AuthPasswordVisibilityToggled extends AuthEvent {
  const AuthPasswordVisibilityToggled();
}

class AuthPasswordVisibilityReset extends AuthEvent {
  const AuthPasswordVisibilityReset();
}

class AuthSignInRequested extends AuthEvent {
  final String studentId;
  final String password;

  const AuthSignInRequested({required this.studentId, required this.password});
}

class AuthSignUpRequested extends AuthEvent {
  final String fullName;
  final String course;
  final String yearLevel;
  final String studentId;
  final String password;

  const AuthSignUpRequested({
    required this.fullName,
    required this.course,
    required this.yearLevel,
    required this.studentId,
    required this.password,
  });
}

class AuthStatusResetRequested extends AuthEvent {
  const AuthStatusResetRequested();
}
