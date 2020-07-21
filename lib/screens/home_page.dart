import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:family_carpool/screens/route_preview_page.dart';
import 'package:family_carpool/widgets/load_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:family_carpool/widgets/home/task_column.dart';
import 'package:family_carpool/widgets/home/actice_project_card.dart';
import 'package:http/http.dart' as http;
import 'package:simple_gravatar/simple_gravatar.dart';

import '../notification_initializer.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  void initState(){

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    super.initState();

    addNotification();
    addEndNotification();

    getRoutes();
  }

  Dio dio = new Dio();

  Future addNotification() async {
    List<DateTime> notified = new List<DateTime>();
    for(int i=0;i<(await FlutterLocalNotificationsPlugin().pendingNotificationRequests()).length;i++) {
      notified.add(DateTime.parse((await FlutterLocalNotificationsPlugin().pendingNotificationRequests())[i].payload));
    }
    for(int i=0;i<personal.length;i++) {
      bool exists = false;
      for(int e=0;i<notified.length;i++) {
        if(json.decode(personal[i]['dates'])[0]==notified[e]) {
          exists = true;
          break;
        }
      }
      if(!exists) {
        notifyUser(json.decode(personal[i]['routedata'])['title'], json.decode(personal[i]['routedata'])['description'], DateTime(json.decode(personal[i]['dates'])[0]));
      }
    }
  }

  Future addEndNotification() async {
    List<DateTime> notified = new List<DateTime>();
    for(int i=0;i<(await FlutterLocalNotificationsPlugin().pendingNotificationRequests()).length;i++) {
      notified.add(DateTime.parse((await FlutterLocalNotificationsPlugin().pendingNotificationRequests())[i].payload));
    }
    for(int i=0;i<personal.length;i++) {
      bool exists = false;
      for(int e=0;i<notified.length;i++) {
        if(json.decode(personal[i]['dates'])[1]==notified[e]) {
          exists = true;
          break;
        }
      }
      if(!exists) {
        notifyUser(json.decode(personal[i]['routedata'])['title'], json.decode(personal[i]['routedata'])['description'], DateTime(json.decode(personal[i]['dates'])[0]));
      }
    }
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

  List<dynamic> suggested = [];

  List<dynamic> personal = [];

  String baseaddr;

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


  Future<String> getCurUser() async {
    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/user.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }
    return val;
  }

  bool loaded = false;
  int indivs = 0;
  int pools = 0;

  String uname = "";

  List<Widget> recItems = [
  Text(
  "Recommended",
  style: TextStyle(
  color: LightColors.kDarkBlue,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.2),
  ),
    SizedBox(height: 5.0),];

  List<Color> colors = [LightColors.kGreen, LightColors.kRed, LightColors.kDarkYellow, LightColors.kDarkYellow];

  Future addCarpool (dynamic route)async{
    List<dynamic> users = json.decode(route['users']);
    users.insert(0, uname);
    List<dynamic> addrs = json.decode(route['addresses']);
    addrs.insert(0, addrController.text.toString());
    await http.get(baseaddr+"routes/update/"+route['id'].toString()+"/"+route['dates']+"/"+json.encode(users).toString()+"/"+json.encode(addrs).toString()+"/"+route['lat'].toString()+"/"+route['lng'].toString()+"/"+route['routedata']);

    Navigator.push(
      cont,
      MaterialPageRoute(builder: (context) => RoutePreviewPage(
        isFirst: false,
        name: json.decode(route['routedata'])['title'],
        description: json.decode(route['routedata'])['description'],
        isRoute: false,
        isViewer: true,
        base: baseaddr,
        addrList: addrs,
        driver: json.decode(route['users'])[0],
      ))
    );
  }

  TextEditingController addrController = TextEditingController();
  TextEditingController ipControlller = TextEditingController();

  setIP() async{

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/ip.txt');
    await file.writeAsString("http://"+ipControlller.text.toString()+":8080/");

    String temp = await file.readAsString();
    print(temp);

    Navigator.pop(
      cont
    );
  }

  _displayDialog(dynamic route) async {
    return showDialog(
        context: cont,
        builder: (context) {
          return AlertDialog(
            title: Text('Address'),
            content: TextField(
              controller: addrController,
              decoration: InputDecoration(hintText: "Place the address you want to join from "),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () async{
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('OK'),
                onPressed: () async{
                  await addCarpool(route);
                },
              ),

            ],
          );
        });
  }



  _diplayIPChange() async {
    return showDialog(
        context: cont,
        builder: (context) {
          return AlertDialog(
            title: Text('What is the IP Address of the Running Local Computer?'),
            content: TextField(
              controller: ipControlller,
              decoration: InputDecoration(hintText: "Usually found in network settings "),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed:setIP
              )
              ,new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> temp = [];


  Future getRecs() async{
    List<double> lats = [];
    List<double> lngs = [];

    Set<String> uns = {};
    for (dynamic m in personal){
      lats.add(m['lat']);
      lngs.add(m['lng']);
    }

    for (int i = 0; i< lats.length; i++){
      var h = await http.get(baseaddr+"routes/rec/"+lats[i].toString()+"/"+lngs[i].toString());
      for (dynamic recdata in json.decode(h.body)){
        print(recdata.length.toString());
        if (!recdata['users'].contains(uname)&&uns.add(recdata['id'].toString())){
          setState(() {
            suggested.add(recdata);
          });
        }
      }
    }

    print("SUGGESTED"+ suggested.length.toString());
    bool on = false;

    int ind = 0;

    for (int i = 0; i<suggested.length; i++){
      print(temp.toString());
      setState(() {
        temp.insert(0,
            GestureDetector(
              onTap:(){
                _displayDialog(suggested[i]);
              },
              child: Flexible(
                flex: 1,
                child: ActiveProjectsCard(
                  cardColor: colors[ind%4],
                  loadingPercent: Random().nextDouble(),
                  title: json.decode(suggested[i]['routedata'])['title'],
                  subtitle:json.decode(suggested[i]['routedata'])['description'],
                ),
              ),
            ));
      });
      if(on){
        setState(() {
          recItems.add(Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: temp,
            ),
          ));
          temp = [];
        });
      }

      ind++;
      on = !on;
    }

  }

  dynamic udata;

  Future getRoutes() async {

    await getIP();

    //Route Data Receive Here
    var username = await getCurUser();

    setState(() {
      uname = username;
    });
    loadGravatar();

    var u = await http.get(baseaddr + "users/byname/" + username);


    udata = json.decode(u.body);

    var h = await http.get(baseaddr + "routes/name/" + username);

    print(h.body.toString());
    for (var data in json.decode(h.body)) {
      print(data);
      if(json.decode(data['users']).length>1)
        pools++;
      else
        indivs++;
      setState(() {
        personal.add(data);
      });
    }

    setState(() {
      loaded = true;
    });

    await getRecs();

  }

  BuildContext cont;

  bool gravloaded = false;

  String gravurl = 'https://i.kym-cdn.com/photos/images/original/001/398/111/d5a';

  void loadGravatar(){
    var gravatar = Gravatar(uname);
    setState(() {
      gravurl = gravatar.imageUrl(
        size: 100,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true,
      );
      gravloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: LightColors.kLightYellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200,
            width: width,
            decoration: new BoxDecoration(
              color: LightColors.kDarkBlue,
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(60.0),
                  bottomRight: const Radius.circular(60.0)),
              boxShadow: [
                BoxShadow(
                  color: LightColors.kDarkBlue,
                  spreadRadius: 3,
                  blurRadius:1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),

            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu,
                            color: Colors.white, size: 30.0),
                        onPressed: _diplayIPChange,
                      ),
                      IconButton(
                        icon: Icon(Icons.add,
                            color: Colors.white, size: 30.0),
                          // Within the `FirstRoute` widget
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoadDataPage(userdata: udata,)),
                            );
                          },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: 0.75,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: LightColors.kWhite,
                          backgroundColor: Colors.black,
                          center: CircleAvatar(
                            backgroundColor: LightColors.kBlue,
                            radius: 35.0,
                            backgroundImage: NetworkImage(
                                gravurl
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                uname,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: LightColors.kWhite,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'App User',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Expanded(
            child: Container(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('My Carpools'),

                            ],
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Individual',
                            subtitle: indivs.toString()+' trips now. ',
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'Suggested',
                            subtitle: suggested.length.toString()+' trip',
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Confirmed',
                            subtitle: pools.toString()+' carpools now',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recItems
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}