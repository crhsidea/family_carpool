import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/screens/profile_page.dart';
import 'package:family_carpool/widgets/receivedmessagewidget.dart';
import 'package:family_carpool/widgets/sentmessagewidget.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

bool wasCorrect;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String user;

  final dynamic routedata;

  const ChatScreen({Key key, this.chatId, this.user, this.routedata}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textInput = new TextEditingController();

  StreamController<double> chatcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    streamChat().listen((value){
      print(value);
    });
  }

  bool isuserslist = true;

  String baseaddr = "" ;
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


  Stream<List<dynamic>> streamChat() async* {

    while (true) {
      if(baseaddr==""){
        await getIP();
      }
      await Future.delayed(Duration(milliseconds: 1000));
      var chat = await http.get(baseaddr + "messages/name/" + widget.chatId);
      print("getting messages");

      List<Widget> temp = [];
      for (var c in json.decode(chat.body)){
        if(c['sender']==widget.user){
          temp.add(SentMessageWidget(message: c['text'],));
        }
        else{
          temp.add(ReceivedMessagesWidget(
            message: c['text'],
            sender: c['sender'],
          ));
        }
      }
      setState(() {
        messages = temp;
      });
      yield json.decode(chat.body);
    }
  }

  Future sendMessage(String message) async {
    print("SENDING MESSAGE");
    textInput.clear();
    //TODO just make a request to the endpoint
    await http.get(baseaddr+"messages/add/1/"+message+"/"+widget.user+"/"+widget.chatId+"/"+DateTime.now().millisecondsSinceEpoch.toString()+"/{}");
  }

  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    print(widget.user);
    if (textInput.text.length > 0) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  List<Widget> messages = [];

  List<Widget> users = [];

  Widget getContainer(String name, String address, String image, String id, bool user) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7.0, top: 15),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(user: name,)),
          );
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
                color: Colors.pink.withOpacity(1),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //TODO add in profile image if it makes sense
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  json.decode(widget.routedata['routedata'])['title'],
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  "Online",
                  style: Theme.of(context).textTheme.subtitle.apply(
                        color: Colors.orangeAccent,
                      ),
                )
              ],
            ),
            IconButton(
              icon: Icon(Icons.drive_eta),
              onPressed:(){
                setState(() {
                  isuserslist = !isuserslist;
                });
              },
            )
          ],
        ),
      ),
      body: isuserslist?Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                        itemBuilder: ((context, index) {
                          return messages[index];
                        })
                    )
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: textInput,
                                  decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      border: InputBorder.none),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    sendMessage(textInput.text);
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ):ListView.builder(
        itemCount: json.decode(widget.routedata['users']).length,
          itemBuilder: ((context, ind){
            return GestureDetector(
              onTap: (){
                changeDriver(ind);
              },
                child: getContainer(json.decode(widget.routedata['users'])[ind], "", loadGravatar(json.decode(widget.routedata['users'])[ind]),"", true));
          })),
    );
  }

  List<dynamic> switchVals(List<dynamic> input, int ind){
    List<dynamic> temp = input;
    temp.insert(0, temp[ind]);
    temp.removeAt(ind+1);
    return temp;
  }

  Future changeDriver(int ind)async{
    List<String> users = switchVals(json.decode(widget.routedata['users']), ind);
    List<String> addresses = switchVals(json.decode(widget.routedata['addresses']), ind);
    await http.get(baseaddr+"routes/updatedriver/"+widget.routedata['id']+"/"+json.encode(users)+"/"+json.encode(addresses));
  }

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
