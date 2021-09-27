import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  final String contentText;
  final Function onPress;

  ShowAlertDialog({@required this.contentText, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(contentText),
      actions: [
        TextButton(
            child: Text(
              "No",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () => {Navigator.pop(context)}),
        TextButton(
            child: Text(
              "Yes",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: onPress),
      ],
    );
  }
}
