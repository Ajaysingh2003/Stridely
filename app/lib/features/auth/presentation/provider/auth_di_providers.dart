
import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:app/features/auth/domain/repository/auth_repository_impl.dart';
import 'package:app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:app/features/auth/presentation/provider/auth_controller.dart';
import 'package:app/features/auth/presentation/state/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../controllers/auth_controller.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authDataSourceProvider = Provider((ref) => 
  AuthRemoteDatasource(ref.watch(firebaseAuthProvider))
);

final authRepositoryProvider = Provider<AuthRepository>((ref) => 
  AuthRepositoryImpl(ref.watch(authDataSourceProvider))
);

final signInWithEmailUseCaseProvider = Provider((ref) => 
  SignInWithEmailUsecase(ref.watch(authRepositoryProvider))
);

final signUpWithEmailUseCaseProvider = Provider((ref) => 
  SignUpWithEmailUsecase(ref.watch(authRepositoryProvider))
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthUIState>((ref) {
  return AuthController(ref.watch(signInWithEmailUseCaseProvider),ref.watch(signUpWithEmailUseCaseProvider));
});

final authStateStreamProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
