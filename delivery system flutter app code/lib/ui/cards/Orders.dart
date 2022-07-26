// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/shared/Order.dart';
import 'package:delivery_system/ui/screens/home/map/MapPage.dart';
import 'package:flutter/material.dart';

import '../shared/constants/modes.dart';

enum OrderStatus { running, canceled, done }

Widget orderItem(
  BuildContext? context, {
  required String username,
  required Order order,
  ImageProvider? userImg,
  Function(Order order)? iconAction,
  double width = double.infinity,
  double height = 100,
  Color backColor = Colors.white,
  Color color = Colors.black,
  IconData? suffixIcon,
  List<double> borderRadius = const [15, 15, 15, 15],
}) {
  String status = order.status;
  String? vehicleKey = order.vehicleKey;
  String orderId = order.orderId;
  String dateTime = order.dateTime;
  return GestureDetector(
    onTap: () => (context != null && status == "running")
        ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage(vehicle: getSavedVehicle(vehicleKey))),
          )
        : null,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(borderRadius[0]),
          topEnd: Radius.circular(borderRadius[1]),
          bottomEnd: Radius.circular(borderRadius[2]),
          bottomStart: Radius.circular(borderRadius[3]),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (userImg == null
                ? Icon(
                    Icons.account_circle_sharp,
                    size: height * 2 / 3,
                    color: modeColors[1][1],
                  )
                : Image(image: userImg)),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: height - 20,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                      ),
                      Container(
                        height: height / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              dateTime,
                              style: TextStyle(color: color),
                            ),
                            Text(
                              orderId,
                              style: TextStyle(color: color, overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                  color: status == "done"
                                      ? Colors.green.shade500
                                      : status == "running"
                                          ? Colors.blue.shade600
                                          : status == "waiting"
                                              ? Colors.orangeAccent
                                              : Colors.red.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: suffixIcon == null
                  ? const SizedBox()
                  : IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: color,
                      ),
                      onPressed: () {
                        if (iconAction != null) iconAction(order);
                      },
                    ),
            )
          ],
        ),
      ),
    ),
  );
}
