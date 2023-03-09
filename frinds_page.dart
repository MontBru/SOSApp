

import 'package:buttons_sos/surch_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'friends_menu_widget.dart';


class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<FriendsMenuWidget> friends = allusers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
       body:Container(
            margin: EdgeInsets.all(17),
            //color: Colors.amber,
            child: Column(children: [
               Surchbar_(),
               Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];

                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete_forever_rounded,
                            label: 'Delete',
                            onPressed: (context) => _onDismissed(index),
                          )
                        ]),
                      child:buildFriendListTile(friend)
                    );
                  },
    ),
            )
            )
            ],) 
            
           )
  //         
        
      
      
    );
  }
  void _onDismissed(int index) {
    final friend = friends[index];
    setState(() => friends.removeAt(index));
   }

   Widget buildFriendListTile(FriendsMenuWidget friend) => ListTile(
        contentPadding: const EdgeInsets.all(16),
       title: Text(friend.name),
       subtitle: Text(friend.email),
       leading: CircleAvatar(
        radius:30,
        backgroundImage: NetworkImage(friend.img) ,
       ),
      );
  //   
}