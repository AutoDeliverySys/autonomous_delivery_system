// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/services/firebase/authentication/auth.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UsersOperations.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import 'package:delivery_system/ui/shared/constants/modes.dart';
import 'package:flutter/material.dart';

class ProfilePageFunctions {
  BuildContext context;
  Function(Function()) setState;

  ProfilePageFunctions({required this.context, required this.setState});

  final TextEditingController usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  IconData editIcon = Icons.edit;
  bool isEnable = false;

  back() => Navigator.pop(context);

  logout() {
    back();
    AuthServices.signOut();
  }

  _changeEditUsernameState() {
    setState(() {
      isEnable = !isEnable;
      editIcon = isEnable ? Icons.check : Icons.edit;
    });
  }

  enableDisableEditUsername() {
    if (isEnable) {
      String newUsername = usernameController.text.trim().toLowerCase();
      if (newUsername != getSavedUser()?.username) {
        if (formKey.currentState!.validate()) {
          getUserByUsername(newUsername).then((user) {
            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text("username is already used",style: TextStyle(color: modeColors[3][0])), duration: constantDelay));
              return;
            }
            getSavedUser()?.updateUsername(newUsername);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("username changed successfully"), duration: constantDelay));
            _changeEditUsernameState();
          });
        }
      } else {
        _changeEditUsernameState();
      }
    } else {
      _changeEditUsernameState();
    }
  }
}
