import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/domain/usecases/get_session_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_in_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_out_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_up_usecase.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final GetSessionUsecase getSessionUsecase;
  final SignOutUsecase signOutUsecase;

  AuthBloc({
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.getSessionUsecase,
    required this.signOutUsecase,
  }) : super(AuthInitial()) {
    on<CheckSessionEvent>(_onCheckSession);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await getSessionUsecase.call();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } on DatabaseFailure catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError('Something went wrong'));
    }
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInUsecase.call(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } on DatabaseFailure catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError('Something went wrong'));
    }
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signUpUsecase.call(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      );
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } on DatabaseFailure catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError('Something went wrong'));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await signOutUsecase.call();
      emit(AuthUnauthenticated());
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } on DatabaseFailure catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError('Something went wrong'));
    }
  }
}
