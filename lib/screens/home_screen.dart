import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/Drawer/Home.dart';
import 'package:instrubuy/Drawer/Sidebar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen.dart";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        drawer: SideBar(),
        body: Home());
  }
}
