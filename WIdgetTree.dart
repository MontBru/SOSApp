import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart'as http;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
 String? mtoken = " ";
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();



  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }
  initInfo()
  {
  var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSInitialize = const DarwinInitializationSettings();
  var initializationSettings =  InitializationSettings(android:  androidInitialize, iOS: iOSInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

FirebaseMessaging.onMessage.listen((RemoteMessage message)async
{
  print("_____onMessage______");
  print("onMessage:${message.notification?.title}/${message.notification?.body}}");

  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    message.notification!.body.toString(), htmlFormatBigText: true,
    contentTitle: message.notification!.title.toString(),htmlFormatContentTitle:true,
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('dbfood', 'dbfood', importance: Importance.max,
  styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true,);

  NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,);
  await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifics);
});

}

  void saveToken(String token) async
  {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User2").set({'token' : token,
      });
  }

  void getToken()async
  {
    await FirebaseMessaging.instance.getToken().then(
        (token){
          setState(() {
            mtoken =token;
            print("My token is $mtoken");
          });
          saveToken(token!);
        }
    );
  }

  void requestPermission()async
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
      provisional: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized)
        print("user granted Premision");
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
      print("user granted Premision");
    else print("user declined Premision");
  }

  Future<void> sendNotification(String title, String body, String deviceToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAmgL0EZw:APA91bFmVarmYwT4f7MbHy87AEpqsCjzQc3TUyu6cTqy_oREt4dCBKKyhbVSbb-oekuIyIoNXcMVEx_Q8UQLGP-lPkLgreniikgU8LuEiE1Gaa0sy0gWVUD_Cmsqp1sOEPEs_YrARHTP',
    };

    final data = <String, dynamic>{
      'notification': <String, dynamic>{
        'body': body,
        'title': title,
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'content_available': true
      },
      'to': deviceToken,
    };

    final response = await http.post(Uri.parse(postUrl),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Error sending notification: ${response.body}');
    }
  }

   SendPushNotification(String token, String title, String body)async
  {
    try
    {
      await http.post(
        Uri.parse('http://fcm.googleapis.com/fcm/send'),
        headers:  <String, String>{
          'Content-Type':'application/json',
          'Authorization':'key=AAAAmgL0EZw:APA91bFmVarmYwT4f7MbHy87AEpqsCjzQc3TUyu6cTqy_oREt4dCBKKyhbVSbb-oekuIyIoNXcMVEx_Q8UQLGP-lPkLgreniikgU8LuEiE1Gaa0sy0gWVUD_Cmsqp1sOEPEs_YrARHTP'
        },
        body:jsonEncode(
          <String,dynamic>
        {
          // 'priority':'high',
          //  'data':<String, dynamic>{
          //   'click_action':'FLUTTER_NOTIFICATION_CLICK',
          //    'status':'done',
          //    'body':body,
          //    'title':title,
          //  },

            "notification":<String, dynamic>{
            "title" :title,
            "body" :body,
            "android_channel_id":"dbfood"
            },
            "to":token,
          }

        ),
      );
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    }catch(e)
    {
      if(kDebugMode)
        {
          print("error push notification????????????????????????????????");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: username,
            ),
            TextFormField(
              controller: title,
            ),
            TextFormField(
              controller: body,
            ),
            GestureDetector (
              onTap: ()async{
                String name = username.text.trim();
                String titleText = title.text.trim();
                String bodyText = body.text.trim();
                print(name);
                sendNotification("f3EDBU43RFi0_O_FjU_KCK:APA91bHGf0-TGxhKVhChz92mEXlVHLqtIarMExeBHfDuB7tzr5fAtHHBs_Lpb5MAeN7osdbEv2RlAehDg7Dtdegf3YlRLHXBII1k3DDGqvQ6rpeYaf2KgR2kuGTsvNcku96A4Iv9S7hW", titleText, bodyText);

              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 20,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                    )
                  ]
                ),
                child: Center(child: Text("button"),),
              ),

              ),
          ],
        )


      ),
    );
  }
}
