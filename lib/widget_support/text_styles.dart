// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

TextStyle boldTextFieldStyle() {
  return const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle boldTextFieldStyleCustom(Color c) {
  return TextStyle(
      color: c,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle boldTextFieldStyleCustomC(Color c, double size) {
  return TextStyle(
      color: c,
      fontSize: size,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle HeadlineTextFieldStyle() {
  return const TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle HeadlineTextFieldStyleCustom(double size, Color c) {
  return TextStyle(
      color: c,
      fontSize: size,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle LightTextFieldStyle() {
  return const TextStyle(
      color: Colors.black38,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle LightlessTextFieldStyle() {
  return const TextStyle(
      color: Colors.black38,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins');
}

TextStyle LightlessTextFieldStyleCustom(Color c, double s) {
  return TextStyle(color: c, fontSize: s, fontFamily: 'Poppins');
}

TextStyle SemiboldTextFieldStyle() {
  return const TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins');
}

TextStyle SemiboldTextFieldStyleCustom(Color c, double size) {
  return TextStyle(
      color: c,
      fontSize: size,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins');
}

TextStyle PriceTextFieldStyle() {
  return const TextStyle(
    color: Colors.red,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );
}

TextStyle PriceTextFieldStyleCustom(double size) {
  return TextStyle(
    color: Colors.red,
    fontSize: size,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );
}
