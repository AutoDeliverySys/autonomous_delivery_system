// ignore_for_file: file_names

import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:intl/intl.dart';

class Order {
  late final String orderId;
  late final String anotherUsername;
  late final String dateTime;
  String? vehicleKey;
  late String status;

  Order(
      {required this.orderId,
      required this.anotherUsername,
      required this.status,
      required this.vehicleKey,
      String? datetime}) {
    dateTime = datetime ?? DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  }

  // Order.runningOrder({required this.orderId, required this.anotherUsername, String? datetime}) {
  //   dateTime = datetime ?? DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
  //   status = "running";
  // }

  Order.waitingOrder({required this.orderId, required this.anotherUsername, String? datetime}) {
    dateTime = datetime ?? DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    status = "waiting";
  }

  Future? listenToVehicles(CoordinatesRecord coordinates,
      {required Function(String vehicleKey) onFound}) {
    /// TODO: streaming searching for the most suitable vehicle available
    return null;
  }
}
