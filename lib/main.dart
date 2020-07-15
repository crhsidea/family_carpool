import 'package:family_carpool/screens/community_page.dart';
import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/screens/onBoarding.dart';
import 'package:family_carpool/screens/route_page.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';
import 'themes/colors.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xffffb969), // status bar color
  ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'
        ),
      ),
      home: CommunityPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
