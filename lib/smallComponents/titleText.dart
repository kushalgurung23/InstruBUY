import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class TitleText extends StatelessWidget {
  final String title;
  final Color color;

  TitleText({this.title, this.color});

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Text(
      title,
      style: TextStyle(
        fontSize: defaultSize * 1.6,  //16
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}