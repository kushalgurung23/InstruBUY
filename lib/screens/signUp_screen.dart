import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/signUpBody.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "signUp_screen.dart";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: SingleChildScrollView(child: SignUpBody())));
  }
}
