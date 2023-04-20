import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../users.dart';

// class TermButton extends TextButton {
//   late String? username;
//   late String? uid;
//   TermButton(String? username, String? uid, onPressed, child)
//       : super(onPressed: onPressed, child: child, style: TextButton.styleFrom(
//     foregroundColor: Colors.white,
//     textStyle: TextStyle(fontSize: 20),
//   )) {
//     this.username = username;
//     this.uid = uid;
//   }
// }

class TermButton extends Text{
  late String? username;
  late String? uid;
  late String? email;
  late String? img;
  
  TermButton(String? username, String? email, String? uid) : super('$username', style: const TextStyle(fontSize: 20)) {
    this.username = username;
    this.uid = uid;
    this.img = 'assets/images/Avatar-Profile-Vector.png';
    this.email = email;
  }
}


class CustomSearchDelegate extends SearchDelegate {

  late List<TermButton> searchTerms;


  CustomSearchDelegate(this.searchTerms);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<TermButton> matchQuery = [];
    if(searchTerms.isNotEmpty) {
      for (var friend in searchTerms) {
        if (friend.username!.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(friend);
        }
      }
    }
    /*return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text('${result.username}'),
        );
      },
    );*/
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final stranger = matchQuery[index];
        return Slidable(
          startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.green,
                  icon: Icons.person_add_alt_1,
                  label: 'Add',
                  onPressed: (context) => _onDismissed(matchQuery, index),
                )
              ]),
          child: buildFriendListTile(stranger)
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<TermButton> matchQuery = [];
    if(searchTerms.isNotEmpty) {
      for (var friend in searchTerms) {
        if(friend.username != null) {
          if (friend.username!.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(friend);
          }
        }
      }
    }
    /*return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: result,
        );
      },
    );*/
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final stranger = matchQuery[index];
        return Slidable(
            startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.green,
                    icon: Icons.person_add_alt_1,
                    label: 'Add',
                    onPressed: (context) => _onDismissed(matchQuery, index),
                  )
                ]),
            child: buildFriendListTile(stranger)
        );
      },
    );
  }

  Future<void> _onDismissed(List<TermButton> strangersWidgets, int index) async {
    if(strangersWidgets.isNotEmpty) {
      final stranger = strangersWidgets[index];
      String? currUserUid = FirebaseAuth.instance.currentUser?.uid.toString();

      List<String?> currUserFriends = await user!.readFriends(currUserUid!);
      currUserFriends.add(stranger.uid);
      FirebaseFirestore.instance.collection('users').doc(currUserUid).update({
        'friends': currUserFriends,
      });


      List<String?> strangerFriends = await user!.readFriends(stranger.uid!);
      strangerFriends.add(currUserUid);
      FirebaseFirestore.instance.collection('users').doc(stranger.uid).update({
        'friends': strangerFriends,
      });

      strangersWidgets.removeAt(index);
    }
  }

  Widget buildFriendListTile(TermButton stranger) => ListTile(
    contentPadding: const EdgeInsets.all(16),
    title: Text('${stranger.username}', style: const TextStyle(
        color:Colors.white
    ),),
    subtitle: Text('${stranger.email}', style: const TextStyle(
        color: Color.fromARGB(255, 130, 122, 122)
    ),),
    leading: CircleAvatar(
      radius:30,
      backgroundImage: AssetImage('${stranger.img}') ,
    ),
  );
}
