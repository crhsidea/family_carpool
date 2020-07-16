import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:family_carpool/screens/onBoarding.dart';
import 'package:flutter/material.dart';
import 'themes/colors.dart';
import 'package:http/http.dart' as http;

void main() {
  //loadDBUsers();
  return runApp(MyApp());
}

String baseaddr = "http://192.168.0.12:8080/";
int fakedata = 15;
String password = '12345678';
String descriptions = 'default database-loaded user';


Future loadDBUsers() async {

  List<String>names = [];

  for (int i = 0; i<fakedata; i++){
    names.add(faker.person.name());
  }

  for (int i = 0; i< fakedata; i++){

    print("generate data"+i.toString());
    String email = faker.internet.email();

    var tmp = {
      'description':descriptions,
      'years':Random().nextInt(15),
      'email':email,
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

  List<String>names = [];

  for (int i = 0; i<fakedata; i++){
    names.add(faker.person.name());
  }

  for (int i = 0; i< fakedata; i++){

    print("generate data"+i.toString());
    String email = faker.internet.email();

    var tmp = {
      'description':descriptions,
      'years':Random().nextInt(15),
      'email':email,
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'),
      ),
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
