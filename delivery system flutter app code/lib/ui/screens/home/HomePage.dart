// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/logic/database/Database.dart';
import 'package:delivery_system/controller/location/GPSLocation.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/ui/screens/home/loading/LoadingPage.dart';
import 'package:delivery_system/ui/screens/home/orders/OrdersPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({this.user, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getAndSaveUserDataByKey(
        widget.user?.uid ?? "",
        afterGetDataAction: () => setState(() {
          isLoading = false;
          // GPSLocation.getInstance().reStartTrackLocalLocation();
          getSavedUser()?.orders.forEach((order) {
            if (order.vehicleKey != null) {
              getAndSaveVehicleDataFromKey(order.vehicleKey!);
            }
          });
        }),
      );
    }

    if (isLoading) {
      return const LoadingPage();
    } else {
      return const OrdersPage();
    }
  }
}
