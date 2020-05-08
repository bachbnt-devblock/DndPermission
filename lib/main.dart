import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:dndpermission/new_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final MethodChannel platform = MethodChannel('crossingthestreams.io/resourceResolver');
  bool isNotificationPolicyAccessGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Request permission"),
              onPressed: turnOffDND,
            ),
            RaisedButton(
              child: Text("Turn off DND"),
              onPressed: turnOffDND,
            ),
            RaisedButton(
              child: Text("Turn off DND"),
              onPressed: turnOffDND,
            ),
            RaisedButton(
              child: Text("Turn on DND"),
              onPressed: turnOnDND,
            ),
            RaisedButton(
              child: Text("Push notification without sound"),
              onPressed: pushNotificationWithoutSound,
            ),
            RaisedButton(
              child: Text("Push notification with sound"),
              onPressed: pushNotificationWithSound,
            )
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission()async{
    isNotificationPolicyAccessGranted= await FlutterDnd.isNotificationPolicyAccessGranted;
  }

  Future<void> turnOffDND() async {
    if (isNotificationPolicyAccessGranted)
      await FlutterDnd.setInterruptionFilter(
          FlutterDnd.INTERRUPTION_FILTER_ALL);
    else
      FlutterDnd.gotoPolicySettings();
  }

  Future<void> turnOnDND() async {
    if (isNotificationPolicyAccessGranted)
      await FlutterDnd.setInterruptionFilter(
          FlutterDnd.INTERRUPTION_FILTER_NONE);
    else
      FlutterDnd.gotoPolicySettings();
  }

  Future<void> selectNotification(String payload) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewScreen()));
  }

  Future<void> pushNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.Max,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([200, 100, 200, 100]),
        visibility: NotificationVisibility.Public,
        playSound: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, "title", "body", platformChannelSpecifics);
  }

  Future<void> pushNotificationWithSound() async {
    String alarmUri = await platform.invokeMethod('getNotificationUri');
    final x = UriAndroidNotificationSound(alarmUri);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.Max,
        importance: Importance.High,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([1000, 2000, 1000, 2000]),
        sound: x,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'title', 'body', platformChannelSpecifics);
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    var initializationSettingsAndroid = AndroidInitializationSettings(
        "app_icon");
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (a, b, c, d) async {});
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: selectNotification);
  }
}

