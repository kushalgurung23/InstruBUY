import 'package:flutter/material.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';

class DetailScreenBottomContainer extends StatelessWidget {
  final Widget child;

  DetailScreenBottomContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
         margin: EdgeInsets.only(top: defaultSize),
          padding: EdgeInsets.only(top: defaultSize * 1.5),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurpleAccent, Colors.blue]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        child: child,
      ),
    );
  }
}