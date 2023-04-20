import 'package:firebase_auth/firebase_auth.dart';
import '../users.dart';

class FriendsMenuWidget {
  final String? name;
  final String? email;
  final String? img;
  final String? uid;

  FriendsMenuWidget(
      {
        required this.img,
        required this.name,
        required this.email,
        required this.uid,
      }
      );

}

Future<List<FriendsMenuWidget>> getDetectedAlerts() async {
  List<FriendsMenuWidget> allUsers = [];
  List<String?> detectedAlerts = await user!.readDetectedAlerts(
  FirebaseAuth.instance.currentUser!.uid);
  for (var uid in detectedAlerts) {
    if (uid != null) {
      String name = await user!.readUsername(uid);
      String email = await user!.readEmail(uid);
      allUsers.add(FriendsMenuWidget(
          img: 'assets/images/Avatar-Profile-Vector.png',
          name: name, email: email, uid: uid));
    }
  }

  return allUsers;
}

Future<List<FriendsMenuWidget>> getFriendsForListView() async {
  List<FriendsMenuWidget> friendsWidgets = [];
  String currUserUid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> friends = await user!.readFriends(currUserUid);
  for (var friendUid in friends) {
    String? name = await user!.readUsername(friendUid);
    String? email = await user!.readEmail(friendUid);
    friendsWidgets.add(FriendsMenuWidget(img: 'assets/images/Avatar-Profile-Vector.png',
        name: name, email: email, uid: friendUid));
  }

  return friendsWidgets;
}



/*
FriendsMenuWidget(name: 'Kaloyan',email: 'kaloyan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Brayan',email: 'brayan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Ivan',email: 'ivan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Nikola',email: 'nikola@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Kaloyan',email: 'kaloyan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Brayan',email: 'brayan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Ivan',email: 'ivan@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
  FriendsMenuWidget(name: 'Nikola',email: 'nikola@gmail',img: 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
 */