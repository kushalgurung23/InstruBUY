import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instrubuy/admin/adminLogin.dart';
import 'package:instrubuy/buttons/roundedLoginSignUpButton.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/signUp_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/haveAnAccount.dart';
import 'package:instrubuy/smallComponents/loginBackground.dart';
import 'package:instrubuy/smallComponents/roundedInputField.dart';
import 'package:instrubuy/smallComponents/roundedPasswordField.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp =
    new RegExp(p); //we must provide a valid regular expression syntax.
bool obserText = false;

class LoginBody extends StatefulWidget {
  String customer_id;

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController email_address, password;
  SharedPreferences preferences;
  bool newUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email_address = new TextEditingController();
    password = new TextEditingController();
    setAppUsedStatus();
  }

  void setAppUsedStatus() async {
    preferences = await SharedPreferences.getInstance();

    // Setting appUsed key to true.
    // This will avoid displaying splash screen after displaying it once after installing the app.
    preferences.setBool('appUsed', true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email_address.dispose();
    password.dispose();
    super.dispose();
  }

  void loginUser() async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_logindetails/signin.php";
    var login_data = {
      "email_address": email_address.text.toString(),
      "password": password.text.toString(),
    };

    // The values of above data dictionary is now passed onto url address of our php file i.e. signin.php.
    var res = await http.post(url_address, body: login_data);

    if (jsonDecode(res.body) == "Account does not exists") {
      Fluttertoast.showToast(
          msg: "Account does not exist.", toastLength: Toast.LENGTH_SHORT);
    } else {
      if (jsonDecode(res.body) == "false") {
        Fluttertoast.showToast(
            msg: "Incorrect password.", toastLength: Toast.LENGTH_SHORT);
      } else {
        // Setting values of login status to keep user logged in when s/he has not signed out of the app.
        preferences.setBool('login', false);

        // Setting preferences values of customer details
        preferences.setString('customer_id',
            (jsonDecode(res.body)["result"][0]["customer_id"]).toString());
        preferences.setString('full_name',
            (jsonDecode(res.body)["result"][0]["full_name"]).toString());
        preferences.setString('address',
            (jsonDecode(res.body)["result"][0]["address"]).toString());
        preferences.setString('email_address',
            (jsonDecode(res.body)["result"][0]["email_address"]).toString());
        preferences.setString('password',
            (jsonDecode(res.body)["result"][0]["password"]).toString());
        preferences.setString(
            'image', (jsonDecode(res.body)["result"][0]["image"]).toString());
        preferences.setString(
            'status', (jsonDecode(res.body)["result"][0]["status"]).toString());

        // Setting value to customer_id static variable.
        widget.customer_id =
            (jsonDecode(res.body)["result"][0]["customer_id"]).toString();

        Fluttertoast.showToast(
            msg:
                "Welcome ${(jsonDecode(res.body)["result"][0]["full_name"]).toString()}",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "InstruBUY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: SizeConfig.defaultSize * 2,
              ),
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.3,
            ),
            SvgPicture.asset(
              "assets/icons/loginsvg.svg",
              height: size.height * 0.30,
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.3,
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
              height: SizeConfig.defaultSize * 1.3,
            ),
            RoundedLoginSignUpButton(
              color: kPrimaryColor,
              onPress: () {
                if (email_address.text.toString() == '' &&
                    password.text.toString() == '') {
                  Fluttertoast.showToast(
                      msg: "Please enter your details.",
                      toastLength: Toast.LENGTH_SHORT);
                } else if (email_address.text.toString() == '') {
                  Fluttertoast.showToast(
                      msg: "Please enter your email address.",
                      toastLength: Toast.LENGTH_SHORT);
                } else if (!regExp.hasMatch(email_address.text.toString())) {
                  Fluttertoast.showToast(
                      msg: "Please enter correct email address.",
                      toastLength: Toast.LENGTH_SHORT);
                } else if (password.text.toString() == '') {
                  Fluttertoast.showToast(
                      msg: "Please enter your password.",
                      toastLength: Toast.LENGTH_SHORT);
                } else {
                  loginUser();
                }
              },
              text: "LOGIN",
              textColor: Colors.white,
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.3,
            ),
            HaveAnAccount(
              login: true,
              onPress: () {
                Navigator.pushReplacementNamed(context, SignUpScreen.id);
              },
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: SizeConfig.defaultSize * 3,
                  height: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: kPrimaryColor),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.defaultSize,
                ),
                Text(
                  'Login as',
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.defaultSize,
                ),
                SizedBox(
                  width: SizeConfig.defaultSize * 3,
                  height: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AdminLogin.id);
              },
              child: Text(
                "Admin",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
          ],
        ),
      ),
    );
  }
}
