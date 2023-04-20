import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../users.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position> getCurrentLocation()async{
  //LocationPermission permission;
  //=await Geolocator.requestPermission();
  //bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print("I am in function getCurrentLocation");

  var status=await Permission.location.request();
  if(status == PermissionStatus.granted)
  {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  else
  {
    Get.snackbar('','Location Permission Denied');
    return Future.error('Location Permission Denied');
  }
}

// void printLocation()async
// {
//   Position position=await getCurrentLocation();
//   print(position.latitude);
//   print(position.longitude);
// }

Future<void> pushLocationToFirebase() async
{
  print("I am in function pushLocationToFirebase");
  Position position=await getCurrentLocation();
  print("I am out function getCurrentLocation");
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  FirebaseFirestore.instance.collection('users').doc(uid).update({
    'longitude': position.longitude,
    'latitude': position.latitude,
  });
  print("I am out function pushLocationToFirebase");
}

// void pushLocationContinuously() async
// {
//   while(true) {
//     pushLocationToFirebase();
//     //should be pushing to firebase
//     print("getting location");
//     await Future.delayed(const Duration(minutes: 1));
//   }
// }

// void updateSideMenu(){
//   StatefulBuilder(context,myStatefunc)
// }

Future<Set<Marker>> pushMarkers(Set<Marker> markers) async {
  print("I am in function pushMarkers");
  if(markers != null) {print(markers.isEmpty);}

  List<String?> detectedAlerts = await user!.readDetectedAlerts(
      FirebaseAuth.instance.currentUser!.uid);

  for (String? uid in detectedAlerts) {
    if (uid != null) {
      User_info? user_info = await user!.readUser(uid);
      markers = await add_marker(user_info, markers);
    }
  }

  return markers;
}


Future<Set<Marker>> add_marker(User_info user_info, Set<Marker> markers) async {
  print("I am in function add_marker");
  if(markers != null) {print(markers.isEmpty);}
  BitmapDescriptor icon;

  switch (user_info.alertType) {
    case 0:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/sos_marker.bmp');
      }
      break;
    case 1:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/avalanche_marker.bmp');
      }
      break;
    case 2:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/car_marker.bmp');
      }
      break;
    case 3:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/directions_marker.bmp');
      }
      break;
    case 4:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/earthquake_marker.bmp');
      }
      break;
    case 5:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/fire_marker.bmp');
      }
      break;
    case 6:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/hospital_marker.bmp');
      }
      break;
    case 7:
      {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/tornado.bmp');
      }
      break;
    default:
      {
        icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(
          size: Size(40, 40),
        ),
            'assets/water_marker.bmp');
      }
      break;
  }

  num lat, lng;
  lat = user_info.latitude;
  lng = user_info.longitude;

  markers.add(
      Marker(
        markerId: MarkerId(user_info.username),
        position: LatLng(
          lat as double,
          lng as double,
        ),
        // icon: BitmapDescriptor.defaultMarker,
        icon: icon,
        infoWindow: InfoWindow(
          title: user_info.username,
          snippet: user_info.username,
        ),

      )
  );

  return markers;
}