import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'users.dart';
import 'get_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  Set<Marker> markers={};
  Position? position;

  Future<List<User_info>> makeUsers() async
  {
    position=await getCurrentLocation();

    User_info test=User_info(
      username: 'bryan',
      email: 'bm@gmail',
      latitude: position!.latitude,
      longitude: position!.longitude,
      alert_type: 0,
    );
    User_info test2=User_info(
      username: 'bryan2',
      email: 'bm@gmail',
      latitude: position!.latitude,
      longitude: position!.longitude+0.001,
      alert_type: 1,
    );
    User_info test3=User_info(
      username: 'bryan3',
      email: 'bm@gmail',
      latitude: position!.latitude-0.001,
      longitude: position!.longitude,
      alert_type: 2,
    );
    User_info test4=User_info(
      username: 'bryan4',
      email: 'bm@gmail',
      latitude: position!.latitude+0.001,
      longitude: position!.longitude,
      alert_type: 3,
    );

    List<User_info> users=<User_info>[];
    users.add(test);
    users.add(test2);
    users.add(test3);
    users.add(test4);

    return users;
  }


  void display_markers(Future<List<User_info>> futureUsers) async {
    print("in display markers");
    List<User_info> users = await futureUsers;

    users.forEach((element) {
      add_marker(element);
      print("adding marker");
    });
  }

  Future<Widget> __build(BuildContext context)async{
  position=await getCurrentLocation();

  return Stack(
    children:[
      GoogleMap(
        initialCameraPosition: CameraPosition(
    //target: LatLng(position!.latitude,position!.longitude),
          target: LatLng(position!.latitude,position!.longitude),
          zoom: 17,
        ),
      markers: markers,
    ),
      ElevatedButton(onPressed: (){
    //add_marker(test);

        display_markers(makeUsers());
    },
      child:Text("press for marker"))
    ]
  );
}

  @override
  build(BuildContext context){
    return FutureBuilder<Widget>(
      future: __build(context),
      builder: (BuildContext context,AsyncSnapshot<Widget> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const CircularProgressIndicator();
          }
        else if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }else{
          return snapshot.data!;
        }
      },

    );
  }

  void add_marker(User_info user_info) async{
     BitmapDescriptor icon;


       switch (user_info.alert_type)
       {
         case 0:
         {
           icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
             size:Size(30,30),
           ),
               'assets/sos_marker.bmp');
         }break;
         case 1:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/avalanche_marker.bmp');
           }break;
         case 2:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/car_marker.bmp');
           }break;
         case 3:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/directions_marker.bmp');
           }break;
         case 4:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/earthquake_marker.bmp');
           }break;
         case 5:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/fire_marker.bmp');
           }break;
         case 6:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/tornado_marker.bmp');
           }break;
         default:
           {
             icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(
               size:Size(30,30),
             ),
                 'assets/water_marker.bmp');
           }break;
       }

    setState(() {
      num lat, lng;
      lat = user_info.latitude as num;
      lng = user_info.longitude as num;

      markers.add(
          Marker(
              markerId: MarkerId(user_info.username as String),
              position: LatLng(
                lat as double,
                lng as double,
              ),
             // icon: BitmapDescriptor.defaultMarker,
              icon:icon,
              infoWindow: InfoWindow(
                title:user_info.username as String ,
                snippet:user_info.username as String,
              ),

          )
      );
    });
  }
}

