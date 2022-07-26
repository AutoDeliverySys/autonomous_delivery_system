// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedData.dart';
import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/shared/constants/Constants.dart';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:delivery_system/controller/logic/location/CoordinatesDistance.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UsersOperations.dart'
    as users;
import 'package:delivery_system/controller/services/firebase/real_time_database/vehicle/VehiclesOperations.dart';
import 'package:delivery_system/controller/shared/Order.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import '../../services/firebase/real_time_database/user/UserEntity.dart';
import '../../services/firebase/real_time_database/vehicle/VehicleEntity.dart';

///
getAndSaveUserDataByKey(String uid, {Function? afterGetDataAction}) {
  User user = getUserByKey(uid, afterGetDataAction: afterGetDataAction);
  _saveUserData(user);
}

///
_saveUserData(User user) {
  _saveLocalUser(user);
}

///
_saveLocalUser(User user) {
  savedUser = user;
}

/// Get user information from firebase database by uid
User getUserByKey(String uid, {Function? afterGetDataAction}) {
  User user = User(uid, afterGetDataAction: afterGetDataAction);
  return user;
}

/// Get user location from firebase database by username
Future<CoordinatesRecord?> getLocationByUsername(String username) async {
  return await users.getUserByUsername(username).then((user) =>
      user == null ? null : CoordinatesRecord(lat: user.lat, long: user.long, accu: user.accu));
}

///
createNewUser({required String uid, required String username}) {
  User.createNew(
    uid: uid,
    username: username,
    location: CoordinatesRecord(
      lat: defaultLatitude,
      long: defaultLongitude,
      accu: defaultAccuracy,
    ),
  );
}

/// Search in firebase database and return a vehicle by its key
Vehicle _getVehicleByKey(String key) {
  Vehicle vehicle = Vehicle(key);
  return vehicle;
}

/// Get a vehicle data using "getVehicleByKey(String)" method <br>
/// then save the object in the cache using "saveDBVehicle(Vehicle)" method
Vehicle getAndSaveVehicleDataFromKey(String key) {
  Vehicle vehicle = _getVehicleByKey(key);
  _saveVehicle(vehicle);
  return vehicle;
}

/// Get all available vehicle location then get the closest
Future<String?> _getTheMostSuitableVehicleKey(CoordinatesRecord destination) async {
  return await getAvailableVehiclesCoordinates().then((availableVehiclesKeyLocations) {
    if (availableVehiclesKeyLocations.isEmpty) return null;
    String? key;
    double minDistance = double.maxFinite;
    for (var vehicleKeyLocations in availableVehiclesKeyLocations) {
      String k = vehicleKeyLocations["key"] as String;
      CoordinatesRecord loc = vehicleKeyLocations["coordinates"] as CoordinatesRecord;
      double dis = getDistanceBetween(destination, loc);
      if (dis < minDistance) {
        minDistance = dis;
        key = k;
      }
    }
    return key;
  });
}

void startVehicle(Vehicle vehicle, CoordinatesRecord coordinates, String orderID) {
  vehicle.goto(coordinates, orderID);
}

Future<String?> startOrder(Order order) async {
  return await getLocationByUsername(order.anotherUsername).then((loc) async {
    CoordinatesRecord? coordinates = loc;
    if (coordinates == null) return null;
    // search for most suitable vehicle key
    String? vehicleKey = await _getTheMostSuitableVehicleKey(coordinates);
    // if not found
    if (vehicleKey == null) return null;
    // save the details of the vehicle
    Vehicle vehicle = getAndSaveVehicleDataFromKey(vehicleKey);
    // start the request
    Future.delayed(databaseDelay).then((value) {
      startVehicle(vehicle, coordinates, order.orderId);
    });
    return vehicleKey;
  });
}

/// Save the data of the vehicle as firebase vehicle class
_saveVehicle(Vehicle vehicle) {
  savedVehicles[vehicle.key] = vehicle;
}

/// Add new Order to the user database then return object of class Order
Order addNewOrder(String anotherUsername) {
  DateTime dateTime = DateTime.now();
  String orderId;
  orderId = "${dateTime.millisecondsSinceEpoch}";
  Order order = Order.waitingOrder(orderId: orderId, anotherUsername: anotherUsername);
  getSavedUser()?.addOrder(order);
  // if the order is for another user
  if (getSavedUser()?.username != anotherUsername) {
    users.getUserByUsername(anotherUsername).then((user) =>
        user!.addOrder(Order.waitingOrder(orderId: orderId, anotherUsername: getSavedUser()!.username)));
  }
  return order;
}

/// Get all home requests
List<Order> getOrders() {
  return getSavedUser()?.orders ?? [];
}
