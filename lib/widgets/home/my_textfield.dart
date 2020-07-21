import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final TextEditingController controller;
  final Color color;
  MyTextField({this.label, this.maxLines = 1, this.minLines = 1, this.icon, this.controller, this.color});

  @override
  Widget build(BuildContext context) {
    return TextField(

      style: TextStyle(color: color),
      minLines: minLines,
      maxLines: maxLines,
      controller: this.controller!=null?this.controller:null,
      decoration: InputDecoration(
          suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: TextStyle(color: color),

          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: color)),
          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: color)),
          border:
          UnderlineInputBorder(borderSide: BorderSide(color: color))),
    );
  }
}