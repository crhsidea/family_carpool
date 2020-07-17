import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/screens/route_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:family_carpool/widgets/home/top_container.dart';
import 'package:family_carpool/widgets/home/back_button.dart';
import 'package:family_carpool/widgets/home/my_textfield.dart';
import 'package:path_provider/path_provider.dart';

class CreateNewTaskPage extends StatefulWidget {
  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> {
  DateTime _date;
  TimeOfDay initTime;
  TimeOfDay endTime;
  TextEditingController startController;
  TextEditingController endController;
  TextEditingController descriptController;
  TextEditingController nameController;
  double lat = 0;
  double lng = 0;

  String baseaddr = "http://192.168.0.12:8080/";

  int combinetime(TimeOfDay t) {
    return DateTime(_date.year, _date.month, _date.day, t.hour, t.minute)
        .millisecondsSinceEpoch;
  }

  //TODO add so that it stores the rest of the route as json
  String getRouteJson() {
    var routeJson = {
      'description': descriptController.text.toString(),
      'title': nameController.text.toString()
    };
    //edit this line to add route waypoints (map string dynamic)
    //routeJson['points'] = ...
    return json.encode(routeJson).toString();
  }

  Future<String> getUserName() async {
    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/language.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }

    print("value is " + val);
    return val;
  }

  @override
  void initState() {
    super.initState();
    startController = new TextEditingController();
    endController = new TextEditingController();
    descriptController = new TextEditingController();
    nameController = new TextEditingController();
  }

  Future submitRoute(BuildContext context) async {
    var timelist = [combinetime(initTime), combinetime(endTime)];
    var namelist = [await getUserName()];
    var addrlist = [
      startController.text.toString(),
      endController.text.toString()
    ];

    String b = baseaddr +
        "routes/add/1/" +
        json.encode(timelist).toString() +
        "/" +
        json.encode(namelist).toString() +
        "/" +
        json.encode(addrlist).toString() +
        "/";
    //await http.get(baseaddr+"routes/add/1/"+json.encode(timelist).toString()+"/"+json.encode(namelist).toString()+"/"+json.encode(addrlist).toString()+"/"+lat.toString()+"/"+lng.toString()+"/"+getRouteJson());

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoutePreviewPage(
                isFirst: true,
                base: b,
                description: descriptController.text.toString(),
                name: nameController.text.toString(),
                addrList: addrlist,
              )),
    );
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          submitRoute(context);
        },
        child: Icon(Icons.navigate_next),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Schedule New Trip',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(
                        label: 'Title',
                        controller: nameController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(_date != null
                                ? _date.toIso8601String().toString()
                                : "Date"),
                          ),
                          IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2222))
                                    .then((date) {
                                  setState(() {
                                    _date = date;
                                  });
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: DateTime.now().hour,
                                              minute: DateTime.now().minute))
                                      .then((value) {
                                    setState(() {
                                      initTime = value;
                                    });
                                  });
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: DateTime.now().hour,
                                              minute: DateTime.now().minute))
                                      .then((value) {
                                    setState(() {
                                      endTime = value;
                                    });
                                  });
                                });
                              })
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text(initTime != null
                              ? initTime.format(context).toString()
                              : "Start Time")),
                      SizedBox(width: 40),
                      Expanded(
                        child: Text(endTime != null
                            ? endTime.format(context).toString()
                            : "End Time"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: 'Start Address',
                    minLines: 3,
                    maxLines: 3,
                    controller: startController,
                  ),
                  MyTextField(
                    label: 'End Address',
                    minLines: 3,
                    maxLines: 3,
                    controller: endController,
                  ),
                  MyTextField(
                    label: 'Description',
                    minLines: 3,
                    maxLines: 3,
                    controller: descriptController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          //direction: Axis.vertical,
                          alignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 0,
                          //textDirection: TextDirection.rtl,
                          spacing: 10.0,
                          children: <Widget>[
                            Chip(
                              label: Text("SPORT APP"),
                              backgroundColor: LightColors.kRed,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            Chip(
                              label: Text("MEDICAL APP"),
                            ),
                            Chip(
                              label: Text("RENT APP"),
                            ),
                            Chip(
                              label: Text("NOTES"),
                            ),
                            Chip(
                              label: Text("GAMING PLATFORM APP"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: width,
                    child: Text("I'm the Map"),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
