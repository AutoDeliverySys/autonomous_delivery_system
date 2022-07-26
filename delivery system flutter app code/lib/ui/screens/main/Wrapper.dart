// ignore_for_file: file_names

import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/ui/screens/authenticate/AuthenticatePage.dart';
import 'package:delivery_system/ui/screens/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    // return authenticate page if not logged in
    if (user == null) return const AuthenticatePage();
    // return home page if logged in
    return HomePage(user: user);
  }
}
