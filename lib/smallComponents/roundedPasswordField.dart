import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/textFieldContainer.dart';

class RoundedPasswordField extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;
  RoundedPasswordField({@required this.onChanged, @required this.textEditingController});

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

// To access properties of stateful widget, we need to write widget. in front of the properties.
class _RoundedPasswordFieldState extends State<RoundedPasswordField> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          hintText: "Password",
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility
                  : Icons.visibility_off,
              color: kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}