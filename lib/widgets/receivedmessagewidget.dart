import 'package:family_carpool/themes/colors.dart';
import 'package:flutter/material.dart';

class ReceivedMessagesWidget extends StatelessWidget {
  final String message;
  final String sender;
  const ReceivedMessagesWidget({
    Key key,
    @required this.message, this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                sender,
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color:LightColors.kDarkYellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.body1.apply(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}