// ignore_for_file: file_names

import 'package:delivery_system/controller/cache/SavedDataOperations.dart';
import 'package:delivery_system/controller/location/GPSLocation.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/vehicle/VehicleEntity.dart';
import 'package:delivery_system/ui/screens/home/map/MapPageFunctions.dart';
import 'package:delivery_system/ui/shared/constants/modes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final Vehicle? vehicle;

  const MapPage({Key? key, this.vehicle}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapPageFunctions? funs;

  @override
  Widget build(BuildContext context) {
    funs ??= MapPageFunctions(context: context, setState: setState,vehicle: widget.vehicle);
    MapPageFunctions functions = funs!;
    // ask to open GPS
    GPSLocation.getInstance().reStartTrackLocalLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: modeColors[0][2],
        title: Text("Map", style: TextStyle(color: modeColors[2][0])),
        centerTitle: true,
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: functions.mapType,
        initialCameraPosition: initialPosition,
        onMapCreated: functions.onMapCreated,
        markers: functions.markers,
        circles: functions.circles,
        polylines: widget.vehicle != null ? widget.vehicle?.path : const {},
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.change_circle),
            onPressed: functions.changeMapType,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
              child: functions.isTrack? const Icon(Icons.location_on_rounded):const Icon(Icons.location_off_rounded),
              onPressed: functions.floatingButtonAction),
        ],
      ),
    );
  }

  @override
  void dispose() {
    GPSLocation.getInstance().stopTrackLocalLocation();
    getSavedUser()?.stopTrackLocation();
    widget.vehicle?.stopTrackLocation();
    super.dispose();
  }
}
