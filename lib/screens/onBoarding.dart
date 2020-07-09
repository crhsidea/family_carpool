import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:avatar_glow/avatar_glow.dart';
//import the page that comes after onboarding... likely login


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreen createState() => _IntroScreen();
}

class _IntroScreen extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final onboardPages = [
      Container(color: Colors.pinkAccent, child: FirstScreen()),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[400],
                  Colors.blue[600]
                ])),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: skipButton(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          height: 340,
                          width: 10,
                          child: Image(
                              image: AssetImage('assets/images/Community.PNG',),
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Text('Face off against our Ai',
                                    style: TextStyle(
                                        fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                                Text(
                                    'and score more points that your opponent!',
                                    style: TextStyle(
                                        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                              ],
                            )),
                      ),
                    ]))),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple[300],
                  Colors.deepPurple[500]
                ])),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: skipButton(context),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 400,
                          width: 200,
                          child: Image(
                            image: AssetImage('assets/images/Car.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                    'Get points by determining',
                                    style: TextStyle(
                                        fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                                Text(
                                    'if your opponent is real or not',
                                    style: TextStyle(
                                        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]))),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange[300],
                  Colors.orange[500]
                ])),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: skipButton(context),
                      ),
                      SizedBox(height: 100,),
                      Image.asset('assets/images/Calendar.PNG',
                        height: 200,
                        width: 200,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(children: <Widget>[
                              SizedBox(height: 180,),
                              Text(
                                  'Conquer the leaderboards',
                                  style: TextStyle(
                                      fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              Text(
                                  'and become the champion!',
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ]))),
      ),
      Container(
        child: FinalScreen(),
      )
    ];
    return Scaffold(
        body: LiquidSwipe(
          pages: onboardPages,
          fullTransitionValue: 400,
          enableLoop: true,
          enableSlideIcon: false,
          //positionSlideIcon: 0.8,
          waveType: WaveType.liquidReveal,
        ));
  }

  Widget skipButton(BuildContext context) {
    return FlatButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinalScreen()),
        );
      },
      child: Text(
        'Skip',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class FinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orangeAccent,
        child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AvatarGlow(
                    endRadius: 150,
                    duration: Duration(seconds: 2),
                    glowColor: Colors.white24,
                    repeat: true,
                    repeatPauseDuration: Duration(seconds: 1),
                    startDelay: Duration(seconds: 1),
                    child: Material(
                        elevation: 25.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: FlutterLogo(
                            size: 100.0,
                          ),
                          radius: 100.0,
                        )),
                  ),
                  //SizedBox(height: 100,),
                  Center(
                    child: Text(
                        'Start your chatter today',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_forward_ios),
                    iconSize: 40,
                    //onPressed:(){
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => (StudentProfilePage(3,4,5,"Samuel"))),
                      //);
                    //},
                  )
                ])));
  }
}

class FirstScreen extends StatefulWidget {
  final String title;

  FirstScreen({Key key, this.title}) : super(key: key);

  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  // Whether the green box should be visible
  bool _buttonVisible = true;
  bool _textVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green[300],
                  Colors.green[700]
                ])),
        child: Container(
          width: 400,
          child: Column(
            children: [
              SizedBox(height: 200,),
              Image.asset('assets/images/kidnap.PNG',
                height: 300,
                width: 300,
              ),
              SizedBox(height: 100),
              Text(
                  'Enter the text you want prasann',
                  style: TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
