import 'package:flutter/foundation.dart';

@immutable
abstract class AuthFailure {
  final String message;
  const AuthFailure(this.message);
}

class InvalidEmailAndPasswordFailure extends AuthFailure {
  const InvalidEmailAndPasswordFailure(super.message);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure(super.message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure(super.message);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure(super.message);
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure(super.message);
}
