import 'package:flutter/material.dart';
import 'package:instrubuy/components/productData.dart';
import 'package:instrubuy/components/homeAppBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // It enables scrolling
      child: Column(
        children: [
          HomeAppBar(),
          Flexible(
            child: SingleChildScrollView(
              // All product data in our home screen
              child: ProductData(),
            ),
          )
        ],
      ),
    );
  }
}
