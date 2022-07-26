// ignore_for_file: file_names

import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/constants/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<Map<String, Object>>> getAvailableVehiclesCoordinates() async {
  var reference = FirebaseDatabase.instance.ref(Entities.vehicles);

  return await reference.get().then((vehiclesData) async {
    List<Map<String, Object>> vehiclesList = [];
    if (vehiclesData.exists) {
      Map map = vehiclesData.value as Map;
      map.forEach(
        (key, vehicleData) async {
          bool isAvailable = vehicleData["isAvailable"];
          if (isAvailable) {
            double latitude = vehicleData["location"]["latitude"];
            double longitude = vehicleData["location"]["longitude"];
            double accuracy = vehicleData["location"]["accuracy"];
            vehiclesList.add({
              "key": key,
              "coordinates": CoordinatesRecord(lat: latitude, long: longitude, accu: accuracy)
            });
          }
        },
      );
    }
    return vehiclesList;
  });
}
