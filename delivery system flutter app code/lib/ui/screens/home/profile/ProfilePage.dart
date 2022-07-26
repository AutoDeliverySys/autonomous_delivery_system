// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/logic/form/Validator.dart';
import 'package:delivery_system/ui/screens/home/profile/ProfilePageFunctions.dart';
import 'package:delivery_system/ui/shared/constants/Components.dart' as components;
import 'package:delivery_system/ui/shared/constants/modes.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilePageFunctions? funs;

  @override
  Widget build(BuildContext context) {
    funs ??= ProfilePageFunctions(context: context, setState: setState);
    ProfilePageFunctions functions = funs!;
    double height = 250;

    functions.usernameController.text = "${getSavedUser()?.username}";

    return Scaffold(
      backgroundColor: modeColors[0][0],
      appBar: components.appBar(
        "Profile",
        leadingIcon: Icons.arrow_back_outlined,
        leadingIconPressed: functions.back,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height / 5),
                        child: Icon(
                          Icons.account_circle_sharp,
                          size: height * 2 / 3,
                          color: modeColors[1][1],
                        ),
                      ),
                      Form(
                        key: functions.formKey,
                        child: TextFormField(
                          controller: functions.usernameController,
                          validator: usernameValidator,
                          readOnly: !functions.isEnable,
                          // initialValue: "${getSavedUser()?.username}",
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            labelText: "username",
                            labelStyle: TextStyle(color: modeColors[2][1]),
                            suffixIcon: IconButton(
                              onPressed: functions.enableDisableEditUsername,
                              icon: Icon(functions.editIcon, color: modeColors[1][1]),
                            ),
                          ),
                          style: TextStyle(
                            color: modeColors[2][0],
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "number of orders :  ${getSavedUser()?.orders.length}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: modeColors[2][1], fontSize: 15),
                              // maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                        onPressed: functions.logout,
                        child: Text(
                          "logout",
                          style: TextStyle(
                              color: modeColors[2][0], fontSize: 15, fontStyle: FontStyle.italic),
                        )),
                  )
                  // Container(
                  //   color: Colors.green,
                  //   width: 200,
                  //   height: 100,
                  //   child: IconButton(
                  //       onPressed: () => GPSLocation.getInstance().reStartTrackLocalLocation(),
                  //       icon: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           const Icon(Icons.radio_button_off_outlined),
                  //           Text(
                  //             "Open GPS",
                  //             style: TextStyle(color: modeColors[2][0]),
                  //           ),
                  //         ],
                  //       )),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
