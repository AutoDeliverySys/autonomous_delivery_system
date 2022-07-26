import 'dart:async';
import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:location/location.dart';

class GPSLocation {
  static _GPSLocation? _instance;

  static _GPSLocation getInstance() => _instance ??= _GPSLocation();
}

class _GPSLocation {
  final Location loc = Location();
  StreamSubscription? _locationListener;

  _GPSLocation() {
    loc.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        _locationListener = loc.onLocationChanged.listen((data) {
          updateUserLocation(data);
        });
      }
    });
  }

  /// get current local location
  Future<LocationData> getLocation() {
    return loc.getLocation();
  }

  /// start tracking current local location in real time
  startTrackLocalLocation({Function(LocationData location)? onChange}) {
    _locationListener = loc.onLocationChanged.listen((location) {
      updateUserLocation(location);
      if (onChange != null) {
        onChange(location);
      }
    });
  }

  reStartTrackLocalLocation({Function(LocationData)? onChange}) {
    stopTrackLocalLocation();
    startTrackLocalLocation(onChange: onChange);
  }

  stopTrackLocalLocation() {
    if (_locationListener != null) {
      _locationListener?.cancel();
    }
    _locationListener = null;
  }

  isTrackingStopped() {
    return _locationListener == null;
  }
}
