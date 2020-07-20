import 'dart:convert';

import 'package:family_carpool/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'themes/colors.dart';
import 'package:http/http.dart' as http;



void main() {
  //DBLoad();
  testStreams().then((strm){

    print("STARTED");
    strm.listen((event) {
      print(event.toString());
    });
  });
  return runApp(MyApp());
}


Future<Stream<dynamic>>testStreams()async{

  print("started request");
  String url = "http://192.168.0.12:8080/users/locstream";


  var client = http.Client();
  var streamedResponse = await client.send(
      http.Request('get', Uri.parse(url))
  );
  //var request = await http.get("http://192.168.0.12:8080/users/locstream");
  //print(request.body.toString());
  return streamedResponse.stream.transform(utf8.decoder);
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
      home: SignUpPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
