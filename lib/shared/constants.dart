import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purple, width: 2.0),
    borderRadius: BorderRadius.circular(10.0),
  ),
);

// class Constants{
//   static String myName = '';
// }