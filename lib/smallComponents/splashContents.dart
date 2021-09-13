import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class SplashContents extends StatelessWidget {
  final String headingText, imageName;

  SplashContents({@required this.headingText, @required this.imageName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(), // it will have flex: 1 as default
        Text(
          "InstruBUY",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
          child: Text(
            headingText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTitleColor,
            ),
          ),
        ),
        Spacer(flex: 2),
        Image.asset(
          imageName,
          height: SizeConfig.defaultSize * 24.5,
          // or use height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        )
      ],
    );
  }
}