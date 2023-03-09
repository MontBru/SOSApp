import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


//for it to work you have to add google_map_flutter to
//pubspec.yaml and change minimum sdk to 20 in build.gradle
//and add <meta-data android:name="com.google.android.geo.API_KEY"
 //          android:value="AIzaSyDlDIqYXzgAuZE5U7c1JxAO7_LHzBbrdoM"/>
//in androidmanifest             
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
