import 'package:flutter/material.dart';
import 'package:flutter_dnd/flutter_dnd.dart';

void main()=>runApp(App());

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

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(
            child: Text("Requet Permission"),
            onPressed: requestPermission,
          ),
        ),
      ),
    );
  }
  Future<void> requestPermission() async {
    if(await FlutterDnd.isNotificationPolicyAccessGranted)
      await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
    else
      FlutterDnd.gotoPolicySettings();
  }
}

