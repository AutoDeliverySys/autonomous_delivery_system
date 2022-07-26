// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 3.5,
            ),
            Text(
              "Connecting... ",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
