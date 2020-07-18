import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:family_carpool/geolocation_test.dart';
import 'package:family_carpool/screens/onBoarding.dart';
import 'package:family_carpool/screens/profile_page.dart';
import 'package:family_carpool/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'themes/colors.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';

void main() {
//loadDBUsers();
  return runApp(MyApp());
}

String baseaddr = "http://192.168.0.1:8080/";
int fakedata = 15;
String password = '12345678';
String descriptions = 'default database-loaded user';
List<LatLng> latlngList = [
  LatLng(29.738780, -95.786730),
  LatLng(29.741880, -95.837590),
  LatLng(35.228180, -85.138690),
  LatLng(39.320150, -84.348000),
  LatLng(29.740620, -95.843690),
  LatLng(29.818045000, -95.750138000),
  LatLng(29.739850000, -95.843039000),
  LatLng(29.812450948, -95.686758114),
  LatLng(29.719892404, -95.760216941),
  LatLng(29.827598572, -94.802520752),
  LatLng(36.935630798, -88.756416321),
  LatLng(29.751233000, -95.768710000),
  LatLng(29.75426, -95.769907),
  LatLng(29.706597, -95.762257),
  LatLng(29.708229, -95.759916),
  LatLng(29.706330, -95.759380),
  LatLng(29.706710, -95.760350),
  LatLng(29.707781, -95.758141),
  LatLng(29.707080, -95.760330),
];
List<String> addressList = [
'3002 Aylesworth Court',
'3002 Altoria Hills Trail',
'3002 Autumn Terrace Lane',
'3002 Autumn Mist Court',
'3002 Brighton Sky Lane',
'3002 Bridge Water Manor Lane',
'3002 Bridle Bluff Court',
'3002 Barker Cypress Road',
'6969 Quiet Falls Court',
'69420 Avery Cove Lane',
'42069 Penshore Place Lane',
'2103 Amber Glen Dr',
'23202 Greenrush Dr',
'21927 Shady Heath Lane ',
'21807 Mystic Point Lane',
'21726 Grand Hollow Lane',
'21806 Columbia Falls Court',
'21614 Balsam Brook Lane',
'21811 Silverpeak Court',
];

int randomRoutes = 20;
String dates;
List<String> users;




Future loadDBUsers() async {
  List<String>names = [];

  for (int i = 0; i < fakedata; i++) {
    names.add(faker.person.name());
  }
  users = names;
  for (int i = 0; i < fakedata; i++) {
    print("generate data" + i.toString());
    String email = faker.internet.email();

    var tmp = {
      'description': descriptions,
      'years': Random().nextInt(15),
      'email': email,
    };

    await http.get(baseaddr +
        "users/add/1/" +
        names[i] +
        "/" +
        password +
        "/" +
        0.toString() +
        "/" +
        0.toString() +
        "/" +
        json.encode(tmp).toString() +
        "/" +
        json.encode(names).toString());
  }
}

Future loadDBRoutes() async {
  for(int i=0;i<randomRoutes;i++) {
    DateTime curDate = DateTime.now().add(Duration(days: Random().nextInt(7), minutes: Random().nextInt(60), hours: Random().nextInt(12),));
    List<int> dates = [curDate.millisecondsSinceEpoch, curDate.add(Duration(hours: 1)).millisecondsSinceEpoch];
    List<String> addresses = [];
    LatLng latLng = null;
    for(int i=0;i<Random().nextInt(4)+1;i++) {
      int random = Random().nextInt(addressList.length-1);
      addresses.add(addressList[random]);
      latLng = latlngList[random];
    }
    var routedata = {
      'title': 'generated route $i',
      'description': 'generated route $i',
      'eta': '15 min',
    };
    List<String> usersList = randomUsers(addresses.length);
    await http.get(baseaddr+'routes/add/1/'+json.encode(dates).toString()+'/'+json.encode(usersList).toString()+'/'+json.encode(addresses).toString()+'/'+latLng.latitude.toString()+'/'+latLng.longitude.toString()+'/'+json.encode(routedata).toString());
  }
}

randomAddress() {
  List<String> addresses = [];
  for(int i=0;i<Random().nextInt(4)+1;i++) {
    int random = Random().nextInt(addressList.length-1);
    addresses.add(addressList[random]);
  }
}

randomUsers(int length) {
  List<String> usersList = [];
  for(int i=0;i<length;i++) {
    usersList.add(users[Random().nextInt(users.length-1)]);
  }
  return usersList;
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme
            .of(context)
            .textTheme
            .apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'),
      ),
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
