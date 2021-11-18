import 'package:flutter/material.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/smallComponents/loginBody.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends KFDrawerContent {
  static const String id = "login_screen.dart";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  SharedPreferences preferences;
  String yourCustomer_id,
      yourFullName,
      yourAddress,
      yourEmailAddress,
      yourPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
      yourFullName = preferences.getString('full_name');
      yourAddress = preferences.getString('address');
      yourEmailAddress = preferences.getString('email_address');
      yourPassword = preferences.getString('password');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LoginBody()),
    );
  }
}
