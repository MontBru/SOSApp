import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'map_functions.dart';

class Map extends StatefulWidget {
  Set<Marker> markers;

  Map(this.markers);

  @override
  State<Map> createState() => _MapState(markers);
}

class _MapState extends State<Map> {

  final Completer<GoogleMapController> _controller=Completer();
  Position? position;
  Set<Marker> markers = {};

  StreamSubscription<Position>? _locationSubscription;


  _MapState(this.markers); // @override

  @override
  void initState() {
    print("I am in function initState");
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    print("I am in function _loadData");
    if(markers != null) {print(markers.isEmpty);}
    try {
      markers = await pushMarkers(markers);
      pushLocationToFirebase();
    } catch (e) {
      // handle error
      print(e);
    }
  }

  @override
  void dispose() {
    print("I am in function dispose");
    _locationSubscription?.cancel();
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  void changeCam() async
  {
    print("I am in function changeCam");
    var newPosition =const CameraPosition(
        target: LatLng(43,25),
        zoom:16);

    GoogleMapController controller = await _controller.future;
    controller.moveCamera(
        CameraUpdate.newCameraPosition(
            newPosition
        )
    );
  }

  Future<Widget> __build(BuildContext context)async{
    print("I am in function __build");
    if(markers != null) {print(markers.isEmpty);}
    position=await getCurrentLocation();
    print("I am out function getCurrentLocation");

    return Stack(
        children:[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(position!.latitude,position!.longitude),
              // zoom: 16,
            ),
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(0, 16),
            markers: markers,
          ),
        ]
    );
  }

  @override
  build(BuildContext context){
    print("I am in function build");
    return FutureBuilder<Widget>(
      future: __build(context),
      builder: (BuildContext context,AsyncSnapshot<Widget> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }else{
          return snapshot.data!;
        }
      },
    );
  }
}

