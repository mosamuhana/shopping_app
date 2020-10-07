import 'package:flutter/material.dart';

import '../styles.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;

  CustomText({
    @required this.text,
    this.size,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size ?? 16,
        color: color ?? Styles.colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
