import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'update_profile_screen.dart';
import '../auth.dart';
import '../users.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<User_info?> readUser() async {
    User_info? user = new User_info();
    String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    final ref = FB.collection('users').doc(uid).withConverter(
      fromFirestore: User_info.fromFirestore,
      toFirestore: (User_info user_info, _) => user_info.toFirestore(),
    );

    final temp = await ref.get();
    if (temp.exists) {
      user = temp.data();
    }

    return user;
  }

  Future<String?> readUsername() async {
    User_info? user_info = await readUser();
    String? username = user_info?.username;
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        /*leading: IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.arrow_left_sharp),
        ),*/
        title: Text(
          "Profile page",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber.withOpacity(0.1),
                      ),
                      child:
                          const Icon(Icons.edit, size: 20, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<String?>(
                future: readUsername(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String? username = snapshot.data;
                    return Text(
                      username ?? 'No username',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }
                },
              ),
              Text(user?.email ?? 'User email',
                  style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const UpdatedProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[600],
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ProfileMenuWidget(
                title: "Settings",
                icon: Icons.settings,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Information",
                icon: Icons.info_outline_rounded,
                onPress: () {},
              ),
              const Divider(color: Colors.grey),
              const SizedBox(
                height: 10,
              ),
              ProfileMenuWidget(
                title: "Log out",
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Auth().signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.arrow_right_sharp,
                  size: 18.0, color: Colors.grey),
            )
          : null,
    );
  }
}
