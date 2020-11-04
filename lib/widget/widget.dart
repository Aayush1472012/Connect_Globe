import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text("Connect Globe",
      style: TextStyle(
      fontSize: 25.0,
          color: Colors.white,
    ),),
    elevation: 5.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.lightBlue[50]),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue[50])),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.lightBlue[50], fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
