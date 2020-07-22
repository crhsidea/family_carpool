import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/screens/chat_page.dart';
import 'package:family_carpool/screens/profile_page.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:simple_gravatar/simple_gravatar.dart';


class CommunityPage extends StatefulWidget {



  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  bool loaded = false;


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

  String baseaddr ;

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

  @override
  void initState(){
    super.initState();

    getRoutes();
    newFriendController = new TextEditingController();
  }



  List<Widget> chats = [];

  List<String> friendnames = [];
  String loadGravatar(String uname){
    var gravatar = Gravatar(uname);
    String gravurl = gravatar.imageUrl(
        size: 50,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true,
      );
    return gravurl;
  }

  Future getRoutes() async {
    //Route Data Receive Here

    await getIP();
    var username = await getCurUser();

    var h = await http.get(baseaddr + "routes/name/" + username);



    print(h.body.toString());
    for (var data in json.decode(h.body)) {
      print(data);
      setState(() {
        chats.add(getContainer(json.decode(data['routedata'])['title'],
            json.decode(data['addresses'].replaceAll('{', '[').replaceAll('}', ']'))[json
                .decode(data['addresses'].replaceAll('{', '[').replaceAll('}', ']'))
                .length-1],
            loadGravatar(json.decode(data['routedata'])['title']),
        data['id'].toString(), false, data));
      });
    }

    setState(() {
      loaded = true;
    });

    await getFriends();
  }

  var userJson;
  BuildContext cont;


  List<Widget> friends = [];

  List<dynamic> friendsData = [];

  Future getFriends() async {
    //Route Data Receive Here
    var username = await getCurUser();

    print("USERNAME"+username);
    var h = await http.get(baseaddr + "users/byname/" + username);

    print(h.body.toString());

    userJson = json.decode(h.body);

    for (String friend in json.decode(userJson['friends'].replaceAll('{', '[').replaceAll('}', ']'))) {
      setState(() {
        friends.add(getContainer(friend, "", loadGravatar(friend), '', true, ""));
        friendnames.add(friend);
      });
    }

    setState(() {
      loaded = true;
    });
  }

  Future addFriend(String friend) async {
    friendnames.add(friend);
    print(friendnames.toString());
    print(baseaddr + "users/update/" + userJson['id'].toString() + "/" + userJson['name'] +
        "/" + userJson['password'] + "/" + userJson['lat'].toString() +
        "/" + userJson['userdata'] + "/" +
        json.encode(friendnames).toString());
    await http.get(
        baseaddr + "users/update/" + userJson['id'].toString() + "/" + userJson['name'] +
            "/" + userJson['password'] + "/" + userJson['lat'].toString() +"/"+userJson['lng'].toString()+
            "/" + userJson['userdata'] + "/" +
            json.encode(friendnames).toString());
  }

  TextEditingController newFriendController;

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: newFriendController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Username of Trusted Friend', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () async{
                await addFriend(newFriendController.text.toString());
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  Widget getContainer(String name, String address, String image, String id, bool user, dynamic chatdata) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0, top: 15),
      child: GestureDetector(
        onTap: (){
          if(!user)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(chatId: id,user: userJson['name'],routedata: chatdata,)),
            );
          else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(user:name,)),
            );
          }
        },
        child: Container(
          width: 450.0,
          height: 70.0,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
                bottomLeft: const Radius.circular(25.0),
                bottomRight: const Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
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
                  width: 50.0,
                  height: 50.0,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 70.0,
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
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: Colors.black,
                      tabs: <Widget>[
                        Tab(
                          text: "Group Chats",
                        ),
                        Tab(
                          text: "Friends",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          ListView.builder(
                            itemCount: chats.length,

                            itemBuilder: ((context, i) {

                              return chats[i];


                            }),

                          ),
                          Container(
                            child: ListView.builder(
                              itemCount: friends.length,
                              itemBuilder: ((context, i) {
                                return friends[i];
                              }),

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
