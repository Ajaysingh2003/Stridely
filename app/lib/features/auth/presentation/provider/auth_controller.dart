// presentation/controllers/auth_controller.dart
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/usecases/get_current_user.dart';
import 'package:app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:app/features/auth/domain/usecases/sign_out.dart';
import 'package:app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:app/features/auth/presentation/state/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// import '../state/auth_ui_state.dart';

class AuthController extends StateNotifier<AuthUIState> {
  final SignInWithEmailUsecase _signInUseCase;
  final SignUpWithEmailUsecase _signUpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final GetCurrentUserUseCase _currentUser;
  final SignOutUseCase _signOutUseCase;
  AuthController(

    this._signInUseCase,
    this._signUpUseCase,
    this._signInWithGoogle,
    this._currentUser
    ,this._signOutUseCase
  ) : super(const AuthUIState());

  Future<UserEntity?> getCurrentUser() async {
    final results=await _currentUser.call();

      return results;
   }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _signOutUseCase.call();
      state = const AuthUIState(); 
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      user: () => null,
      failure: () => null,
    );

    final result = await _signInWithGoogle.call();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        failure: () => failure,
        user: () => null,
      ),

      (userEntity) => state = state.copyWith(
        isLoading: false,
        user: () => userEntity,
        failure: () => null,
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(
      isLoading: true,
      user: () => null,
      failure: () => null,
    );

    final result = await _signInUseCase.call(
      SignInWithEmailParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        failure: () => failure,
        user: () => null,
      ),

      (userEntity) => state = state.copyWith(
        isLoading: false,
        user: () => userEntity,
        failure: () => null,
      ),
    );
  }

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(
      isLoading: true,
      user: () => null,
      failure: () => null,
    );

    final result = await _signUpUseCase.call(
      SignUpWithEmailParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );

    result.fold(
      // 2. On failure: set loading false, assign failure, clear out old user traces
      (failure) => state = state.copyWith(
        isLoading: false,
        failure: () => failure,
        user: () => null,
      ),
      // 3. On success: set loading false, assign user, clear out old failure traces
      (userEntity) => state = state.copyWith(
        isLoading: false,
        user: () => userEntity,
        failure: () => null,
      ),
    );
  }
}
