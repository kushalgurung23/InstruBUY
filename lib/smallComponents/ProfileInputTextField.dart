import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class ProfileInputTextField extends StatefulWidget {
  final String labelText;
  final String placeHolder;
  final bool isPasswordTextField, textEnable;
  final TextEditingController textEditingController;

  ProfileInputTextField({this.labelText, this.placeHolder, this.isPasswordTextField, this.textEditingController, this.textEnable});

  @override
  _ProfileInputTextFieldState createState() => _ProfileInputTextFieldState();
}

class _ProfileInputTextFieldState extends State<ProfileInputTextField> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextField(
        enabled: widget.textEnable,
        controller: widget.textEditingController,
        obscureText: widget.isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: widget.isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            )
                : null,
            fillColor: kPrimaryColor,
            focusColor: kPrimaryColor,
            hoverColor: kPrimaryColor,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.placeHolder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            )),
      ),
    );
  }
}
