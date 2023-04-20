import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

num haversineDistance(num? coordinate1lng,num? coordinate1lat,num? coordinate2lng,num? coordinate2lat)
{
  num R=6371.0710;//earth radius

  num radianslat1=coordinate1lat!*(pi/180);
  num radianslat2=coordinate2lat!*(pi/180);
  num radianslng1=coordinate1lng!*(pi/180);
  num radianslng2=coordinate2lng!*(pi/180);

  num latdiff=radianslat1-radianslat2;
  num lngdiff=radianslng1-radianslng2;

  num distance=2*R*asin(
      sqrt(
          sin(latdiff/2)*sin(latdiff/2)
              +cos(radianslat1)*cos(radianslat2)*
              sin(lngdiff/2)*sin(lngdiff/2)
      )
  );
  return distance;
}

// Future<List<String?>?> getFriendsFromQuery() async {
//   final querySnapshot =
//   await FirebaseFirestore.instance.collection('users').get();
//
//   final stringList = querySnapshot.docs.map((doc) {
//     final value = doc.get('uid');
//     return value is String ? value : null;
//   }).toList();
//
//   return stringList;
// }

Future<List<String?>> getFriendsFromQuery() async {
  final querySnapshot =
  await FirebaseFirestore.instance.collection('users').get();

  if (querySnapshot.docs.isEmpty) {
    return [];
  }

  final stringList = querySnapshot.docs.map((doc) {
    final value = doc.data()['uid'];
    return value is String ? value : null;
  }).toList();

  // final stringList = querySnapshot.docs
  //     .map((doc) => doc.data()['uid'] as String?)
  //     .where((value) => value != null)
  //     .toList();

  return stringList;
}

// Future<List<String?>> getFriendsFromQuery() async {
//   final querySnapshot =
//   await FirebaseFirestore.instance.collection('users').get();
//
//   final stringList = querySnapshot.docs.map((doc) {
//     final value = doc.data()['uid'];
//     return value is String ? value : null;
//   }).toList();
//
//   return stringList;
// }


Future<List<String?>> usersToNotify() async { // UNTESTED
  /*User_info? user = User_info();
  List<String?> usersToNotify = <String?>[];

  // get all uids from collection
  List<String?>? uids = await getFriendsFromQuery();

  // get current user's uid
  String? curr_user_uid = FirebaseAuth.instance.currentUser?.uid.toString();

  // check distance and add users under 1 kilometer
  uids!.forEach((curr_doc) async {
    if(curr_doc != curr_user_uid) {
      if(haversine_distance(
          await user.readLongitude(curr_user_uid),
          await user.readLatitude(curr_user_uid),
          await user.readLongitude(curr_doc),
          await user.readLatitude(curr_doc)) < 1){
    usersToNotify.add(curr_doc);
    }
  }
  });

  // if users are under 10
  if(usersToNotify.length < 10){
    List<User_info?> users_info = <User_info?>[];

    // add all users to list
    uids.forEach((curr_uid) async {
      if(!(curr_uid == curr_user_uid)) {
        User_info? curr = await user.readUser(curr_uid);
        curr?.latitude = await user.readLatitude(curr_uid);
        curr?.longitude = await user.readLongitude(curr_uid);
        curr?.email = await user.readEmail(curr_uid);
        curr?.username = await user.readUsername(curr_uid);
        curr?.uid = curr_uid;

        users_info.add(curr);
      }
    });

    // sort users by distance
    users_info.sort((a,b){
      num? distance = haversine_distance(a?.longitude, a?.latitude, b?.longitude, b?.latitude);
      return distance.toInt();
    });

    // get the nearest ten users
    usersToNotify.clear();
    Iterator<User_info?> current_user = users_info.iterator;
    for(int i = 0; i < 10 && current_user.moveNext(); i++) {
      usersToNotify.add(current_user.current!.uid);
    }
  }

  return usersToNotify;*/
  List<String?> uids = await getFriendsFromQuery();
  String? currUserUid = FirebaseAuth.instance.currentUser?.uid.toString();
  uids.remove(currUserUid);

  return uids;
}