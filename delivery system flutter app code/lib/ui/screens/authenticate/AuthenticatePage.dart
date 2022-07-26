// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedData.dart';
import 'package:delivery_system/controller/logic/form/Validator.dart';
import 'package:delivery_system/ui/screens/authenticate/AuthenticatePageFunctions.dart';
import 'package:delivery_system/ui/shared/constants/modes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class AuthenticatePage extends StatelessWidget {
  const AuthenticatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      savedEmail: savedEmail,
      savedPassword: savedPassword,
      // userValidator: emailValidator,
      passwordValidator: passwordValidator,
      hideForgotPasswordButton: true,
      onRecoverPassword: (string) => null,
      logo: "assets/images/logo.png",
      loginAfterSignUp: false,
      onLogin: login,
      onSignup: signup,
      theme: LoginTheme(
        errorColor: modeColors[3][2],
        accentColor: modeColors[1][1],
        primaryColor: modeColors[0][1],
      ),
      onConfirmSignup: (string, loginData) => null,
      additionalSignupFields: const [
        UserFormField(keyName: "username", fieldValidator: usernameValidator)
      ],
    );
  }
}
