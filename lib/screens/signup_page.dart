
import 'dart:convert';
import 'dart:io';

import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/utils/requestconvert.dart';
import 'package:family_carpool/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/widgets/login/bezier_container.dart';
import 'package:path_provider/path_provider.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();


  @override
  void initState(){

    super.initState();
    getIP();
  }


  String baseaddr;
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

  setUser(BuildContext context) async{
    print("changing username");
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/user.txt');
    await file.writeAsString(name.text.toString());

    var tmp = {
      'description':descript.text.toString(),
      'years':int.parse(years.text.toString()),
      'email':email.text.toString(),
      'age':int.parse(age.text.toString())
    };

    try {
      print(baseaddr+"users/add/1/"+name.text.toString()+"/"+password.text.toString()+"/"+0.toString()+"/"+0.toString()+"/"+json.encode(tmp).toString()+"/"+json.encode({}).toString());
      var h = await http.get(baseaddr+"users/add/1/"+name.text.toString()+"/"+password.text.toString()+"/"+0.toString()+"/"+0.toString()+"/"+RequestConvert.convertTo(json.encode(tmp).toString()+"/"+json.encode({}).toString()+"/"));
      print(h.body.toString());
    }
    catch (e) {
      print('NOoOOOOoOOOOOoOOO');
      print(e.toString());
    }



    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomBar()),
    );
  }



  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color.fromRGBO(108, 159, 206, 1), Colors.blueAccent])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onPressed: () {
        setUser(context);
      },
    );
  }



  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Tide',
          style: TextStyle(color: Color.fromRGBO(48, 79, 254, 1), fontSize: 30),
          children: [
            TextSpan(
              text: 'Pool',
              style: TextStyle(color: Color.fromRGBO(128, 214, 255, 1), fontSize: 30),
            ),
          ]),
    );
  }


  TextEditingController descript = new TextEditingController();
  TextEditingController years = new TextEditingController();
  TextEditingController age = new TextEditingController();
  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name", name),
        _entryField("Email id", email),
        _entryField("Password", password, isPassword: true),
        _entryField("Description", descript),
        _entryField("Years Driving", years),
        _entryField("Age", age,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(context),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}