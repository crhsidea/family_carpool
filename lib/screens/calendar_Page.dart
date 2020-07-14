import 'package:family_carpool/widgets/home/back_button.dart';
import 'package:family_carpool/widgets/home/calendar_dates.dart';
import 'package:family_carpool/widgets/home/task_container.dart';
import 'package:flutter/material.dart';
import 'create_new_task_page.dart';
import 'package:family_carpool/dates_list.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:validators/sanitizers.dart';
import 'package:http/http.dart';



class CalendarPage extends StatelessWidget {
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

  String baseddr = 'http://192.168.0.12:8080/';

  int SelectedDate = DateTime.now().day;

  Future getRoute() {
    DateTime date;
    TimeOfDay initTime;
    TimeOfDay endTime;
    String startAddress;
    String endAddress;
    String title = '';
    String description = '';
    String names;
    double lat = 0;
    double lng = 0;

    //Route Data Receive Here


  }

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
                            'Add task',
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
                    'Productive Day, Sourav',
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
                  itemCount: days.length-1,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        SelectedDate = toInt(dates[index]);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                          ),
                          CalendarDates(
                            day:  days[DateTime.now().weekday+index],
                            date: dates[index],
                            dayColor: days[DateTime.now().weekday+index] == 'Sun' ? LightColors.kRed : Colors.black54,
                            dateColor: days[DateTime.now().weekday+index] == 'Sun' ? LightColors.kRed : LightColors.kDarkBlue,
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
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: time.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${time[index]} ${index == 0 || index > 11 && index < 24 ? 'PM' : 'AM'}',
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
                            Column(
                              children: <Widget>[
                                Container(
                                  height: 13.5,
                                ),
                                Container(
                                  height: 1212.5,
                                  child: Stack(
                                    children: <Widget>[
                                      for(int i=0;i<titleList.length;i++)
                                        dateList[i].day == SelectedDate ? Column(
                                          children: <Widget>[
                                            Container(
                                              height: 49.0*5,
                                            ),
                                            Container(
                                              child: TaskContainer(
                                                title: titleList[i],
                                                subtitle: descriptionList[i],
                                                boxColor: LightColors.kPalePink,
                                                size: 48.5*((endTimeList[i].hour*60+endTimeList[i].minute)-(initTimeList[i].hour*60+initTimeList[i].minute)/60),
                                              ),
                                            ),
                                          ],
                                        ) : Container()
                                    ],
                                  ),
                                ),
                              ],
                            ),
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



