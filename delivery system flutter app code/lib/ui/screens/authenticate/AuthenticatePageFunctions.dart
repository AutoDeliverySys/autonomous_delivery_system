// ignore_for_file: file_names

import 'package:delivery_system/controller/logic/database/Database.dart';
import 'package:delivery_system/controller/services/firebase/authentication/auth.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UsersOperations.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import 'package:flutter_login/flutter_login.dart';

Future<String?> login(LoginData data) async {
  String email = data.name;
  String pass = data.password;
  User? user = await Future.delayed(smallDelay)
      .then((value) => AuthServices.signInWithEmailPassword(email, pass));
  if (user == null) {
    return "Invalid email or password";
  }
  getAndSaveUserDataByKey(user.uid);
  return null;
}

Future<String?>? signup(SignupData data) async {
  String? username = data.additionalSignupData?.values.elementAt(0).trim().toLowerCase();
  String? email = data.name;
  String? pass = data.password;

  return getUserByUsername(username!).then((user) async {
    if (user != null) {
      return "username is already used";
    } else {
      var user = await Future.delayed(averageDelay)
          .then((_) => AuthServices.registerWithEmailAndPassword(email ?? "", pass ?? ""));
      if (user == null) {
        return "email is already used";
      }
      createNewUser(uid: user.uid, username: username);
      getAndSaveUserDataByKey(user.uid);
      return null;
    }
  });
}
