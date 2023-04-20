/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart' as http;

class sendNotification_____ extends StatefulWidget {
  @override
  _sendNotification_____State createState() => _sendNotification_____State();
}

class _sendNotification_____State extends State<sendNotification_____> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    });
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter FCM Demo'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            _firebaseMessaging.getToken().then((token) {
              print("Firebase Token: $token");
            });
            _sendNotification();
          },
          child: Text('Send Notification'),
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    String serverToken =
        'BMWTKzN53LoY6btCawmZ-QQcU8en21Dvcy_GFTZrVhq1JQPTJIlIoG53tebQwJDHKlS2zIGmPR6B4T7BuugWYuw';

    // get the device token
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      String tokenString = token;
      print("Firebase Token: $tokenString");
    }

    var url = 'https://fcm.googleapis.com/fcm/send';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };
    var body = jsonEncode({
      'notification': {'title': 'Hello', 'body': 'World'},
      'priority': 'high',
      'data': {<
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': token
    });
    var response = await http.post(url, headers: headers, body: body);
    print('FCM response: ${response.body}');
  }
}*/