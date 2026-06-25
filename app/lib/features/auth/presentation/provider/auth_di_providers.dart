import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/domain/repository/auth_repository.dart';
import 'package:app/features/auth/domain/repository/auth_repository_impl.dart';
import 'package:app/features/auth/domain/usecases/get_current_user.dart';
import 'package:app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:app/features/auth/domain/usecases/sign_out.dart';
import 'package:app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:app/features/auth/presentation/provider/auth_controller.dart';
import 'package:app/features/auth/presentation/state/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../controllers/auth_controller.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authDataSourceProvider = Provider(
  (ref) => AuthRemoteDatasource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authDataSourceProvider)),
);


final signInWithEmailUseCaseProvider = Provider(
  (ref) => SignInWithEmailUsecase(ref.watch(authRepositoryProvider)),
);

final signUpWithEmailUseCaseProvider = Provider(
  (ref) => SignUpWithEmailUsecase(ref.watch(authRepositoryProvider)),
);

final signInWithGoogleUseCaseProvider = Provider(
  (ref) => SignInWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

final getCurrentUserUsecases = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);
final signOutUseCase = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);


final authControllerProvider =
    StateNotifierProvider<AuthController, AuthUIState>((ref) {
      return AuthController(
        ref.watch(signInWithEmailUseCaseProvider),
        ref.watch(signUpWithEmailUseCaseProvider),
        ref.watch(signInWithGoogleUseCaseProvider),
        ref.watch(getCurrentUserUsecases),
        ref.watch(signOutUseCase),

      );
    });

final authStateStreamProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
