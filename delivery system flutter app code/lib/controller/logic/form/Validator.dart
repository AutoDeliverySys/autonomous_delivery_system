// ignore_for_file: file_names

import 'package:delivery_system/controller/shared/constants/Constants.dart';

String? passwordValidator(String? pass) {
  if (pass == null || pass.isEmpty) {
    return "password must not be empty";
  } else if (pass.length < 8) {
    return "password is too short at least 8 characters password";
  } else if (RegExp(passRegex).matchAsPrefix(pass)==null) {
    return "invalid password";
  }
  return null;
}

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "invalid email ";
  } else if (RegExp(emailRegex).matchAsPrefix(email)==null) {
    return "invalid email";
  }
  return null;
}

String? usernameValidator(String? username) {
  if (username == null || username.isEmpty) {
    return "invalid username ";
  } else if (username.length < 4) {
    return "username too short";
  } else if (username.contains(r'[\.\$\[\]\\/!@#%^&\*\+\-\(\)]')) {
    return "username has invalid character";
  } else if (RegExp(r'\d+').matchAsPrefix(username)!=null) {
    return "numbers not allowed in the start of the username";
  } else if (RegExp(usernameRegex).matchAsPrefix(username)==null) {
    return "invalid username";
  }
  return null;
}
