import 'package:flutter/material.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:friends_menu/profile_screen.dart';
import 'friends_menu_widget.dart';
import 'frinds_page.dart';
import 'sos_button.dart';
import 'map.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  List<FriendsMenuWidget> friends = allusers;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Map(),
            Container(
            width: 100,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Column(
                children: [
                SizedBox(height: 30,),
                SizedBox(
                    width: 100,
                    height: 20,
                    
                  ),
                  CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amber,
                  child: IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    onPressed: () {
                     //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                    },
                  ),
                ),
                  SizedBox(
                    width: 100,
                    height: 20,
                  ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amber,
                  child: IconButton(
                    icon: Icon(
                      Icons.people,
                      color: Colors.black,
                    ),
                    onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const FriendsPage()),);
                    },
                  ),
                ),
                  SizedBox(
                    width: 100,
                    height: 20,
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
        
                      return buildFriendListTile(friend);
                    },
                  ),
                ),
                Spacer()
              ]),
          
            ]),
          ),
           Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(left:13, top: 750, right: 13, bottom: 15),
              //color: Colors.amber[600],
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        print("SOS");
                      },
                      child: Text("SOS"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))
                        ),
                        minimumSize:  Size(MediaQuery.of(context).size.width/1.3, 50),

                        primary: Colors.deepOrange
                      ),



                  ),


                  ElevatedButton(
                    onPressed: (){

                      openDialog();
                    },
                    child: Icon(Icons.apps),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 52, 48, 47),
                        // shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50))
                        // ),
                        minimumSize:  Size(MediaQuery.of(context).size.width/6.5, 50),
                        primary: Colors.deepOrange,

                    ),
                  ),

                ],
              ),
        )

        ]
        ),
      );

  Widget buildFriendListTile(FriendsMenuWidget friend) => ListTile(
        contentPadding: const EdgeInsets.only(top: 10, left: 30, bottom: 0),
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: IconButton(
            icon: Icon(Icons.abc),
            
            //iconSize: 50,
            onPressed: () {},
          ),
        ),
      );

    Future openDialog() => showDialog(context: context, builder: (context) => SimpleDialog(
    insetPadding: EdgeInsets.all(20),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
            
            ElevatedButton(onPressed: (){},
            child: Text("SOS"),
              style: ElevatedButton.styleFrom(
              
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              minimumSize:  Size(MediaQuery.of(context).size.width/6, 50),
              primary: Colors.deepOrange,

              ),) ,
              SizedBox(width: 10,),

              ElevatedButton(onPressed: (){},
              child: Text("SOS"),
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              minimumSize:  Size(MediaQuery.of(context).size.width/6, 50),
              primary: Colors.deepOrange,

              ),) ,
        ],
        ),
      SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
            ElevatedButton(onPressed: (){},
            child: Text("SOS"),
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            minimumSize:  Size(MediaQuery.of(context).size.width/6, 50),
            primary: Colors.deepOrange,

            ),) ,
            SizedBox(width: 10,),
            ElevatedButton(onPressed: (){},
            child: Text("SOS"),
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            minimumSize:  Size(MediaQuery.of(context).size.width/6, 50),
            primary: Colors.deepOrange,

            ),) ,
        ],
        ),

    ],
    backgroundColor: Colors.transparent,
    elevation: 0,
  )
    );
}