import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'users.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  Set<Marker> markers={};

  List<User_info> makeUsers()
  {
    User_info test=User_info(
      username: 'bryan',
      email: 'bm@gmail',
      latitude: 10.0,
      longitude: 10.0,
    );
    User_info test2=User_info(
      username: 'bryan2',
      email: 'bm@gmail',
      latitude: 10.0,
      longitude: 9.0,
    );
    User_info test3=User_info(
      username: 'bryan3',
      email: 'bm@gmail',
      latitude: 9.0,
      longitude: 9.0,
    );
    User_info test4=User_info(
      username: 'bryan4',
      email: 'bm@gmail',
      latitude: 9.0,
      longitude: 10.0,
    );

    List<User_info> users=<User_info>[];
    users.add(test);
    users.add(test2);
    users.add(test3);
    users.add(test4);

    return users;
  }


  void display_markers(List<User_info> users)
  {
    users.forEach((element) {
      add_marker(element);
      print("adding marker");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(10, 10),
            zoom: 10,
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
//
  void add_marker(User_info user_info) {
    setState(() {
      num lat, lng;
     lat = user_info.latitude as num;
     lng = user_info.longitude as num;
//it is possible but rare to have lat and lng null in this case it will crash
      markers.add(
          Marker(
            markerId: MarkerId(user_info.username as String),
            position: LatLng(
             lat as double,
             lng as double,
            ),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title:user_info.username as String ,
              snippet:user_info.username as String,
            )
          )
      );
    });
  }
}


