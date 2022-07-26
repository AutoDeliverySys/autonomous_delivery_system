// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/logic/database/Database.dart' as database;
import 'package:delivery_system/controller/logic/form/Validator.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UsersOperations.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/vehicle/VehicleEntity.dart';
import 'package:delivery_system/controller/shared/Order.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import 'package:delivery_system/ui/shared/constants/Components.dart' as components;
import 'package:delivery_system/ui/shared/constants/modes.dart';
import 'package:flutter/material.dart';

class OrdersPageFunctions {
  final BuildContext context;
  final Function(Function()) setState;

  OrdersPageFunctions({required this.context, required this.setState});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController _bottomSheetController;
  var formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  bool isBottomSheetShown = false;
  IconData actionButtonIcon = Icons.edit;

  back() => Navigator.pop(context);

  cancelOrder(Order order) {
    getSavedUser()?.cancelOrder(order.orderId);
    discardVehicle(order.vehicleKey);
    // if the order is for another user
    if (getSavedUser()?.username != order.anotherUsername) {
      getUserByUsername(order.anotherUsername).then((user) => user!.cancelOrder(order.orderId));
    }
  }

  deleteOrder(Order order) {
    getSavedUser()?.deleteOrder(order.orderId);
    // if the order is for another user
    if (getSavedUser()?.username != order.anotherUsername) {
      getUserByUsername(order.anotherUsername).then((user) => user!.deleteOrder(order.orderId));
    }
  }

  addOrder(String username) {
    Order newOrder = database.addNewOrder(username);
    setState(() {});
    // if (getSavedVehicle() == null) {
    database.startOrder(newOrder).then((vehicleKey) {
      if (vehicleKey != null) {
        setState(() {
          getSavedUser()?.setOrderRunning(newOrder.orderId, vehicleKey);
        });
        // if the order is for another user
        if (getSavedUser()?.username != username) {
          getUserByUsername(username)
              .then((user) => user!.setOrderRunning(newOrder.orderId, vehicleKey));
        }
        Future.delayed(databaseDelay).then((value) {
          _checkIfArrived(newOrder);
          getSavedVehicle(vehicleKey)?.startTrackLocation(onChange: (coordinates) {
            _checkIfArrived(newOrder);
          });
        });
      }
    });
  }

  _checkIfArrived(Order order) {
    Vehicle? v = getSavedVehicle(order.vehicleKey);
    if (v != null && v.isArrived(errorRatio: locationErrorRatio)) {
      setState(() => _sendNotificationThatOrderDone(order));
    }
  }

  _sendNotificationThatOrderDone(Order order) {
    components.showMessageDialog(
      context,
      title: "Order done",
      messages: ["Your order (${order.orderId}) done", "accept the order after finish"],
      actions: [
        components.AlertDialogAction(
          text: "Accept",
          function: () {
            back();
            _markOrderDone(order);
            _releaseVehicle(order.vehicleKey);
          },
        ),
        components.AlertDialogAction(
          text: "Accept & delete",
          function: () {
            back();
            deleteOrder(order);
          },
        ),
      ],
    );
  }

  _markOrderDone(Order order) {
    getSavedUser()?.setOrderDone(order.orderId);
    // if the order is for another user
    if (getSavedUser()?.username != order.anotherUsername) {
      getUserByUsername(order.anotherUsername).then((user) => user!.setOrderDone(order.orderId));
    }
  }

  _releaseVehicle(String? vehicleKey) {
    getSavedVehicle(vehicleKey)?.stopTrackLocation();
    discardVehicle(vehicleKey);
  }

  startBottomSheet() async {
    _bottomSheetController = (scaffoldKey.currentState?.showBottomSheet(
      (context) => Container(
        color: modeColors[1][0],
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "To username:"),
                    validator: usernameValidator,
                    controller: usernameController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ))!;
    _bottomSheetController.closed.then((value) {
      setState(() {
        isBottomSheetShown = false;
        actionButtonIcon = Icons.edit;
        usernameController.text = "";
      });
      return null;
    });
  }

  refresh() {
    setState(() {
      if (isBottomSheetShown) {
        back();
        isBottomSheetShown = false;
        actionButtonIcon = Icons.edit;
        usernameController.text = "";
      }
      getSavedUser()?.getOrders();
    });
  }

  floatingButtonFunction() {
    if (isBottomSheetShown) {
      if (formKey.currentState!.validate()) {
        String username = usernameController.text.trim().toLowerCase();
        hasUsername(username).then((hasUsername) {
          if (hasUsername) {
            addOrder(username);
            back();
            setState(() {
              isBottomSheetShown = false;
              actionButtonIcon = Icons.edit;
              usernameController.text = "";
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("new request ..."), duration: constantDelay));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Username not found", style: TextStyle(color: modeColors[3][0])),
                duration: constantDelay));
          }
        });
      }
    } else {
      startBottomSheet();
      setState(() {
        isBottomSheetShown = true;
        actionButtonIcon = Icons.add;
        usernameController.text = "";
      });
    }
  }
}
