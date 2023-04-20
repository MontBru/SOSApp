import 'package:flutter/material.dart';
import '../friends_menu_widget.dart';

class AlertMenu extends StatefulWidget {
  const AlertMenu({Key? key}) : super(key: key);

  @override
  State<AlertMenu> createState() => _AlertMenuState();
}

class _AlertMenuState extends State<AlertMenu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FriendsMenuWidget>>(
      future: (getDetectedAlerts()),
      builder: (BuildContext context, AsyncSnapshot<List<FriendsMenuWidget>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.grey,));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<FriendsMenuWidget>? detectedAlert = snapshot.data;
          if(detectedAlert!.isNotEmpty){
            return Expanded(
              child: ListView.builder(
                itemCount: detectedAlert.length,
                itemBuilder: (context, index) {
                  final friend = detectedAlert[index];

                  return buildFriendListTile(friend,index);
                },
              ),
            );
          } else
          {
            return const SizedBox();
          }
        }
      },
    );
  }

  Widget buildFriendListTile(FriendsMenuWidget friend,int index) => ListTile(
    contentPadding: const EdgeInsets.only(top: 0, left: 23.5, bottom: 10),
    leading: FloatingActionButton(
      heroTag: index,
      onPressed: () {
        //tuka pishi
      },
      backgroundColor: Colors.red,
      elevation: 0,
      child: const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg')
      ),
    ),
  );
}
