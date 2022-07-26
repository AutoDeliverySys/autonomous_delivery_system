// ignore_for_file: file_names

import 'dart:async';
import 'package:delivery_system/controller/shared/constants/Constants.dart';
import 'package:delivery_system/controller/logic/location/Coordinates.dart';
import 'package:firebase_database/firebase_database.dart';

import 'constants/Constants.dart';

class Trackable {
  late final DatabaseReference reference;

  late final StreamSubscription latTrack;
  late final StreamSubscription longTrack;
  late final StreamSubscription accuTrack;

  num _lat = defaultLatitude;
  num _long = defaultLongitude;
  num _accu = defaultAccuracy;

  get lat => _lat;

  get long => _long;

  get accu => _accu;

  Trackable(this.reference) {
    reference.child(UserFields.latitude).get().then((lat) => _lat = lat.value as num);
    reference.child(UserFields.longitude).get().then((long) => _long = long.value as num);
    reference.child(UserFields.accuracy).get().then((accu) => _accu = accu.value as num);
    _startStreaming();
  }

  void _startStreaming() {
    latTrack = reference.child(UserFields.latitude).onValue.listen((event) {
      _lat = event.snapshot.value as num;
    });
    longTrack = reference.child(UserFields.longitude).onValue.listen((event) {
      _long = event.snapshot.value as num;
    });
    accuTrack = reference.child(UserFields.accuracy).onValue.listen((event) {
      _accu = event.snapshot.value as num;
    });
    stopTrackLocation();
  }

  reStartTrackLocation({Function(CoordinatesRecord)? onChange}) {
    stopTrackLocation();
    startTrackLocation(onChange: onChange);
  }

  startTrackLocation({Function(CoordinatesRecord)? onChange}) {
    latTrack.resume();
    longTrack.resume();
    accuTrack.resume();
    if (onChange != null) {
      latTrack.onData((lat) {
        _lat = lat.snapshot.value as num;
        onChange(CoordinatesRecord(lat: _lat, long: _long, accu: _accu));
      });
      longTrack.onData((long) {
        _long = long.snapshot.value as num;
        onChange(CoordinatesRecord(lat: _lat, long: _long, accu: _accu));
      });
      accuTrack.onData((accu) {
        _accu = accu.snapshot.value as num;
        onChange(CoordinatesRecord(lat: _lat, long: _long, accu: _accu));
      });
    }
  }

  stopTrackLocation() {
    latTrack.pause();
    longTrack.pause();
    accuTrack.pause();
  }
}
