import 'dart:async';

import 'package:chat_application/Blocs/AuthBloc/auth_event.dart';
import 'package:chat_application/Blocs/AuthBloc/auth_state.dart';
import 'package:chat_application/Services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signIn(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signUp(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}
