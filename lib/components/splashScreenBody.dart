import 'package:flutter/material.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/splashContents.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';

class SplashScreenBody extends StatefulWidget {
  @override
  _SplashScreenBodyState createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  int currentSplashPage = 0;

  List<Map<String, String>> splashData = [
    {
      "headingText": "Welcome to InstruBUY, the home of Musical Instruments.",
      "imageName": "assets/images/splash_1.png",
    },
    {
      "headingText":
          "Buy musical instruments of your choice in decent price.",
      "imageName": "assets/images/splash_2.png",
    },
    {
      "headingText": "You are just few minutes away from getting your favourite musical instruments.",
      "imageName": "assets/images/splash_3.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              // flex creates a widgets that expands child of a row, column, or flex
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentSplashPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContents(
                  headingText: splashData[index]["headingText"],
                  imageName: splashData[index]["imageName"],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.defaultSize * 2.0,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => splashActive(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    ExtendedFlatButton(
                      buttonName: "Get Started",
                      onPress: () {
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AnimatedContainer splashActive({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      height: 6.0,
      width: currentSplashPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentSplashPage == index ? kPrimaryColor : kSplashInactiveColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
