import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LoadDataPage extends StatefulWidget{


  final dynamic userdata;

  const LoadDataPage({Key key, this.userdata}) : super(key: key);

  @override
  _LoadDataPageState createState() => _LoadDataPageState();
}

class _LoadDataPageState extends State<LoadDataPage> {

  @override
  void initState(){
    getIP();
    super.initState();
  }

  BuildContext cont;

  TextEditingController addrController = new TextEditingController();


  _displayAddrChange() async {
    return showDialog(
        context: cont,
        builder: (context) {
          return AlertDialog(
            title: Text('What is your Address'),
            content: TextField(
              controller: addrController,
              decoration: InputDecoration(hintText: "Enter in format of address, city, state"),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('OK'),
                  onPressed:DBLoad
              )
              ,new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool loaded = true;

  String baseaddr = "";
  int fakedata = 15;
  String password = '12345678';
  String descriptions = 'default database-loaded user';
  List<LatLng> latlngList = [
    LatLng(29.738780, -95.786730),
    LatLng(29.741880, -95.837590),
    LatLng(35.228180, -85.138690),
    LatLng(39.320150, -84.348000),
    LatLng(29.740620, -95.843690),
    LatLng(29.818045000, -95.750138000),
    LatLng(29.739850000, -95.843039000),
    LatLng(29.812450948, -95.686758114),
    LatLng(29.719892404, -95.760216941),
    LatLng(29.827598572, -94.802520752),
    LatLng(36.935630798, -88.756416321),
    LatLng(29.751233000, -95.768710000),
    LatLng(29.75426, -95.769907),
    LatLng(29.706597, -95.762257),
    LatLng(29.708229, -95.759916),
    LatLng(29.706330, -95.759380),
    LatLng(29.706710, -95.760350),
    LatLng(29.707781, -95.758141),
    LatLng(29.707080, -95.760330),
  ];

  List<String> addressList = [
    '3002 Aylesworth Court',
    '3002 Altoria Hills Trail',
    '3002 Autumn Terrace Lane',
    '3002 Autumn Mist Court',
    '3002 Brighton Sky Lane',
    '3002 Bridge Water Manor Lane',
    '3002 Bridle Bluff Court',
    '3002 Barker Cypress Road',
    '6969 Quiet Falls Court',
    '69420 Avery Cove Lane',
    '42069 Penshore Place Lane',
    '2103 Amber Glen Dr',
    '23202 Greenrush Dr',
    '21927 Shady Heath Lane ',
    '21807 Mystic Point Lane',
    '21726 Grand Hollow Lane',
    '21806 Columbia Falls Court',
    '21614 Balsam Brook Lane',
    '21811 Silverpeak Court',
  ];

  int randomRoutes = 20;
  String dates;
  List<String> users;


  Future DBLoad() async{


    Navigator.pop(cont);

    setState(() {
      loaded = false;
    });
    await loadDBUsers();
    await loadDBRoutes();
    setState(() {
      loaded = true;
    });
    Navigator.pop(cont);
  }

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

  Future loadDBUsers() async {
    List<String>names = [];

    for (int i = 0; i < fakedata; i++) {
      names.add(faker.person.name());
    }
    users = names;
    for (int i = 0; i < fakedata; i++) {
      print("generate data" + i.toString());
      String email = faker.internet.email();

      var tmp = {
        'description': descriptions,
        'years': Random().nextInt(15),
        'email': email,
        'age':20+Random().nextInt(35)
      };

      await http.get(baseaddr +
          "users/add/1/" +
          names[i] +
          "/" +
          password +
          "/" +
          0.toString() +
          "/" +
          0.toString() +
          "/" +
          json.encode(tmp).toString() +
          "/" +
          json.encode(names).toString());
    }
  }


  Future loadDBRoutes() async {

    Set<String> friends = {};
    bool add = false;
    for(int i=0;i<randomRoutes;i++) {
      DateTime curDate = DateTime.now().add(Duration(days: Random().nextInt(7), minutes: Random().nextInt(60), hours: Random().nextInt(12),));
      List<int> dates = [curDate.millisecondsSinceEpoch, curDate.add(Duration(hours: 1)).millisecondsSinceEpoch];
      List<String> addresses = [];
      LatLng latLng;
      for(int i=0;i<Random().nextInt(4)+1;i++) {
        int random = Random().nextInt(addressList.length-1);
        addresses.add(addressList[random]);
        latLng = latlngList[random];
      }
      var routedata = {
        'title': 'generated route $i',
        'description': 'generated route $i',
        'eta': '15 min',
      };
      List<String> usersList = randomUsers(addresses.length);
      if (add){
        usersList.insert(0, widget.userdata['name']);
        addresses.insert(0, addrController.text.toString());
      }
      friends.addAll(usersList);
      add = !add;

      await http.get(baseaddr+'routes/add/1/'+json.encode(dates).toString()+'/'+json.encode(usersList).toString()+'/'+json.encode(addresses).toString()+'/'+latLng.latitude.toString()+'/'+latLng.longitude.toString()+'/'+json.encode(routedata).toString());
    }
    List<String> frs = [];
    for (String n in friends){
      frs.add(n);
    }

    print(baseaddr+'users/update/'+widget.userdata['id'].toString()+'/'+widget.userdata['name']+'/'+widget.userdata['password']+'/'+widget.userdata['lat'].toString()+'/'+widget.userdata['lng'].toString()+'/'+widget.userdata['userdata']+'/'+json.encode(frs).toString());
    await http.get(baseaddr+'users/update/'+widget.userdata['id'].toString()+'/'+widget.userdata['name']+'/'+widget.userdata['password']+'/'+widget.userdata['lat'].toString()+'/'+widget.userdata['lng'].toString()+'/'+widget.userdata['userdata']+'/'+json.encode(frs).toString());


  }

  randomAddress() {
    List<String> addresses = [];
    for(int i=0;i<Random().nextInt(4)+1;i++) {
      int random = Random().nextInt(addressList.length-1);
      addresses.add(addressList[random]);
    }
  }

  randomUsers(int length) {
    List<String> usersList = [];
    for(int i=0;i<length;i++) {
      usersList.add(users[Random().nextInt(users.length-1)]);
    }
    return usersList;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    cont = context;
    return Scaffold(
      body: Center(
        child: loaded?FlatButton(
          onPressed: _displayAddrChange,
          child: Text("LOAD IN DATA TO DATABASE"),
        ):CircularProgressIndicator()
      ),
    );
  }
}