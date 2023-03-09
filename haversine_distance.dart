import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'users.dart';

num haversine_distance(num? coordinate1lng,num? coordinate1lat,num? coordinate2lng,num? coordinate2lat)
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

Future<List<User_info?>> UsersToNotify() async {
  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot = await _collectionRef.get();
  User_info? user = User_info();
  List<User_info?> usersToNotify = <User_info?>[];

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList() as Map<String, dynamic>;
  Iterable<String?> uids = allData.keys;
  Iterator<String?> curr_doc = uids.iterator;
  String? curr_user_uid = FirebaseAuth.instance.currentUser?.uid.toString();

  while(curr_doc.moveNext() && curr_doc.current != curr_user_uid) {
    if(haversine_distance(await user.readLongitude(curr_user_uid), await user.readLatitude(curr_user_uid),
        await user.readLongitude(curr_doc.current), await user.readLatitude(curr_doc.current)) < 1){
      usersToNotify.add(await user.readUser(curr_doc.current));
    }
  }

  if(usersToNotify.length < 10){
    List<String?> all_uids = allData.values.map((value) => value?.toString()).toList();
    List<User_info?> users_info = <User_info?>[];

    for(Iterator<String?> curr_uid = all_uids.iterator; curr_uid.moveNext();){
      User_info? curr = await user.readUser(curr_uid.current);
      curr?.latitude = await user.readLatitude(curr_uid.current);
      curr?.longitude = await user.readLongitude(curr_uid.current);
      curr?.email = await user.readEmail(curr_uid.current);
      curr?.username = await user.readUsername(curr_uid.current);
      curr?.uid = curr_uid.current;

      users_info.add(curr);
    }

    all_uids.clear();

    users_info.sort((a,b){
      num? distance = haversine_distance(a?.longitude, a?.latitude, b?.longitude, b?.latitude);
      return distance.toInt();
    });

    Iterator<User_info?> curr = users_info.iterator;
    usersToNotify.clear();
    //start from second user because the first one is the user in SOS
    while(curr.moveNext()){
      usersToNotify.add(curr.current);
    }
  }

  return usersToNotify;
}
