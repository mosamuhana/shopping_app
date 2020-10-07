import 'package:flutter/material.dart';

class Nav {
  static Future<T> gotoPage<T extends Object>(BuildContext context, Widget page) async {
    return await Navigator.push<T>(context, MaterialPageRoute(builder: (context) => page));
  }

  static Future<T> replacePage<T extends Object, TO extends Object>(BuildContext context, Widget page, {TO result}) async {
    return await Navigator.pushReplacement<T, TO>(context, MaterialPageRoute(builder: (context) => page), result: result);
  }
}
