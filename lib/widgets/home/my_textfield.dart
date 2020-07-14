import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final TextEditingController controller;
  MyTextField({this.label, this.maxLines = 1, this.minLines = 1, this.icon, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(

      style: TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      controller: this.controller!=null?this.controller:null,
      decoration: InputDecoration(
          suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black45),

          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}