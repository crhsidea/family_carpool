import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:family_carpool/screens/calendar_Page.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:family_carpool/widgets/home/task_column.dart';
import 'package:family_carpool/widgets/home/actice_project_card.dart';
import 'package:family_carpool/widgets/home/top_container.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  void initState(){
    super.initState();

    getRoutes();
  }

  List<dynamic> suggested = [];

  List<dynamic> personal = [];

  String baseaddr = "http://192.168.0.12:8080/";

  Future<String> getCurUser() async {
    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/language.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }
    return val;
  }

  bool loaded = false;
  int indivs = 0;
  int pools = 0;

  String uname = "";

  List<Widget> recItems = [
  Text(
  "Recommended",
  style: TextStyle(
  color: LightColors.kDarkBlue,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.2),
  ),
    SizedBox(height: 5.0),];

  List<Color> colors = [LightColors.kGreen, LightColors.kRed, LightColors.kDarkYellow, LightColors.kDarkYellow];
  
  Future addCarpool (dynamic route)async{

    _displayDialog();

    List<String> users = json.decode(route['users']);
    users.add(uname);
    List<String> addrs = json.decode(route['addresses']);
    addrs.insert(0, addrController.text.toString());
    await http.get(baseaddr+"routes/update/"+route['id'].toString()+"/"+route['dates']+"/"+json.encode(users).toString()+"/"+json.encode(addrs).toString()+"/"+route['lat'].toString()+"/"+route['lng'].toString()+"/"+route['routedata']);
  }

  TextEditingController addrController = TextEditingController();

  _displayDialog() async {
    return showDialog(
        context: cont,
        builder: (context) {
          return AlertDialog(
            title: Text('Address'),
            content: TextField(
              controller: addrController,
              decoration: InputDecoration(hintText: "Place the address you want to join from "),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  
  
  Future getRecs() async{
    List<double> lats = [];
    List<double> lngs = [];
    for (dynamic m in personal){
      lats.add(m['lat']);
      lngs.add(m['lng']);
    }
    
    for (int i = 0; i< lats.length; i++){
      var h = await http.get(baseaddr+"routes/rec/"+lats[i].toString()+"/"+lngs[i].toString());
      for (dynamic recdata in json.decode(h.body)){
        print(recdata.toString());
        if (!recdata['users'].contains(uname)){
          setState(() {
            suggested.add(recdata);
          });
        }
      }
    }

    bool on = false;
    List<Widget> temp = [];
    int ind = 0;

    for (dynamic item in suggested){
      if(on){
        temp.add(
            GestureDetector(
              onTap:(){
                addCarpool(item);
              },
              child: ActiveProjectsCard(
          cardColor: colors[ind%4],
          loadingPercent: Random().nextDouble(),
          title: json.decode(item['routedata'])['title'],
          subtitle:json.decode(item['routedata'])['description'],
        ),
            ));
        on = false;
      }
      else{
        temp.add(
            ActiveProjectsCard(
              cardColor: colors[ind%4],
              loadingPercent: Random().nextDouble(),
              title: json.decode(item['routedata'])['title'],
              subtitle:json.decode(item['routedata'])['description'],
            ));
        on = true;
        setState(() {
          recItems.add(Row(
            children: temp,
          ));
        });
        temp = [];
      }
      ind++;
    }
  }

  Future getRoutes() async {
    //Route Data Receive Here
    var username = await getCurUser();

    setState(() {
      uname = username;
    });

    var u = await http.get(baseaddr + "users/byname/" + username);


    var h = await http.get(baseaddr + "routes/name/" + username);

    print(h.body.toString());
    for (var data in json.decode(h.body)) {
      print(data);
      if(json.decode(data['users']).length>1)
        pools++;
      else
        indivs++;
      setState(() {
        personal.add(data);
      });
    }

    setState(() {
      loaded = true;
    });

    await getRecs();

  }
  
  BuildContext cont;
  

  @override
  Widget build(BuildContext context) {
    cont = context;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: LightColors.kLightYellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TopContainer(
            height: 200,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.menu,
                          color: LightColors.kDarkBlue, size: 30.0),
                      Icon(Icons.search,
                          color: LightColors.kDarkBlue, size: 25.0),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: 0.75,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: LightColors.kRed,
                          backgroundColor: LightColors.kDarkYellow,
                          center: CircleAvatar(
                            backgroundColor: LightColors.kBlue,
                            radius: 35.0,
                            backgroundImage: AssetImage(
                              'assets/images/Obama.PNG',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                uname,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'App User',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Expanded(
            child: Container(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('My Carpools'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalendarPage()),
                                  );
                                },
                                child: HomePage.calendarIcon(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Individual',
                            subtitle: indivs.toString()+' trips now. ',
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'Suggested',
                            subtitle: suggested.length.toString()+' trip',
                          ),
                          SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Confirmed',
                            subtitle: pools.toString()+' carpools now',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recItems
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}