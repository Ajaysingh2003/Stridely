// // presentation/state/auth_state.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/user_entity.dart';
// import '../../domain/entities/auth_failure.dart';

// class AuthUIState {
//   final bool isLoading;
//   final UserEntity? user;
//   final AuthFailure? failure;

//   const AuthUIState({
//     this.isLoading = false,
//     this.user,
//     this.failure,
//   });


//   AuthUIState copyWith({
//     bool? isLoading,
//     UserEntity? user,
//     AuthFailure? failure,
//   }) {
//     return AuthUIState(
//       isLoading: isLoading ?? this.isLoading,
//       user: user ?? this.user,
//       failure: failure, 
//     );
//   }
// }




import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_failure.dart';

class AuthUIState {
  final bool isLoading;
  final UserEntity? user;
  final AuthFailure? failure;
  // final String? errorMessage;
  // final bool showSuccess;
  const AuthUIState({
    this.isLoading = false,
    this.user,
    this.failure,
    // this.errorMessage,
    // this.showSuccess = false,
  });


  AuthUIState copyWith({
    bool? isLoading,
    UserEntity? Function()? user,     
    AuthFailure? Function()? failure, 
  }) {
    return AuthUIState(
      isLoading: isLoading ?? this.isLoading,
      user: user != null ? user() : this.user,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUIState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          user == other.user &&
          failure == other.failure;

  @override
  int get hashCode => isLoading.hashCode ^ user.hashCode ^ failure.hashCode;
}