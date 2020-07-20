import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:family_carpool/screens/community_page.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/screens/calendar_Page.dart';
import 'package:family_carpool/themes/colors.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  //Sketask sketisk, put the community widget in this list
  final List<Widget> _children = [HomePage(), CalendarPage(), CommunityPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: MediaQuery.of(context).size.height / 13,
          buttonBackgroundColor: LightColors.kBlue,
          color: LightColors.kDarkBlue,
          backgroundColor: LightColors.kWhite,
          items: <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white,),
            Icon(Icons.calendar_today, size: 30, color: Colors.white,),
            Icon(Icons.people, size: 30, color: Colors.white,),
          ],
          onTap: (index) {
            onTabTabbed(index);
          },
        ),
        body: _children[_currentIndex]);
  }

  void onTabTabbed(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(index);
  }
}
