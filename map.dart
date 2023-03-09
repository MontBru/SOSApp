import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
        target:LatLng(10,10),
    zoom: 10,
    )
    );
  }
}
