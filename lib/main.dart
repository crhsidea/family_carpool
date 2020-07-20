import 'dart:convert';

import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/screens/onBoarding.dart';
import 'package:family_carpool/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'themes/colors.dart';
import 'package:http/http.dart' as http;


void debugHttp() async {
  var h = await http.get('http://192.168.0.101:8080/users');
  print('this'+ json.decode(h.body).toString());
}

void main() {
  //DBLoad();
  debugHttp();
  return runApp(MyApp());
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
