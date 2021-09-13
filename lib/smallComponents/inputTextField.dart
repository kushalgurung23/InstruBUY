import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrubuy/smallComponents/textFieldContainer.dart';

class InputTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  // ValueSetter for callbacks the reports that a value has been changed.
  final ValueChanged<String> onChanged;
  final double containerSize;
  final TextInputType textInputType;
  final List textInputFormatter;

  InputTextField({@required this.hintText, @required this.onChanged, @required this.textEditingController, this.containerSize, this.textInputType, this.textInputFormatter});

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      containerSize: widget.containerSize,
      child: TextFormField(
        keyboardType: widget.textInputType,
        inputFormatters: widget.textInputFormatter,
        maxLines: null,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}