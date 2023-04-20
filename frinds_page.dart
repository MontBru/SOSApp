import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../pages/add_friends.dart';
import '../friends_menu_widget.dart';
import '../users.dart';
import '../haversine_distance.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  //final TextEditingController search = TextEditingController();

  bool isSubstring(String sub, String str){
    for(int i = 0; i < sub.length; i++) {
      if(sub[i] != str[i]) {
        return false;
      }
    }
    return true;
  }

  // Future<List<TermButton>> search_terms() async {
  //   // final QuerySnapshot<Map<String, dynamic>> snapshot =
  //   // await FBI.collection('users').get();
  //   // List<Map<String, dynamic>> dataList = snapshot.docs.map((doc) => doc.data()).toList();
  //   // List<dynamic> dynamic_string = dataList.map((data) => data['friends']).cast<dynamic>().toList();
  //   // List<String?>? uids = dynamic_string.map((element) {
  //   //   if (element is String?) {
  //   //     return element;
  //   //   } else {
  //   //     return null;
  //   //   }
  //   // }).toList();
  //
  //   List<String?> uids = await getFriendsFromQuery();
  //   String? curr_user_uid = FirebaseAuth.instance.currentUser?.uid.toString();
  //   List<TermButton> searchTerms = [];
  //   final friends = await user!.readFriends(curr_user_uid!);
  //   int index = 0;
  //
  //   uids.forEach((element) async {
  //     if(uids.isEmpty || (!(element == curr_user_uid) && !friends.contains(element)))
  //     {
  //       String? username = await user!.readUsername(element!);
  //       searchTerms.add(TermButton(username, element, () async {
  //         List<String?> friends = await user!.readFriends(curr_user_uid);
  //         friends.add(element);
  //         FirebaseFirestore.instance.collection('users').doc(curr_user_uid).update(
  //             {
  //               'friends' : friends,
  //             }
  //         );
  //         setState(() {
  //           searchTerms.removeAt(index);
  //
  //         });
  //       }, Text('$username')));
  //     }
  //     index++;
  //   });
  //
  //   return searchTerms;
  // }

  Future<List<TermButton>> search_terms() async {
    // final QuerySnapshot<Map<String, dynamic>> snapshot =
    // await FBI.collection('users').get();
    // List<Map<String, dynamic>> dataList = snapshot.docs.map((doc) => doc.data()).toList();
    // List<dynamic> dynamic_string = dataList.map((data) => data['friends']).cast<dynamic>().toList();
    // List<String?>? uids = dynamic_string.map((element) {
    //   if (element is String?) {
    //     return element;
    //   } else {
    //     return null;
    //   }
    // }).toList();

    List<String?> friendsUids = await getFriendsFromQuery();
    String? currUserUid = FirebaseAuth.instance.currentUser?.uid.toString();
    List<TermButton> searchTerms = [];
    final friends = await user!.readFriends(currUserUid!);

    friendsUids.forEach((uid) async {
      if(friendsUids.isEmpty || (!(uid == currUserUid) && !friends.contains(uid)))
      {
        String? username = await user!.readUsername(uid!);
        String? email = await user!.readEmail(uid);
        searchTerms.add(TermButton(username, email, uid));
      }
    });

    return searchTerms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 30, 30),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text("Friends Page",
              style:TextStyle(
                color: Colors.white,
                fontSize: 22,
              )
          ),
          actions: [
            IconButton(
              onPressed: () async {
                List<TermButton> searchTerms = await search_terms();
                await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(searchTerms),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body:Container(
            margin: const EdgeInsets.all(17),
            //color: Colors.amber,
            child: Column(children: [
              FutureBuilder<List<FriendsMenuWidget>>(
                future: (getFriendsForListView()),
                builder: (BuildContext context, AsyncSnapshot<List<FriendsMenuWidget>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LinearProgressIndicator(color: Colors.grey,));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<FriendsMenuWidget>? friends = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: friends!.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return Slidable(
                              startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red[800]!,
                                      icon: Icons.delete_forever_rounded,
                                      label: 'Delete',
                                      onPressed: (context) => _onDismissed(friends, index),
                                    )
                                  ]),
                              child:buildFriendListTile(friend)
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],)
        )
    );
  }
  Future<void> _onDismissed(List<FriendsMenuWidget> friendsWidgets, int index) async {
    final friend = friendsWidgets[index];
    String? currUserUid = FirebaseAuth.instance.currentUser?.uid.toString();

    List<String?> currUserFriends = await user!.readFriends(currUserUid!);
    currUserFriends.remove(friend.uid);
    FirebaseFirestore.instance.collection('users').doc(currUserUid).update({
      'friends' : currUserFriends,
    });


    List<String?> friends = await user!.readFriends(friend.uid!);
    friends.remove(currUserUid);
    FirebaseFirestore.instance.collection('users').doc(friend.uid).update({
          'friends' : friends,
    });

    setState(() => friendsWidgets.removeAt(index));
  }

  Widget buildFriendListTile(FriendsMenuWidget friend) => ListTile(
    contentPadding: const EdgeInsets.all(16),
    title: Text('${friend.name}', style: const TextStyle(
        color:Colors.white
    ),),
    subtitle: Text('${friend.email}', style: const TextStyle(
        color: Color.fromARGB(255, 130, 122, 122)
    ),),
    leading: CircleAvatar(
      radius:30,
      backgroundImage: AssetImage('${friend.img}') ,
    ),
  );
//
}