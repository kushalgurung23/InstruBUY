import 'package:flutter/material.dart';
import 'package:instrubuy/admin/adminLoginBody.dart';
import 'package:kf_drawer/kf_drawer.dart';


class AdminLogin extends KFDrawerContent {
  static const String id = "adminLogin.dart";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AdminLogin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AdminLoginBody()),
    );
  }
}

