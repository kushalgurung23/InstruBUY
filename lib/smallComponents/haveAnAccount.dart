import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class HaveAnAccount extends StatelessWidget {

  final bool login;
  final Function onPress;

  HaveAnAccount({@required this.login, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an Account?  " : "Already have an Account?  ",
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}