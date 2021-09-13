import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/Drawer/Home.dart';
import 'package:instrubuy/Drawer/Sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen.dart";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  SharedPreferences preferences;
  String yourImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  // For passing customer's profile image.
  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourImage = preferences.getString('image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(fetchedIProfileImage: yourImage,),
        body: Home());
  }
}
