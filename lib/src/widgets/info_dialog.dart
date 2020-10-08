import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String message;

  const InfoDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 200,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message ?? '', textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  static Future<void> show(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (_) => InfoDialog(message: message),
    );
  }
}
