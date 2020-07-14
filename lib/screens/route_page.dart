import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 450.0,
                      height: 500.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      decoration: new BoxDecoration(color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                            bottomLeft: const Radius.circular(25.0),
                            bottomRight:const Radius.circular(25.0) ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(1),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],),

                      width: 500.0,
                      height: 190.0,
                      child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                width: 50.0,
                                height: 75.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        alignment: Alignment.bottomLeft,

                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            "https://i.thecartoonist.me/cartoon-face-of-white-male.png")
                                    )
                                )),
                            Text(
                              "Mr.Swift",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),

                            Row(
                              children: <Widget>[
                                Text(
                                  "           Driver Age: 28     ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "     Driving EXP: 5 Yrs",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),

                            SizedBox(
                              height: 5.0,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Hero(
                                tag: "search",
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Destination: 3056 Green Street, Katy, TX",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ]
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
