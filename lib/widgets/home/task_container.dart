import 'package:flutter/material.dart';


class TaskContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color boxColor;
  final double size;

  TaskContainer({
    this.title, this.subtitle, this.boxColor, this.size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: MediaQuery.of(context).size.width-110,
      padding: EdgeInsets.only(left:20.0, right: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(30.0)),
    );
  }
}