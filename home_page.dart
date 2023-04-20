import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../users.dart';
import '../map_functions.dart';
import 'profile_menu_widget.dart';
import 'frinds_page.dart';
import '../map.dart';
import '../haversine_distance.dart';

class HomeMenu extends StatefulWidget {
  late bool clicked;

  HomeMenu(List<String> notifiedUsers) {
    print("I am in constructor HomeMenu");
    if(notifiedUsers.isEmpty) {
      clicked = true;
    } else {
      clicked = false;
    }
  }

  @override
  State<HomeMenu> createState() => _HomeMenuState(clicked);
}

class _HomeMenuState extends State<HomeMenu> {
  bool clicked;
  num alertType = 0;
  Set<Marker> markers = {};

  _HomeMenuState(this.clicked);

  Future<Set<Marker>> futureFunctions() async {
    print("I am in function futureFunctions");
    await pushLocationToFirebase();
    markers = await pushMarkers(markers);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
    body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('sos').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder<Set<Marker>>(
                  future: futureFunctions(),
                  builder: (context, markersSnapshot) {
                    if (markersSnapshot.hasData) {
                      return Map(markersSnapshot.data!);
                    } else if (markersSnapshot.hasError) {
                      return const Text('Error loading markers');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return const Text('Error loading data');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(
            width: 100,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Column(
                  children: [
                    const SizedBox(height: 30,),
                    const SizedBox(
                      width: 100,
                      height: 20,

                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 70, 68, 68),
                      child: IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 70, 68, 68),
                      child: IconButton(
                        icon: const Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const FriendsPage()),);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      height: 20,
                    ),
                  //  Spacer(),
                   // AllertMenu(),
                  ]),

            ]),
          ),
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left:13, top: 740, right: 30, bottom: 10),
            //color: Colors.amber[600],
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    List<String?> notifiedUsersUids = await usersToNotify();
                    if(clicked)
                    {
                      print("SOS");

                      // update sos collection
                      FirebaseFirestore.instance
                          .collection('sos')
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isEmpty) {
                          FirebaseFirestore.instance.collection('sos').doc('sos_document').set({'signals': 1});
                        } else {
                          FirebaseFirestore.instance.collection('sos').doc('sos_document').update({'signals': FieldValue.increment(1)});
                        }
                      });

                      // update users collection
                      for(String? notifiedUserUid in notifiedUsersUids) {
                        List<String?> detectedAlerts = await user!.readDetectedAlerts(notifiedUserUid!);
                        detectedAlerts.add(uid);
                        await FirebaseFirestore.instance.collection('users').doc(notifiedUserUid)
                            .update({'detected_alerts': detectedAlerts});
                      }

                      await FirebaseFirestore.instance.collection('users').doc(uid)
                          .update({'notified_users': notifiedUsersUids});
                    }
                    else
                    {
                      print("Stop");

                      // update sos collection
                      FirebaseFirestore.instance
                          .collection('sos')
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isEmpty) {
                          FirebaseFirestore.instance.collection('sos').doc('sos_document').set({'signals': 1});
                        } else {
                          FirebaseFirestore.instance.collection('sos').doc('sos_document').update({'signals': FieldValue.increment(1)});
                        }
                      });

                      // update users collection
                      await FirebaseFirestore.instance.collection('users').doc(uid)
                          .update({'alert_type': 0});

                      for(String? notifiedUserUid in notifiedUsersUids) {
                        List<String?> detectedAlerts = await user!.readDetectedAlerts(notifiedUserUid!);
                        detectedAlerts.remove(uid);
                        await FirebaseFirestore.instance.collection('users').doc(notifiedUserUid)
                            .update({'detected_alerts': detectedAlerts});
                      }

                      await FirebaseFirestore.instance.collection('users').doc(uid)
                            .update({'notified_users': []});
                    }

                      setState(() {
                        clicked = !clicked;
                      });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: clicked ? Colors.red : Colors.blueGrey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))
                      ),
                      minimumSize:  Size(screenWidth/1.5, 80),
                      maximumSize: Size(screenWidth/1.50, 80),
                      primary: Colors.deepOrange
                  ),
                  icon: clicked ? const Icon(Icons.notifications_active) : const Icon(Icons.arrow_left_sharp),
                  label: clicked ? const Text("SOS", style: TextStyle(fontSize: 20)) : const Text("Stop", style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await openDialog();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 84, 84, 84),
                    // shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50))
                    // ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/15, 80),
                    maximumSize:  Size(MediaQuery.of(context).size.width/7, 80),
                    primary: Colors.deepOrange,
                  ),
                  child: const Icon(Icons.menu),
                ),
              ],
            ),
          )
       ]
    ),
  );
  }

  Future openDialog() {
    return showDialog(context: context, builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          elevation: 0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                const SizedBox(width: 15,),
                ElevatedButton(onPressed: () async {
                  await _on_press(5);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 184, 92),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.local_fire_department, color: Color.fromARGB(255, 186, 24, 12),),
                      Text("Fire", style: TextStyle(color: Color.fromARGB(255, 186, 24, 12)))
                    ],
                  ),) ,
                const SizedBox(width: 7,),

                ElevatedButton(onPressed: () async {
                  await _on_press(6);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 235, 203, 214),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/8, 70),
                    primary: Colors.deepOrange,

                  ),
                  child:  Column(children: const [
                    Icon(Icons.monitor_heart_outlined, color: Colors.red,),
                    Text("Hospital emergency", style: TextStyle(color: Colors.red),),

                  ]),) ,
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                ElevatedButton(onPressed: () async {
                  await _on_press(2);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.car_crash_rounded, color: Color.fromARGB(255, 231, 225, 225),),
                    Text("Car emergency", style: TextStyle(color: Color.fromARGB(255, 231, 225, 225)),)
                  ]),) ,
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () async {
                  await _on_press(1);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 144, 212, 243),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.ac_unit, color: Colors.white,),
                    Text("Avalanche", style: TextStyle(color: Colors.white),)
                  ]),) ,
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                ElevatedButton(onPressed: () async {
                  await _on_press(4);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 79, 59, 52),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.album_outlined, color: Color.fromARGB(255, 169, 105, 82),),
                    Text("Earthquake", style: TextStyle(color: Color.fromARGB(255, 169, 105, 82)),)
                  ]),) ,
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () async {
                  await _on_press(8);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.water_drop, color: Colors.blue,),
                    Text("Water damage", style: TextStyle(color: Colors.blue),)
                  ]),) ,
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                ElevatedButton(onPressed: () async {
                  await _on_press(3);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 38, 188, 22),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.assistant_direction_rounded, color: Color.fromARGB(255, 225, 224, 224)),
                    Text("Directions", style: TextStyle(color: Color.fromARGB(255, 225, 224, 224)),)
                  ]),) ,
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () async {
                  await _on_press(7);
                  Navigator.of(context).pop();
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 75, 73, 73),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    minimumSize:  Size(MediaQuery.of(context).size.width/6, 70),
                    primary: Colors.deepOrange,

                  ),
                  child: Column(children: const [
                    Icon(Icons.tornado, color: Colors.grey,),
                    Text("Tornado & wind", style: TextStyle(color: Colors.grey),)
                  ]),) ,
              ],
            ),
          ],
        ),
      );
    }
    );
  }

  Future<void> _on_press(num alert_type) async {
    print("I am in function _on_press");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<String?> notified_users_uids = await usersToNotify();
    if(clicked)
    {
      print("SOS");

      await FirebaseFirestore.instance.collection('users').doc(uid)
          .update({'alert_type': alert_type});

      for(String? notified_user_uid in notified_users_uids) {
        List<String?> detected_alerts = await user!.readDetectedAlerts(notified_user_uid!);
        detected_alerts.add(uid);
        await FirebaseFirestore.instance.collection('users').doc(notified_user_uid)
            .update({'detected_alerts': detected_alerts});
      }

      await FirebaseFirestore.instance.collection('users').doc(uid)
          .update({'notified_users': notified_users_uids});
    }
    else
    {
      print("Stop");

      await FirebaseFirestore.instance.collection('users').doc(uid)
          .update({'alert_type': 0});

      for(String? notified_user_uid in notified_users_uids) {
      List<String?> detected_alerts = await user!.readDetectedAlerts(notified_user_uid!);
      detected_alerts.remove(uid);
      await FirebaseFirestore.instance.collection('users').doc(notified_user_uid)
          .update({'detected_alerts': detected_alerts});
      }

      await FirebaseFirestore.instance.collection('users').doc(uid)
          .update({'notified_users': []});
    }

    clicked = !clicked;
  }
}