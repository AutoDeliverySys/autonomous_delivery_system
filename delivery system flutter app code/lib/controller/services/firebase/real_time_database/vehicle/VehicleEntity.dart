// ignore_for_file: file_names

import 'package:delivery_system/controller/shared/constants/Constants.dart';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../trackable.dart';
import 'package:firebase_database/firebase_database.dart';
import '../constants/Constants.dart';

class Vehicle extends Trackable {
  final String key;

  late bool _isAvailable;

  final Set<Polyline> _path = {};

  num destinationLat = defaultLatitude;
  num destinationLong = defaultLongitude;
  num destinationAccu = defaultAccuracy;

  Vehicle(this.key) : super(FirebaseDatabase.instance.ref("${Entities.vehicles}/$key")) {
    reference
        .child(VehicleFields.isAvailable)
        .get()
        .then((data) => _isAvailable = data.value as bool);
  }

  get isAvailable => _isAvailable;

  get path => _path;

  bool isArrived({required double errorRatio}) {
    if (!_isAvailable) {
      if ((destinationLat - lat).abs() <= errorRatio &&
          (destinationLong - long).abs() <= errorRatio) {
        return true;
      }
      return false;
    }
    return false;
  }

  getDestination() =>
      CoordinatesRecord(lat: destinationLat, long: destinationLong, accu: destinationAccu);

  setDestination(CoordinatesRecord coordinates) async {
    destinationLat = coordinates.lat;
    destinationLong = coordinates.long;
    destinationAccu = coordinates.accu;
    await reference.child(VehicleFields.destinationLatitude).set(coordinates.lat);
    await reference.child(VehicleFields.destinationLongitude).set(coordinates.long);
    await reference.child(VehicleFields.destinationAccuracy).set(coordinates.accu);
    // TODO: add "path" argument in the database then track the path
    // _trackPath();
  }

  // _trackPath() {
  //   reference.child(VehicleFields.path).onValue.listen((event) {
  //     _path = event.snapshot.value as Set<Polyline>;
  //   });
  // }

  resetDestination() async {
    await setDestination(
      CoordinatesRecord(
        lat: vehicleDefaultLatitude,
        long: vehicleDefaultLongitude,
        accu: vehicleDefaultAccuracy,
      ),
    );
  }

  setOrderID(String orderID) async {
    await reference.child(VehicleFields.orderID).set(orderID);
  }

  resetOrderID() async {
    await reference.child(VehicleFields.orderID).set("");
  }

  setAvailable() async {
    _isAvailable = true;
    await reference.child(VehicleFields.isAvailable).set(_isAvailable);
  }

  setUnAvailable() async {
    _isAvailable = false;
    await reference.child(VehicleFields.isAvailable).set(_isAvailable);
  }

  goBack() async {
    await resetOrderID();
    await setAvailable();
    await resetDestination();
  }

  goto(CoordinatesRecord coordinates, String orderID) async {
    await setDestination(coordinates);
    await setUnAvailable();
    await setOrderID(orderID);
  }
}
