import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class ExtendedFlatButton extends StatelessWidget {
  final String buttonName;
  final Function onPress;

  ExtendedFlatButton({@required this.buttonName, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.defaultSize * 6,
      width: double.infinity,
      child: FlatButton(
        color: kPrimaryColor,
        onPressed: onPress,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2)),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: SizeConfig.defaultSize * 2,
            color: kSecondaryTitleColor,
          ),
        ),
      ),
    );
  }
}
