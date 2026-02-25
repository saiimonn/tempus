import 'package:flutter_bloc/flutter_bloc.dart';

sealed class PasswordVisibilityEvent {}

class ToggleVisibility extends PasswordVisibilityEvent {}

class HidePassword extends PasswordVisibilityEvent {}

class PasswordVisibilityBloc extends Bloc<PasswordVisibilityEvent, bool> {
  PasswordVisibilityBloc() : super(false) {
    on<ToggleVisibility>((event, emit) {
      emit(!state);
    });

    on<HidePassword>((event, emit) {
      emit(false);
    });
  }
}