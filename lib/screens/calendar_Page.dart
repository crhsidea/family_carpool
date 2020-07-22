import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/screens/route_preview_page.dart';
import 'package:family_carpool/widgets/home/back_button.dart';
import 'package:family_carpool/widgets/home/calendar_dates.dart';
import 'package:family_carpool/widgets/home/task_container.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'create_new_task_page.dart';
import 'package:family_carpool/dates_list.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:validators/sanitizers.dart';
import 'package:http/http.dart' as http;



class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
        TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  List<DateTime> dateList = new List<DateTime>();

  List<TimeOfDay> initTimeList = new List<TimeOfDay>();

  List<TimeOfDay> endTimeList = new List<TimeOfDay>();

  List<String> startAddressList = new List<String>();

  List<String> endAddressList = new List<String>();

  List<String> titleList = new List<String>();

  List<String> descriptionList = new List<String>();

  List<String> namesList = new List<String>();

  List<double> latList = new List<double>();

  List<double> lngList = new List<double>();

  int SelectedDate = DateTime.now().day;

  Future<String> getCurUser() async {

    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/user.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }
    return val;

  }


  bool loaded = false;
  String baseaddr ;
  Future getIP()async{

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/ip.txt');
      String temp = await file.readAsString();
      setState(() {
        baseaddr = temp;
      });
      print(temp);
    } catch (e) {
      print("Couldn't read file");
    }
  }



  List<dynamic> routeList = [];

  Future getRoutes() async{

    await getIP();

    //Route Data Receive Here
    var username = await getCurUser();

    var h = await http.get(baseaddr+"routes/name/"+username);


    print(json.encode(["6", "hello", "hi"]));

    for (var data in json.decode(h.body)){
      print(data);
      setState(() {
        routeList.add(data);
        dateList.add(DateTime.fromMillisecondsSinceEpoch(json.decode(data['dates'])[0]));
        initTimeList.add(TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(json.decode(data['dates'])[0])));
        endTimeList.add(TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(json.decode(data['dates'])[1])));
        startAddressList.add(json.decode(data['addresses'])[0]);
        endAddressList.add(json.decode(data['addresses'])[1]);
        titleList.add(json.decode(data['routedata'])['title']);
        descriptionList.add(json.decode(data['routedata'])['description']);
        namesList.add(data['users'].toString());
        latList.add(data['lat']);
        lngList.add(data['lng']);
      });
    }

    setState(() {
      loaded = true;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoutes();
  }

  int tmphour = 0;
  int tmpmin = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              MyBackButton(),
              SizedBox(height: 30.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Today',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 40.0,
                      width: 120,
                      decoration: BoxDecoration(
                        color: LightColors.kGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewTaskPage(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Add trip',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ready to Travel',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${month[DateTime.now().month]}, ${DateTime.now().year}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 58.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          SelectedDate = toInt(dates[index]);
                          tmpmin = 0;
                          tmphour = 0;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                          ),
                          CalendarDates(
                            day:  days[DateTime.now().weekday+index%7],
                            date: dates[index],
                            dayColor: days[DateTime.now().weekday+index%7] == 'Sun' ? Colors.redAccent : Colors.black54,
                            dateColor: days[DateTime.now().weekday+index%7] == 'Sun' ? Colors.redAccent : LightColors.kDarkBlue,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 1270,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: time.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${time[index]} ${index == 0 || index > 11 && index < 24 ? 'PM' : 'AM'}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 1223.5,
                              width: MediaQuery.of(context).size.width-110,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Container(
                                    height: 3,
                                  ),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                  _dashedText(),
                                ],
                              ),
                            ),
                            loaded?
                                Container(
                                  height: 1212.5,
                                  width: 280,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: titleList.length,
                                      itemBuilder: (BuildContext context, int i){
                                      print("CURRENT DATE IS"+ SelectedDate.toString());
                                      if(dateList[i].day==SelectedDate){
                                        var tm = tmpmin;
                                        var th = tmphour;
                                        tmpmin = endTimeList[i].minute;
                                        tmphour = endTimeList[i].hour;
                                        return
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 50*((endTimeList[i].hour)-th+((endTimeList[i].minute-tm)/60))
                                            ),
                                            child: GestureDetector(
                                              onTap: (){
                                                print(routeList[i].toString());
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => RoutePreviewPage(
                                                    isFirst: false,
                                                    name: json.decode(routeList[i]['routedata'])['title'],
                                                    description: json.decode(routeList[i]['routedata'])['description'],
                                                    isRoute: true,
                                                    isViewer: true,
                                                    base: baseaddr,
                                                    addrList: json.decode(routeList[i]['addresses']),
                                                    driver:json.decode(routeList[i]['users'])[0]
                                                  )),
                                                );
                                              },
                                              child: Container(
                                                child: TaskContainer(
                                                  title: titleList[i],
                                                  subtitle: descriptionList[i],
                                                  boxColor: LightColors.kDarkBlue,
                                                  size: 50*((endTimeList[i].hour+endTimeList[i].minute/60)-(initTimeList[i].hour+initTimeList[i].minute/60)).abs(),
                                                ),
                                              ),
                                            ),
                                          );
                                      }
                                      else
                                        return Container();
                                      }),

                            ):Center( child:CircularProgressIndicator()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



