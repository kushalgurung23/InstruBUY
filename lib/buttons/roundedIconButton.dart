import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

double defaultSize = SizeConfig.defaultSize;

class RoundedIconButton extends StatelessWidget {

  final IconData iconData;
  final GestureTapCallback press;

  RoundedIconButton({@required this.iconData, @required this.press});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: defaultSize),
      child: SizedBox(
        height: getProportionateScreenHeight(50),
        width: getProportionateScreenWidth(40),
        child: FlatButton(
          padding: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60),),
          onPressed: press,
          child: Icon(iconData),
          //color: Colors.white,
        ),
      ),
    );
  }
}
