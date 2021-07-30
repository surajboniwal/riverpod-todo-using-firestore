import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_test/providers/firebase_providers.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithGoogle();
  User? get getCurrentUser;
  Future<void> signOut();
}

class AuthRepository implements BaseAuthRepository {
  AuthRepository(this._read);
  Reader _read;

  static final authRepositoryProvider = Provider<AuthRepository>((ref) {
    return AuthRepository(ref.read);
  });

  @override
  Stream<User?> get authStateChanges => _read(FirebaseProviders.firebaseAuthProvider).authStateChanges();

  @override
  User? get getCurrentUser => _read(FirebaseProviders.firebaseAuthProvider).currentUser;

  @override
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication _googleAuth = await _googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );
    await _read(FirebaseProviders.firebaseAuthProvider).signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    _read(FirebaseProviders.firebaseAuthProvider).signOut();
  }
}
