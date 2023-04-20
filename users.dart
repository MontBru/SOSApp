import 'package:cloud_firestore/cloud_firestore.dart';
final FBI = FirebaseFirestore.instance;

User_info? user = User_info(
  username: "",
  email: "",
  uid: "",
  alertType: 0,
  longitude: 0,
  latitude: 0,
  notifiedUsers: [],
  detectedAlerts: [],
  friends: [],
);

class User_info {
  late final String username;
  late final String email;
  late final String uid;
  late final List<String> friends;
  late final List<String> detectedAlerts;
  late final List<String> notifiedUsers;
  late final num latitude;
  late final num longitude;
  late final num alertType;

  User_info({
    required this.username,
    required this.email,
    required this.uid,
    required this.friends,
    required this.detectedAlerts,
    required this.notifiedUsers,
    required this.latitude,
    required this.longitude,
    required this.alertType,
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
      friends: data?['friends'].map((item) => item.toString()).toList().cast<String>(),
      detectedAlerts: data?['detected_alerts'].map((item) => item.toString()).toList().cast<String>(),
      notifiedUsers: data?['notified_users'].map((item) => item.toString()).toList().cast<String>(),
      latitude: data?['latitude'],
      longitude: data?['longitude'],
      alertType: data?['alert_type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "friends": friends,
      "detected_alerts": detectedAlerts,
      "notified_users": notifiedUsers,
      "latitude": latitude,
      "longitude": longitude,
      "alert_type": alertType,
    };
  }

  Future<User_info> readUser(String uid) async {
    User_info user = User_info(
      username: "",
      email: "",
      uid: "",
      alertType: 0,
      longitude: 0,
      latitude: 0,
      notifiedUsers: [],
      detectedAlerts: [],
      friends: [],
    );

    final ref = FBI.collection('users').doc(uid).withConverter(
      fromFirestore: User_info.fromFirestore,
      toFirestore: (User_info user_info, _) => user_info.toFirestore(),
    );

    final temp = await ref.get();
    if (temp.exists) {
      user = temp.data()!;
      print(user.username);
    }

    return user;
  }

  Future<List<String>> readDetectedAlerts(String uid) async{
    List<String> detectedAlerts = <String>[];

    await FBI.collection("users").doc(uid).get().then((value){
      final usersData = List.from(value.data()!['detected_alerts']);
      detectedAlerts = usersData.map((item) => item.toString()).toList().cast<String>();
    });

    return detectedAlerts;
  }

  // Future<List<String>> readNotifiedUsers(String uid) async{
  //   List<String> notifiedUsers = <String>[];
  //
  //   await FBI.collection("users").doc(uid).get().then((value){
  //     final usersData = List.from(value.data()!['notified_users']);
  //     notifiedUsers = usersData.map((item) => item.toString()).toList().cast<String>();
  //   });
  //
  //   return notifiedUsers;
  // }

  Future<List<String>> readNotifiedUsers(String uid) async {
    final docSnapshot = await FBI.collection("users").doc(uid).get();

    if (!docSnapshot.exists) {
      return []; // document with the given UID not found
    }

    final usersData = List<String>.from(docSnapshot.data()!['notified_users']);
    final notifiedUsers = usersData.map((item) => item.toString()).toList();

    return notifiedUsers;
  }

  Future<List<String>> readFriends(String uid) async{
    List<String> friends = <String>[];

    await FBI.collection("users").doc(uid).get().then((value){
        final usersData = List.from(value.data()!['friends']);
        friends = usersData.map((item) => item.toString()).toList().cast<String>();
    });

    return friends;
  }

  Future<String> readUsername(String uid) async {
    User_info userInfo = await readUser(uid);
    String username = userInfo.username;
    return username;
  }

  Future<void> changeUsername(String uid, String username) async {
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .update({'username': username});
  }

  Future<String> readEmail(String uid) async {
    User_info userInfo = await readUser(uid);
    String email = userInfo.email;
    return email;
  }

  Future<num> readLatitude(String uid) async {
    User_info userInfo = await readUser(uid);
    num latitude = userInfo.latitude;
    return latitude;
  }

  Future<num> readLongitude(String uid) async {
    User_info userInfo = await readUser(uid);
    num longitude = userInfo.longitude;
    return longitude;
  }

  Future<num> readAlertType(String uid) async {
    User_info userInfo = await readUser(uid);
    num alertType = userInfo.alertType;
    return alertType;
  }
}