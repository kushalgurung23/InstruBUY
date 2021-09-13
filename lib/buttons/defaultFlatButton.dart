import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class DefaultFlatButton extends StatelessWidget {

  final String buttonName;
  final Function onPress;
  final Color buttonColor;

  DefaultFlatButton({@required this.buttonName, @required this.onPress, @required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: SizeConfig.defaultSize * 5.5,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: buttonColor,
          onPressed: onPress,
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: SizeConfig.defaultSize *2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
