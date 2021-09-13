import 'package:flutter/material.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';

class RoundedLoginSignUpButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color, textColor;

  RoundedLoginSignUpButton(
      {@required this.text,
      @required this.onPress,
      @required this.color,
      @required this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29.0),
        child: FlatButton(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 40.0,
          ),
          color: color,
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
