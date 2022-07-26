// ignore_for_file: file_names

import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart'
    as user_entity;
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static user_entity.User? _accountFromFirebaseUser(User? user) {
    return user == null ? null : user_entity.User(user.uid);
  }

  static Stream<user_entity.User?> get user =>
      _auth.authStateChanges().map(_accountFromFirebaseUser);

  ///  SignIn anonymous
  static Future<User?> signInAnonymously() async {
    try {
      User? user = await _auth.signInAnonymously().then((data) => data.user);
      return user;
    } catch (e) {
      return null;
    }
  }

  ///  SignIn email and password
  static Future<user_entity.User?> signInWithEmailPassword(String email, String pass) async {
    try {
      var data = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return _accountFromFirebaseUser(data.user);
    } catch (e) {
      return null;
    }
  }

  /// sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  /// register with email and password
  static Future<user_entity.User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      var data = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var u = data.user;
      if (u == null) {
        return null;
      } else {
        return user_entity.User(u.uid);
      }
    } catch (_) {
      return null;
    }
  }

// TODO: reset the password by sending a verification code to email then confirm

}
