import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double containerSize;
  TextFieldContainer({Key key, @required this.child, this.containerSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5,
      ),
      height: containerSize,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}