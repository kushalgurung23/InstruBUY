import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/buttons/roundedLoginSignUpButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/roundedInputField.dart';
import 'package:instrubuy/smallComponents/roundedPasswordField.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;

double defaultSize = SizeConfig.defaultSize;
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp =
new RegExp(p);

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {

  TextEditingController emailAddress, password, position;

  void registerNewAdmin() async {
    try {
      var url = "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/adminRegister.php";
      var adminData = {
        "email_address": emailAddress.text.toString(),
        "password": password.text.toString(),
        "position": position.text.toString()
      };

      var response = await http.post(url, body: adminData);

      if(jsonDecode(response.body) == "Account already exists") {
        Fluttertoast.showToast(msg: "Admin account already exists.", toastLength: Toast.LENGTH_SHORT);
      }
      else if (jsonDecode(response.body) == "false") {
        Fluttertoast.showToast(msg: "Please try again later.", toastLength: Toast.LENGTH_SHORT);
      }
      else if (jsonDecode(response.body) == "true") {
        Fluttertoast.showToast(msg: "Account registered successfully.", toastLength: Toast.LENGTH_SHORT);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel()));
        Navigator.pop(context);
      }
    }
    catch(Exception) {
      Fluttertoast.showToast(msg: "${Exception}", toastLength: Toast.LENGTH_LONG);
      print(Exception);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAddress = new TextEditingController();
    password = new TextEditingController();
    position = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Register New Admin",
        onPress: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              RoundedInputField(
                hintText: "Email Address",
                icon: Icons.mail,
                onChanged: (value) {},
                textEditingController: emailAddress,
              ),
              RoundedPasswordField(
                onChanged: (value) {},
                textEditingController: password,
              ),
              RoundedInputField(
                hintText: "Position",
                icon: Icons.description,
                onChanged: (value) {},
                textEditingController: position,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              RoundedLoginSignUpButton(
                text: "REGISTER",
                color: kPrimaryColor,
                textColor: Colors.white,
                onPress: () {
                  if(position.text.toString() == '' && emailAddress.text.toString() == '' && password.text.toString() == '') {
                    Fluttertoast.showToast(msg: "Please provide all details to register.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else if(emailAddress.text.toString() == '') {
                    Fluttertoast.showToast(msg: "Please provide email address.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else if (!regExp.hasMatch(emailAddress.text.toString())) {
                    Fluttertoast.showToast(msg: "Please enter correct email address.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else if(password.text.toString() == '') {
                    Fluttertoast.showToast(msg: "Please provide password.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else if(password.text.toString().length < 6) {
                    Fluttertoast.showToast(msg: "Your password is too short.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else if(position.text.toString() == '') {
                    Fluttertoast.showToast(msg: "Please provide admin's position.", toastLength: Toast.LENGTH_SHORT);
                  }
                  else {
                    registerNewAdmin();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
