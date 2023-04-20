import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'pages/home_page.dart';
import 'pages/login_register_page.dart';
import 'users.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super (key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree>{
  Future<Widget> _buildWidget() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final notifiedUsers = await user!.readNotifiedUsers(uid);
      return HomeMenu(notifiedUsers);
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: _buildWidget(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(value: 0.5, strokeWidth: 2,));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data!;
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}