import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/auth_exception_handler.dart';
import 'package:pro_book/custom_exception.dart';
import 'package:pro_book/general_providers.dart';

abstract class BaseAuthenticationService {
  Stream<User?> get userChanges;
  Future<void> signInWithEmail(
      String email, String password, BuildContext context);
  Future<void> signUpWithEmail(
      String email, String password, BuildContext context);
  Future<void> signInWithGoogle(BuildContext context);
  User? getCurrentUser();
  String? getCurrentUID();
  Future<void> signOut();
}

final authServiceProvider =
    Provider<AuthenticatioSevice>((ref) => AuthenticatioSevice(ref.read));

class AuthenticatioSevice implements BaseAuthenticationService {
  final Reader _read;

  const AuthenticatioSevice(this._read);

  @override
  Stream<User?> get userChanges => _read(firebaseAuthProvider).userChanges();

  @override
  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw ErrorHandler.errorDialog(context, e);
    }
  }

  @override
  Future<void> signUpWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw ErrorHandler.errorDialog(context, e);
    }
  }

  @override
  User? getCurrentUser() {
    return _read(firebaseAuthProvider).currentUser;
  }

  @override
  Future<void> signOut() async {
    await _read(firebaseAuthProvider).signOut();
    GoogleSignIn().disconnect();
  }

  @override
  String? getCurrentUID() {
    return _read(firebaseAuthProvider).currentUser!.uid;
  }

  @override
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _read(firebaseAuthProvider).signInWithCredential(credential);
    } on PlatformException catch (e) {
      throw CustomExeption(message: e.message);
    }
  }
}
