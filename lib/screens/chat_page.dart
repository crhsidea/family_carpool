import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/widgets/receivedmessagewidget.dart';
import 'package:family_carpool/widgets/sentmessagewidget.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

bool wasCorrect;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String user;

  const ChatScreen({Key key, this.chatId, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showBottom = false;
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

  String baseaddr = "http://192.168.0.12:8080/";

  Stream<List<dynamic>> streamChat() async* {
    while (true) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //TODO add in profile image if it makes sense
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.chatId,
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
            )
          ],
        ),
      ),
      body: Stack(
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
      ),
    );
  }
}
