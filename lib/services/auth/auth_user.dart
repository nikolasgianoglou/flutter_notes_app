import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable //This tells dart that this class and all subclass that implements them cant change
class AuthUser{
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified);
}

