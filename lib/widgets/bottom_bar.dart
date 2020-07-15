import 'package:family_carpool/screens/community_page.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/screens/calendar_Page.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:family_carpool/screens/TestContainer.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentIndex = 0;
  //Sketask sketisk, put the community widget in this list
  final List<Widget> _children = [
    HomePage(),
    CalendarPage(),
    CommunityPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: LightColors.kLightYellow2,
          onTap: onTabTabbed,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text("Calendar")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_city),
                title: Text("Community")
            ),
          ],
        ),
    );
  }

  void onTabTabbed (int index){
    setState(() {
      _currentIndex = index;
    });
    print(index);
  }

}
