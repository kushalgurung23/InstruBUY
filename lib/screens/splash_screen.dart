import 'package:flutter/material.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/screens/signUp_screen.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/components/splashScreenBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen.dart';

//  final ParentModel parentModel;
//  SplashScreen({this.parentModel});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences preferences, appData;
  bool isNewUser, isAppUsed;

  @override
  Widget build(BuildContext context) {
    // Calling init method of SizeConfig on our starting screen.
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SplashScreenBody(),
    );
  }
}
