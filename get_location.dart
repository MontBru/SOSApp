import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';


Future<Position> getCurrentLocation()async{
  LocationPermission permission;
  //=await Geolocator.requestPermission();
  //bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

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

void printLocation()async
{
  Position position=await getCurrentLocation();
  print(position.latitude);
  print(position.longitude);
}

void pushLocationToFirebase() async
{
  //Position position=await getCurrentLocation();
  printLocation();
  //to firebase
}

void pushLocationContinuously(dynamic message) async
{
  while(true) {
    pushLocationToFirebase();
    //should be pushing to firebase
    await Future.delayed(const Duration(minutes: 1));
  }
}