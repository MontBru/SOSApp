//import 'package:cloud_firestore/cloud_firestore.dart';

// final FB = FirebaseFirestore.instance;
class User_info {
  final String? username;
  final String? email;
  final num? latitude;
  final num? longitude;

  User_info({
    this.username,
    this.email,
    this.latitude,
    this.longitude,
  });

  // factory User_info.fromFirestore(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot,
  //     SnapshotOptions? options,
  //     ) {
  //   final data = snapshot.data();
  //   return User_info(
  //     username: data?['username'],
  //     email: data?['email'],
  //     latitude: data?['latitude'],
  //     longitude: data?['longitude'],
  //   );
  // }
  //
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (username != null) "username": username,
  //     if (email != null) "email": email,
  //     if (latitude != null) "latitude": latitude,
  //     if (longitude != null) "longitude": longitude,
  //   };
  // }
}