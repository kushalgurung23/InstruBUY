import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/buttons/roundedLoginSignUpButton.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/haveAnAccount.dart';
import 'package:instrubuy/smallComponents/roundedInputField.dart';
import 'package:instrubuy/smallComponents/roundedPasswordField.dart';
import 'package:instrubuy/smallComponents/signUpBackground.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp =
new RegExp(p); //we must provide a valid regular expression syntax.

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {

  TextEditingController full_name, address, email_address, password;

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    full_name = new TextEditingController();
    address = new TextEditingController();
    email_address = new TextEditingController();
    password = new TextEditingController();
  }

  void registerNewUser() async
  {
    try {
      var url_address = "https://instrubuy.000webhostapp.com/instrubuy_logindetails/signup.php";
      var data = {
        "full_name": full_name.text.toString(),
        "address": address.text.toString(),
        "email_address": email_address.text.toString(),
        "password": password.text.toString(),
      };

      // The values of above data dictionary is now passed onto url address of our php file i.e. signup.php.
      var res = await http.post(url_address, body: data);

      // If account already exists
      if (jsonDecode(res.body) == "Account already exists")
      {
        Fluttertoast.showToast(msg: "An account is already registered with this email address.", toastLength: Toast.LENGTH_SHORT);
      }
      else
      {
        if (jsonDecode(res.body) == "true")
        {
          Fluttertoast.showToast(msg: "Account has been created successfully.", toastLength: Toast.LENGTH_SHORT);
          Navigator.pushNamed(context, LoginScreen.id);
        }
        else
        {
          Fluttertoast.showToast(msg: "Error, please try again later.", toastLength: Toast.LENGTH_SHORT);
        }
      }
    }
    catch(SocketException) {
      Fluttertoast.showToast(msg: "Please check your network connection.", toastLength: Toast.LENGTH_SHORT);
  }

  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SignUpBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: defaultSize),
            child: Text(
              "InstruBUY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: defaultSize * 2,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SvgPicture.asset(
            "assets/icons/registrationsvg.svg",
            height: size.height * 0.25,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          RoundedInputField(
            hintText: "Full Name",
            icon: Icons.person,
            onChanged: (value) {},
            textEditingController: full_name,
          ),
          RoundedInputField(
            hintText: "Address",
            icon: Icons.location_on,
            onChanged: (value) {},
            textEditingController: address,
          ),
          RoundedInputField(
            hintText: "Email Address",
            icon: Icons.mail,
            onChanged: (value) {},
            textEditingController: email_address,
          ),
          RoundedPasswordField(
            onChanged: (value) {},
            textEditingController: password,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          RoundedLoginSignUpButton(
            text: "SIGN UP",
            color: kPrimaryColor,
            textColor: Colors.white,
            onPress: () {
              if(full_name.text.toString() == '' && address.text.toString() == '' && email_address.text.toString() == '' && password.text.toString() == '') {
                Fluttertoast.showToast(msg: "Please enter all details to register.", toastLength: Toast.LENGTH_SHORT);
              }
              else if(full_name.text.toString() == '') {
                Fluttertoast.showToast(msg: "Please enter your full name.", toastLength: Toast.LENGTH_SHORT);
              }
              else if(address.text.toString() == '') {
                Fluttertoast.showToast(msg: "Please enter your home address.", toastLength: Toast.LENGTH_SHORT);
              }
              else if(email_address.text.toString() == '') {
                Fluttertoast.showToast(msg: "Please enter your email address.", toastLength: Toast.LENGTH_SHORT);
              }
              else if (!regExp.hasMatch(email_address.text.toString())) {
                Fluttertoast.showToast(msg: "Please enter correct email address.", toastLength: Toast.LENGTH_SHORT);
              }
              else if(password.text.toString() == '') {
                Fluttertoast.showToast(msg: "Please enter your password.", toastLength: Toast.LENGTH_SHORT);
              }
              else if(password.text.toString().length < 6) {
                Fluttertoast.showToast(msg: "Your password is too short.", toastLength: Toast.LENGTH_SHORT);
              }
              else {
                registerNewUser();
              }
            },
          ),
          SizedBox(
            height: defaultSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultSize * 1),
            child: HaveAnAccount(
              login: false,
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ),
          SizedBox(
            height: defaultSize,
          ),
        ],
      ),
    );
  }
}
