// ignore_for_file: file_names

import 'package:delivery_system/controller/shared/constants/Constants.dart';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/vehicle/VehicleEntity.dart';
import 'package:location/location.dart';
import 'SavedData.dart';

/// Get the saved data of the logged-in user
User? getSavedUser() {
  return savedUser;
}

/// Update the location to the current coordinates
updateUserLocation(LocationData loc) {
  CoordinatesRecord coordinates = CoordinatesRecord(
    lat: loc.latitude ?? getSavedUser()?.lat ?? defaultLatitude,
    long: loc.longitude ?? getSavedUser()?.long ?? defaultLongitude,
    accu: loc.accuracy ?? getSavedUser()?.accu ?? defaultAccuracy,
  );
  savedUser?.updateLocation(coordinates);
}

/// Delete saved user
discardUser() {
  savedUser = null;
}

/// Get the data of the saved vehicles
Map<String, Vehicle> getSavedVehicles() {
  return savedVehicles;
}

/// Get the data of the saved vehicle by its key
Vehicle? getSavedVehicle(String? key) {
  if (key == null) return null;
  return savedVehicles[key];
}

/// Delete saved vehicle
discardVehicle(String? key) {
  if (key != null) {
    getSavedVehicle(key)?.goBack().then((value) => savedVehicles.remove(key));
  }
}
