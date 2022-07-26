// ignore_for_file: file_names

import 'dart:math';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';

double getDistanceBetween(CoordinatesRecord loc1, CoordinatesRecord loc2) {
  // degrees to radians
  double lat1 = loc1.lat * pi / 360;
  double long1 = loc1.long * pi / 360;
  double lat2 = loc2.lat * pi / 360;
  double long2 = loc2.long * pi / 360;
  // Haversine formula
  double dLon = long2 - long1;
  double dLat = lat2 - lat1;
  double a = pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
  double c = 2 * asin(sqrt(a));
  // Radius of earth in kilometers 6371. in miles 3956
  double earthRadius = 6371;
  return (c * earthRadius);
}
