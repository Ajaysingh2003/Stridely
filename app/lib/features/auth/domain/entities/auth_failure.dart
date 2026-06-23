import 'package:equatable/equatable.dart';


import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Invalid email address.');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Incorrect password.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('No account found for this email.');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super('An account already exists for this email.');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password is too weak.');
}

class AccountExistsWithDifferentCredentialFailure extends AuthFailure {
  const AccountExistsWithDifferentCredentialFailure()
      : super('An account exists with a different sign-in method.');
}

class CancelledByUserFailure extends AuthFailure {
  const CancelledByUserFailure() : super('Sign-in was cancelled.');
}

class ServerFailure extends AuthFailure {
  const ServerFailure([String message = 'An unexpected error occurred.'])
      : super(message);
}