// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:delivery_system/ui/shared/constants/modes.dart';

class AppBarAction {
  IconData? iconData;
  String? text;
  Function()? function;

  AppBarAction({this.iconData, this.text, this.function});
}

AppBar appBar(
  String title, {
  IconData? leadingIcon,
  Function()? leadingIconPressed,
  List<AppBarAction>? actions,
}) {
  List<Widget> widgets = [];
  actions?.forEach(
    (action) => widgets.add(
      IconButton(
        onPressed: action.function,
        tooltip: action.text,
        icon: Icon(
          action.iconData,
          color: modeColors[2][0],
        ),
      ),
    ),
  );
  return AppBar(
      backgroundColor: modeColors[0][2],
      title: Text(title, style: TextStyle(color: modeColors[2][0])),
      centerTitle: true,
      leading: IconButton(
          onPressed: leadingIconPressed,
          icon: Icon(
            leadingIcon,
            color: modeColors[2][0],
          )),
      actions: widgets);
}

class AlertDialogAction {
  String? text;
  Function()? function;

  AlertDialogAction({this.text, this.function});
}

Future<void> showMessageDialog(
  BuildContext context, {
  required String title,
  required List<String> messages,
  List<AlertDialogAction>? actions,
}) async {
  List<Widget> widgets = [];
  actions?.forEach(
    (action) => widgets.add(
      TextButton(
        child: Text(action.text ?? ""),
        onPressed: action.function,
      ),
    ),
  );
  List<Text> children = [];
  for (var message in messages) {
    children.add(Text(message));
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 10,
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: children,
          ),
        ),
        actions: actions != null
            ? widgets
            : [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
      );
    },
  );
}
