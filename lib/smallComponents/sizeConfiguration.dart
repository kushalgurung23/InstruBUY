import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  //MediaQueryData property contains width and height of a current window.
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  //Orientation helps to adjust all the widgets while in both portrait and landscape mode.
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    //On iphone 11, the default size is almost 10.
    //if the screen size varies, our default size also vary
    //9.874 = defaultSize of Nexus 6 API 26
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}

// This method will return proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  //812 is the layout height that designers use.
  return ((inputHeight/812.0) * screenHeight);
}

// This method will return proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return ((inputWidth / 375.0) * screenWidth);
}
