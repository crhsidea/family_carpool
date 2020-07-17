import 'package:family_carpool/themes/colors.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  Widget getContainer(String name, String address, String image, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0),
      child: Container(
        width: 450.0,
        height: 70.0,
        decoration: new BoxDecoration(
          color: color,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
              bottomLeft: const Radius.circular(25.0),
              bottomRight: const Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              color: LightColors.kRed,
              spreadRadius: 0.1,
              blurRadius: 0,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0, right: 7.0),
            child: Container(
                alignment: Alignment.centerLeft,
                width: 40.0,
                height: 55.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        alignment: Alignment.bottomLeft,
                        fit: BoxFit.fill,
                        image: new NetworkImage(image)))),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(
            width: 80.0,
          ),
          IconButton(
            icon: Icon(
              Icons.map,
              color: LightColors.kGreen,
            ),
            onPressed: () {},
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,

      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              " Carpools",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: LightColors.DarkYellow,
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: LightColors.DarkYellow,
                      tabs: <Widget>[
                        Tab(
                          text: "Group Chats",
                        ),
                        Tab(
                          text: "Friends",
                        ),
                        Tab(
                          text: "Suggested",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              getContainer(
                                  'Morning Gym',
                                  "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                  LightColors.kLightRed),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer(
                                  'Robotics Trip',
                                  "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                  LightColors.kSuperLightGreen),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer(
                                  'Marine Tour',
                                  "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                  LightColors.kLightBlue),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer(
                                  'Beach Party',
                                  "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                  LightColors.kLightSand),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer(
                                  'School Event',
                                  "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                  LightColors.kLightPurple),
                            ],
                          ),
                          Container(
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                getContainer(
                                    'Morning Gym',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightRed),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Robotics Trip',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kSuperLightGreen),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Marine Tour',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightBlue),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Beach Party',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightSand),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'School Event',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightPurple),
                              ],
                            ),
                          ),
                          Container(
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                getContainer(
                                    'Morning Gym',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightRed),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Robotics Trip',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kSuperLightGreen),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Marine Tour',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightBlue),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'Beach Party',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightSand),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer(
                                    'School Event',
                                    "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png',
                                    LightColors.kLightPurple),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
