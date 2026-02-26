import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:tempus/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tempus/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tempus/features/auth/domain/use_cases/sign_in.dart';
import 'package:tempus/features/auth/domain/use_cases/sign_up.dart';
import 'package:tempus/features/auth/presentation/bloc/auth_event.dart';
import 'package:tempus/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       super(const AuthState.initial()) {
    on<AuthPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<AuthPasswordVisibilityReset>(_onPasswordVisibilityReset);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthStatusResetRequested>(_onStatusResetRequested);
  }

  factory AuthBloc.create() {
    final dataSource = AuthRemoteDataSource(Supabase.instance.client);
    final repository = AuthRepositoryImpl(dataSource);

    return AuthBloc(
      signInUseCase: SignInUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
    );
  }

  void _onPasswordVisibilityToggled(
    AuthPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onPasswordVisibilityReset(
    AuthPasswordVisibilityReset event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: false));
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      await _signInUseCase(
        studentId: event.studentId,
        password: event.password,
      );

      emit(state.copyWith(status: AuthStatus.success, clearErrorMessage: true));
    } on AuthException catch (error) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      await _signUpUseCase(
        fullName: event.fullName,
        course: event.course,
        yearLevel: event.yearLevel,
        studentId: event.studentId,
        password: event.password,
      );

      emit(state.copyWith(status: AuthStatus.success, clearErrorMessage: true));
    } on AuthException catch (error) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  void _onStatusResetRequested(
    AuthStatusResetRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(status: AuthStatus.initial, clearErrorMessage: true));
  }
}
