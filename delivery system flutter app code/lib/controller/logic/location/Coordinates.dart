// ignore_for_file: file_names

import 'package:delivery_system/controller/shared/constants/Constants.dart';

class CoordinatesRecord {
  final num lat;
  final num long;
  final num accu;
  final num heading;

  CoordinatesRecord(
      {required this.lat,
      required this.long,
      this.accu = defaultAccuracy,
      this.heading = defaultHeading});
}

// CoordinatesRecord locationDataToCoordinates(LocationData loc) {
//   return CoordinatesRecord(
//     lat: loc.latitude ?? defaultLatitude,
//     long: loc.longitude ?? defaultLongitude,
//     accu: loc.accuracy ?? defaultAccuracy,
//     heading: loc.heading ?? defaultHeading,
//   );
// }
