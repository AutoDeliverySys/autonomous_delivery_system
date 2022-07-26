// ignore_for_file: file_names

import 'package:delivery_system/controller/logic/database/Database.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/constants/Constants.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import 'package:firebase_database/firebase_database.dart';

Future<bool> hasUsername(String _username) async {
  var reference = FirebaseDatabase.instance.ref(Entities.users);

  return await reference.get().then(
    (users) async {
      if (users.exists) {
        bool hasFound = false;

        Map map = users.value as Map;
        map.forEach(
          (uid, userData) async {
            String username = userData["personalData"]["username"];
            if (username == _username) {
              hasFound = true;
            }
          },
        );
        return hasFound;
      }
      return false;
    },
  );
}

Future<User?> getUserByUsername(String _username) async {
  var reference = FirebaseDatabase.instance.ref(Entities.users);
  return await reference.get().then((usersData) {
    User? user;
    if (usersData.exists) {
      Map map = usersData.value as Map;
      map.forEach(
        (uid, userData) {
          String username = userData["personalData"]["username"];
          if (username == _username) {
            user = getUserByKey(uid);
          }
        },
      );
    }
   return  Future.delayed (databaseDelay).then((_) => user);
  });
}

// Future<CoordinatesRecord?> getLocationByUsername(String _username) async {
//   var reference = FirebaseDatabase.instance.ref(Entities.users);
//   return await reference.get().then((usersData) async {
//     CoordinatesRecord? coordinates;
//
//     if (usersData.exists) {
//       Map map = usersData.value as Map;
//       map.forEach(
//         (uid, userData) async {
//           String username = userData["personalData"]["username"];
//           if (username == _username) {
//             double latitude = userData["location"]["latitude"];
//             double longitude = userData["location"]["longitude"];
//             double accuracy = userData["location"]["accuracy"];
//             coordinates = CoordinatesRecord(lat: latitude, long: longitude, accu: accuracy);
//           }
//         },
//       );
//     }
//     return coordinates;
//   });
// }
