import 'package:flutter/material.dart';

class TestContainer extends StatelessWidget {
  final Color color;

  TestContainer(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}