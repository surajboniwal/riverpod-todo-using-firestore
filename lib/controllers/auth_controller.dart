import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/repositories/auth_repository.dart';

class AuthController extends StateNotifier<User?> {
  final Reader _read;
  StreamSubscription<User?>? _authStateSubscription;

  AuthController(this._read) : super(null) {
    _authStateSubscription?.cancel();
    state = _read(AuthRepository.authRepositoryProvider).getCurrentUser;
    _authStateSubscription = _read(AuthRepository.authRepositoryProvider).authStateChanges.listen((event) {
      state = event;
    });
  }

  static final authControllerProvider = StateNotifierProvider<AuthController, User?>((ref) {
    return AuthController(ref.read);
  });

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void signInWithGoogle() {
    _read(AuthRepository.authRepositoryProvider).signInWithGoogle();
  }

  void signOut() {
    _read(AuthRepository.authRepositoryProvider).signOut();
  }
}
