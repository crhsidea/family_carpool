import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_initializer.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {

  int r = 200;
  int g = 50;
  int b = 50;
  int min = 50;
  int max = 200;

  @override
  void initState() {
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        if(r!=min&&g==max&&b==min) {
          r--;
        }
        if(r==min&&g!=min&&b==max) {
          g--;
        }
        if(r==max&&g==min&&b!=min) {
          b--;
        }
        if(r==max&&g<max&&b==min) {
          g++;
        }
        if(r==min&&g==max&&b<max) {
          b++;
        }
        if(r<max&&g==min&&b==max) {
          r++;
        }
      });
    });
    super.initState();
  }

  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                //todo: put page to navigate to here
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      //todo: put page to navigate to here
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> notifyUser(String title, String body, DateTime time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, time, platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(r, g, b, 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            child: RaisedButton(
              highlightColor: Colors.transparent,
              disabledColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              color: Colors.transparent,
              highlightElevation: 50,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              onPressed: () async {
                await notifyUser('Notification', 'flutter_local_notification works', DateTime.now());
              },
            ),
          ),
        ),
      ),
    );
  }
}
