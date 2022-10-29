import 'package:flutter/material.dart';

InputDecoration smallInputDecoration({String label = '', double fontSize = 7.0}) {
  return InputDecoration(
    floatingLabelStyle: const TextStyle(color: Color(0xff0E9447)),
    labelText: label,
    labelStyle: TextStyle(fontSize: fontSize),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    floatingLabelAlignment: FloatingLabelAlignment.center,
    contentPadding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(color: Color(0xff0E9447)),
    ),
  );
}
