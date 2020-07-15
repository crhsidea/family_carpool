import 'package:family_carpool/themes/colors.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  Widget getContainer(String name, String address, String image) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0),
      child: Container(
        width: 450.0,
        height: 70.0,
        decoration: new BoxDecoration(
          color: LightColors.kLightYellow2,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
              bottomLeft: const Radius.circular(25.0),
              bottomRight: const Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              color: LightColors.kRed,
              spreadRadius: 1,
              blurRadius: 7,
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
              color: Colors.pink,
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        backgroundColor: LightColors.kLightYellow,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              " Carpools",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
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
                      labelColor: _theme.primaryColor,
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: _theme.primaryColor,
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
                              getContainer('Morning Gym', "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer('Robotics Trip', "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer('Marine Trip', "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                              SizedBox(
                                height: 15.0,
                              ),
                              getContainer('Beach Trip', "12345 fish rd",
                                  'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                            ],
                          ),
                          Container(
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                              ],
                            ),
                          ),
                          Container(
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
                                SizedBox(
                                  height: 15.0,
                                ),
                                getContainer('Gym', "12345 fish rd",
                                    'https://i.thecartoonist.me/cartoon-face-of-white-male.png'),
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
