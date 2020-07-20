import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:family_carpool/screens/route_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:family_carpool/widgets/home/top_container.dart';
import 'package:family_carpool/widgets/home/back_button.dart';
import 'package:family_carpool/widgets/home/my_textfield.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:family_carpool/notification_initializer.dart';

class CreateNewTaskPage extends StatefulWidget {
  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> {
  DateTime _date;
  TimeOfDay initTime;
  TimeOfDay endTime;
  TextEditingController startController;
  TextEditingController endController;
  TextEditingController descriptController;
  TextEditingController nameController;
  double lat = 0;
  double lng = 0;

  Future getIP()async{

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/ip.txt');
      String temp = await file.readAsString();
      setState(() {
        baseaddr = temp;
      });
      print(temp);
    } catch (e) {
      print("Couldn't read file");
    }
  }

  String baseaddr ;

  int combinetime(TimeOfDay t) {
    return DateTime(_date.year, _date.month, _date.day, t.hour, t.minute)
        .millisecondsSinceEpoch;
  }

  //TODO add so that it stores the rest of the route as json
  String getRouteJson() {
    var routeJson = {
      'description': descriptController.text.toString(),
      'title': nameController.text.toString()
    };
    //edit this line to add route waypoints (map string dynamic)
    //routeJson['points'] = ...
    return json.encode(routeJson).toString();
  }

  Future<String> getUserName() async {
    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/user.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }

    print("value is " + val);
    return val;
  }

  @override
  void initState() {
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    super.initState();
    getIP();
    startController = new TextEditingController();
    endController = new TextEditingController();
    descriptController = new TextEditingController();
    nameController = new TextEditingController();
  }

  Future submitRoute(BuildContext context) async {
    var timelist = [combinetime(initTime), combinetime(endTime)];
    var namelist = ['*${await getUserName()}'];
    var addrlist = [
      startController.text.toString(),
      endController.text.toString()
    ];

    notifyUser(nameController.text+' at ${initTime.hour}: ${initTime.minute/10}${initTime.minute%10}', descriptController.text, DateTime(combinetime(initTime)).subtract(Duration(minutes: 15)));

    String b = baseaddr +
        "routes/add/1/" +
        json.encode(timelist).toString() +
        "/" +
        json.encode(namelist).toString() +
        "/" +
        json.encode(addrlist).toString() +
        "/";
    //await http.get(baseaddr+"routes/add/1/"+json.encode(timelist).toString()+"/"+json.encode(namelist).toString()+"/"+json.encode(addrlist).toString()+"/"+lat.toString()+"/"+lng.toString()+"/"+getRouteJson());
    String username = await getUserName();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoutePreviewPage(
                isFirst: true,
                base: b,
                description: descriptController.text.toString(),
                name: nameController.text.toString(),
                addrList: addrlist,
                driver: username,
              )),
    );
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
        payload: '${time.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          submitRoute(context);
        },
        child: Icon(Icons.navigate_next),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Schedule New Trip',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(
                        label: 'Title',
                        controller: nameController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(_date != null
                                ? _date.toIso8601String().toString()
                                : "Date"),
                          ),
                          IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2222))
                                    .then((date) {
                                  setState(() {
                                    _date = date;
                                  });
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: DateTime.now().hour,
                                              minute: DateTime.now().minute))
                                      .then((value) {
                                    setState(() {
                                      initTime = value;
                                    });
                                  });
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: DateTime.now().hour,
                                              minute: DateTime.now().minute))
                                      .then((value) {
                                    setState(() {
                                      endTime = value;
                                    });
                                  });
                                });
                              })
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text(initTime != null
                              ? initTime.format(context).toString()
                              : "Start Time")),
                      SizedBox(width: 40),
                      Expanded(
                        child: Text(endTime != null
                            ? endTime.format(context).toString()
                            : "End Time"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: 'Start Address',
                    minLines: 3,
                    maxLines: 3,
                    controller: startController,
                  ),
                  MyTextField(
                    label: 'End Address',
                    minLines: 3,
                    maxLines: 3,
                    controller: endController,
                  ),
                  MyTextField(
                    label: 'Description',
                    minLines: 3,
                    maxLines: 3,
                    controller: descriptController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          //direction: Axis.vertical,
                          alignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 0,
                          //textDirection: TextDirection.rtl,
                          spacing: 10.0,
                          children: <Widget>[
                            Chip(
                              label: Text("SPORT APP"),
                              backgroundColor: LightColors.kRed,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            Chip(
                              label: Text("MEDICAL APP"),
                            ),
                            Chip(
                              label: Text("RENT APP"),
                            ),
                            Chip(
                              label: Text("NOTES"),
                            ),
                            Chip(
                              label: Text("GAMING PLATFORM APP"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: width,
                    child: Text("I'm the Map"),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
