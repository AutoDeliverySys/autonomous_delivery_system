// ignore_for_file: file_names

import 'dart:async';
import 'dart:typed_data';

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/vehicle/VehicleEntity.dart';
import 'package:delivery_system/controller/shared/constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const double zoomLevel = 18;
final CameraPosition initialPosition = CameraPosition(
    target:
        LatLng(getSavedUser()?.lat ?? defaultLatitude, getSavedUser()?.long ?? defaultLongitude),
    zoom: zoomLevel);

class MapPageFunctions {
  BuildContext context;
  Function(Function()) setState;
  Vehicle? vehicle;
  MapType mapType = MapType.normal;
  bool isTrack = true;

  MapPageFunctions({required this.context, required this.setState, this.vehicle});

  late GoogleMapController _mapController;

  late Uint8List userMarkerImage;
  late Uint8List vehicleMarkerImage;

  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  get markers => _markers;

  get circles => _circles;

  // CoordinatesRecord? vehicleLocation;
  // CoordinatesRecord? userLocation;

  Future<Uint8List> _getMarker(String imgName) async {
    return await DefaultAssetBundle.of(context)
        .load("assets/images/$imgName")
        .then((value) => value.buffer.asUint8List());
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    userMarkerImage = await _getMarker(Markers.user);
    vehicleMarkerImage = await _getMarker(Markers.vehicle);
    // String value = await DefaultAssetBundle.of(context)
    //     .loadString('assets/json/map_style.json');
    // _mapController.setMapStyle(value);

    getSavedUser()?.startTrackLocation(onChange: (coordinates) => _updateMarkersPosition);
    vehicle?.startTrackLocation(onChange: (coordinates) => _updateMarkersPosition);

    _updateMarkersPosition();
  }

  _updateMarkersPosition() {
    Set<Marker> marks = {};
    Set<Circle> circs = {};
    User? user = getSavedUser();
    if (user != null) {
      LatLng userLatLng = LatLng(
        user.lat,
        user.long,
      );
      Circle userC = Circle(
        circleId: const CircleId("user"),
        radius: user.accu*1.0,
        zIndex: 1,
        strokeWidth: 2,
        strokeColor: Circles.stroke_1,
        center: userLatLng,
        fillColor: Circles.fill_1,
      );
      Marker userM = Marker(
        markerId: const MarkerId("user"),
        position: userLatLng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 1),
        // infoWindow: const InfoWindow(title: 'Nice Place', snippet: 'Welcome to Poland'),
        // icon: BitmapDescriptor.defaultMarker,
        icon: BitmapDescriptor.fromBytes(userMarkerImage),
      );
      marks.add(userM);
      circs.add(userC);
    }
    Vehicle? vLoc = vehicle;
    if (vLoc != null) {
      LatLng vehicleLatLng = LatLng(
        vLoc.lat,
        vLoc.long,
      );
      Marker vehicleM = Marker(
        markerId: const MarkerId("vehicle"),
        position: vehicleLatLng,
        // rotation: user?.heading ?? defaultHeading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        // icon: BitmapDescriptor.defaultMarker,
        icon: BitmapDescriptor.fromBytes(vehicleMarkerImage),
      );
      Circle vehicleC = Circle(
        circleId: const CircleId("vehicle"),
        radius: vLoc.accu,
        zIndex: 1,
        strokeWidth: 2,
        strokeColor: Circles.stroke_2,
        center: vehicleLatLng,
        fillColor: Circles.fill_2,
      );
      marks.add(vehicleM);
      circs.add(vehicleC);
    }
    setState(() {
      _markers.clear();
      _markers.addAll(marks);
      _circles.clear();
      _circles.addAll(circs);
    });
  }

  goToMyLocation() {
    _updateMarkersPosition();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            getSavedUser()?.lat ?? defaultLatitude,
            getSavedUser()?.long ?? defaultLongitude,
          ),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  goToVehicleLocation() {
    _updateMarkersPosition();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            vehicle?.lat ?? defaultLatitude,
            vehicle?.long ?? defaultLongitude,
          ),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  trackMyLocation() {
    try {
      goToMyLocation();
      getSavedUser()?.reStartTrackLocation(
        onChange: (event) => goToMyLocation(),
      );
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        debugPrint("permission denied");
      }
    }
  }

  changeMapType() {
    setState(() {
      if (mapType == MapType.normal) {
        mapType = MapType.hybrid;
      } else {
        mapType = MapType.normal;
      }
    });
  }

  floatingButtonAction() {
    if (vehicle != null) {
      goToVehicleLocation();
    } else {
      if (!isTrack) {
        trackMyLocation();
      } else {
        getSavedUser()?.stopTrackLocation();
        goToMyLocation();
      }
      setState(() {
        isTrack = !isTrack;
      });
    }
  }
}

class Markers {
  static const String pin = "marker_80px.png";
  static const String vehicle = "near_me_60px.png";

// static const String location = "";
  static const String user = "user_location_200px.png";
}

class Circles {
  static Color stroke_1 = Colors.blue.withAlpha(90);
  static Color fill_1 = Colors.blue.withAlpha(70);
  static Color stroke_2 = Colors.red.withAlpha(90);
  static Color fill_2 = Colors.red.withAlpha(70);
}
