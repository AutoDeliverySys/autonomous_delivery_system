// ignore_for_file: file_names

import 'dart:async';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:firebase_database/firebase_database.dart';
import '../trackable.dart';
import '../../../../shared/Order.dart';
import '../constants/Constants.dart';

class User extends Trackable {
  final String uid;
  late String username;
  late List<Order> orders = [];

  User(this.uid, {Function? afterGetDataAction})
      : super(FirebaseDatabase.instance.ref("${Entities.users}/$uid")) {
    getUsername().then((data) {
      username = data.value.toString();
      getOrders().then((data) {
        orders = data;
        if (afterGetDataAction != null) afterGetDataAction();
      });
    });
  }

  User.createNew({required this.uid, required this.username, required CoordinatesRecord location})
      : super(FirebaseDatabase.instance.ref("${Entities.users}/$uid")) {
    reference.child(UserFields.username).set(username);
    reference.child(UserFields.latitude).set(location.lat);
    reference.child(UserFields.longitude).set(location.long);
    reference.child(UserFields.accuracy).set(location.accu);
  }


  updateLocation(CoordinatesRecord location) {
    reference.update(
      {
        UserFields.latitude: location.lat,
        UserFields.longitude: location.long,
        UserFields.accuracy: location.accu,
      },
    );
  }

  // updatePassword(String password) {
  //   reference.update({UserFields.password: password});
  // }

  updateUsername(String username) {
    this.username=username;
    reference.update({UserFields.username: username});
  }

  update({String? username, double? lat, double? long}) {
    reference.update(
      {
        UserFields.username:
            username ?? reference.child(UserFields.username).get().then((a) => a.value),
        // UserFields.email: email ?? reference.child(UserFields.email).get().then((a) => a.value),
        // UserFields.password:
        //     password ?? reference.child(UserFields.password).get().then((a) => a.value),
        UserFields.latitude: lat ?? reference.child(UserFields.latitude).get().then((a) => a.value),
        UserFields.longitude:
            long ?? reference.child(UserFields.longitude).get().then((a) => a.value),
      },
    );
  }

  Future<DataSnapshot> getUsername() async {
    return await reference.child(UserFields.username).get();
  }

  Future<DataSnapshot> getField(String field) async {
    return await reference.child(field).get();
  }
  Future<List<Order>> getOrders() async {
    List<Order> ordersList = [];
    return await reference.child(UserOrdersFields.orders).get().then((orders) {
      if (orders.exists) {
        Map map = orders.value as Map;
        map.forEach((id, orderData) {
          String dateTime = orderData[UserOrdersFields.dateTime];
          String user = orderData[UserOrdersFields.username];
          String status = orderData[UserOrdersFields.status];
          String? vehicleKey = orderData[UserOrdersFields.vehicleKey];
          ordersList.add(Order(
            orderId: id,
            anotherUsername: user,
            status: status,
            datetime: dateTime,
            vehicleKey: vehicleKey,
          ));
        });
      }
      this.orders.clear();
      this.orders.addAll(ordersList);
      return ordersList;
    });
  }

  Future<Order?> getOrder(String key) async {
    reference.child("${UserOrdersFields.orders}/$key").get().then((orderDetails) {
      if (orderDetails.exists) {
        String id = orderDetails.child(UserOrdersFields.orderId).value.toString();
        String user = orderDetails.child(UserOrdersFields.anotherUserID).value.toString();
        String status = orderDetails.child(UserOrdersFields.status).value.toString();
        String dateTime = orderDetails.child(UserOrdersFields.dateTime).value.toString();
        String vehicleKey = orderDetails.child(UserOrdersFields.vehicleKey).value.toString();
        return Order(
          orderId: id,
          anotherUsername: user,
          status: status,
          datetime: dateTime,
          vehicleKey: vehicleKey,
        );
      }
    });
    return null;
  }

  addOrder(Order order) {
    String id = order.orderId;
    reference.child(UserOrdersFields.orders + "/$id").set({
      UserOrdersFields.anotherUserID: order.anotherUsername,
      UserOrdersFields.dateTime: order.dateTime,
      UserOrdersFields.status: order.status,
    }).then((value) => orders.add(order));
  }

  cancelOrder(String orderId) {
    orders[_getOrderIndex(orderId)].status = "cancelled";
    reference.child(UserOrdersFields.orders + "/" + orderId).update({
      UserOrdersFields.status: "cancelled",
    });
  }

  setOrderRunning(String orderId, String vehicleKey) {
    orders[_getOrderIndex(orderId)].status = "running";
    orders[_getOrderIndex(orderId)].vehicleKey = vehicleKey;
    reference.child(UserOrdersFields.orders + "/" + orderId).update({
      UserOrdersFields.status: "running",
      UserOrdersFields.vehicleKey: vehicleKey,
    });
  }

  setOrderDone(String orderId) {
    orders[_getOrderIndex(orderId)].status = "done";
    reference.child(UserOrdersFields.orders + "/" + orderId).update({
      UserOrdersFields.status: "done",
    });
  }

  deleteOrder(String orderId) {
    reference.child(UserOrdersFields.orders + "/" + orderId).remove();
    orders.removeAt(_getOrderIndex(orderId));
  }

  _getOrderIndex(String orderId) {
    int index = -1;
    for (int i = 0; i < orders.length; i++) {
      if (orders[i].orderId == orderId) index = i;
    }
    return index;
  }
}

// Future<String?> getPasswordByEmail(String email) async {
//   var reference = FirebaseDatabase.instance.ref(Entities.users);
//   return await reference.get().then((users) {
//     print(users.exists);
//     if (users.exists) {
//       for (var user in users.children) {
//         String em = reference.child(user.toString() + "/" + UserFields.email).get().toString();
//         print(em);
//         if (em == email) {
//           return reference.child(user.toString() + "/" + UserFields.password).get().toString();
//         }
//       }
//     }
//   });
//   // return null;
//   // String? id;
//   // FirebaseDatabase.instance.ref(Entities.users).once().then((value) {
//   //   Map<dynamic, dynamic> users = value.snapshot.children as Map;
//   //   print(users.length);
//   //   users.forEach((key, values) {
//   //     if (values[UserFields.email] == email) {
//   //       id = values[UserFields.password];
//   //       print("=====" + id!.toString() + "=====");
//   //     }
//   //   });
//   // });
//   // return id;
// }

// Future<String?> getKeyByEmailPass(AccountRecord account) async{
//    FirebaseDatabase.instance.ref(Entities.users).once().then((value) {
//     Map<dynamic, dynamic> users = value.snapshot.children as Map;
//     String? id;
//     users.forEach((key, values) {
//       if (values[UserFields.email] == account.email &&
//           values[UserFields.password] == account.password) {
//         id = key;
//       }
//     });
//     return id;
//   });
//   return null;
// }
