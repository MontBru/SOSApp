import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
final FBI = FirebaseFirestore.instance;

class User_info {
  late final String? username;
  late final String? email;
  late final String? uid;
  late final String? token;
  late final List<String>? friends;
  late final List<String>? detected_alerts;
  late final List<String>? notified_users;
  late final num? latitude;
  late final num? longitude;
  late final num? alert_type;

  User_info({
    this.username,
    this.email,
    this.uid,
    this.token,
    this.friends,
    this.detected_alerts,
    this.notified_users,
    this.latitude,
    this.longitude,
    this.alert_type,
  });

  factory User_info.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return User_info(
      username: data?['username'],
      email: data?['email'],
      uid: data?['uid'],
      token: data?['token'],
      friends: data?['friends'].map((item) => item.toString()).toList().cast<String>(),
      detected_alerts: data?['detected_alerts'].map((item) => item.toString()).toList().cast<String>(),
      notified_users: data?['notified_users'].map((item) => item.toString()).toList().cast<String>(),
      latitude: data?['latitude'],
      longitude: data?['longitude'],
      alert_type: data?['alert_type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (uid != null) "uid": uid,
      if (token != null) "token": token,
      if (friends != null) "friends": friends,
      if (detected_alerts != null) "detected_alerts": detected_alerts,
      if (notified_users != null) "notified_users": notified_users,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (alert_type != null) "alert_type": alert_type,
    };
  }

  Future<User_info?> readUser(String? uid) async {
    User_info? user =     User_info();

    final ref = FBI.collection('users').doc(uid as String).withConverter(
      fromFirestore: User_info.fromFirestore,
      toFirestore: (User_info user_info, _) => user_info.toFirestore(),
    );

    final temp = await ref.get();
    if (temp.exists) {
      user = temp.data();
    }

    return user;
  }

  Future<List<String?>> readDetected_alerts(String? uid) async{
    List<String?> detected_alerts = <String?>[];

    await FBI.collection("users").doc(uid).get().then((value){
      final users_data = List.from(value.data()!['detected_alerts']);
      detected_alerts = users_data.map((item) => item.toString()).toList().cast<String>();
    });

    return detected_alerts;
  }

  Future<List<String?>> readNotified_users(String? uid) async{
    List<String?> notified_users = <String?>[];

    await FBI.collection("users").doc(uid).get().then((value){
      final users_data = List.from(value.data()!['notified_users']);
      notified_users = users_data.map((item) => item.toString()).toList().cast<String>();
    });

    return notified_users;
  }

  Future<List<String?>> readFriends(String? uid) async{
    List<String?> friends = <String?>[];

    await FBI.collection("users").doc(uid).get().then((value){
        final users_data = List.from(value.data()!['friends']);
        friends = users_data.map((item) => item.toString()).toList().cast<String>();
    });

    return friends;
  }

  Future<String?> readUsername(String? uid) async {
    User_info? user_info = await readUser(uid);
    String? username = user_info?.username;
    return username;
  }

  Future<String?> readEmail(String? uid) async {
    User_info? user_info = await readUser(uid);
    String? email = user_info?.email;
    return email;
  }

  Future<String?> readToken(String? uid) async {
    User_info? user_info = await readUser(uid);
    String? token = user_info?.token;
    return token;
  }

  Future<num?> readLatitude(String? uid) async {
    User_info? user_info = await readUser(uid);
    num? latitude = user_info?.latitude;
    return latitude;
  }

  Future<num?> readLongitude(String? uid) async {
    User_info? user_info = await readUser(uid);
    num? longitude = user_info?.longitude;
    return longitude;
  }

  Future<num?> readAlert_type(String? uid) async {
    User_info? user_info = await readUser(uid);
    num? alert_type = user_info?.alert_type;
    return alert_type;
  }
}
