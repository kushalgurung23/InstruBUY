import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/textFieldContainer.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final keyBoardType;
  final TextEditingController textEditingController;
  // ValueSetter for callbacks the reports that a value has been changed.
  final ValueChanged<String> onChanged;
  final List inputFormatters;

  RoundedInputField({@required this.hintText, this.icon, @required this.onChanged, @required this.textEditingController, this.keyBoardType, this.inputFormatters});

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyBoardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}