import 'package:flutter/material.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/smallComponents/loginBody.dart';
import 'package:kf_drawer/kf_drawer.dart';

class LoginScreen extends KFDrawerContent {
  static const String id = "login_screen.dart";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LoginBody()),
    );
  }
}
