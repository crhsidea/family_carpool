import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';
import 'themes/colors.dart';
import 'package:flutter/services.dart';
import 'screens/home_page.dart';
import 'widgets/bottom_bar.dart';

void main() {
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
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'
        ),
      ),
      home: BottomBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
