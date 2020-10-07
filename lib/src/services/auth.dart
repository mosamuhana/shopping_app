import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static AuthService _instance;
  static AuthService get instance => _instance ??= AuthService();

  Future<User> googleSignIn() async {
    try {
      final _googleSignIn = GoogleSignIn();
      final googleAccount = await _googleSignIn.signIn();
      final googleAuth = await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final cred = await FirebaseAuth.instance.signInWithCredential(credential);
      return cred.user;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }
}
