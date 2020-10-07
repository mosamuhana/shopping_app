import 'package:flutter/material.dart';

class Styles {
  static _Colors _colors;
  static _Colors get colors => _colors ??= _Colors();

  static ThemeData get theme {
    return ThemeData(
      primarySwatch: colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

class _Colors {
  final primary = Colors.deepOrange;
  final red = Colors.red;
  final yellow = Colors.yellow;
  final white = Colors.white;
  final black = Colors.black;
  final grey = Colors.grey;
  final green = Colors.green;
  final blue = Colors.blue;
}
