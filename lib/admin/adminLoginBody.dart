import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/buttons/roundedLoginSignUpButton.dart';
import 'package:instrubuy/models/AdminLoginModel.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
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

class AdminLoginBody extends StatefulWidget {
  String admin_id;

  @override
  _AdminLoginBodyState createState() => _AdminLoginBodyState();
}

class _AdminLoginBodyState extends State<AdminLoginBody> {
  TextEditingController email_address, password;
  SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email_address = new TextEditingController();
    password = new TextEditingController();
    initial();
  }

  void initial() async {
    preferences = await SharedPreferences.getInstance();
  }

  void loginAdmin() async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/adminLogin.php";
    var login_data = {
      "email_address": email_address.text.toString(),
      "password": password.text.toString(),
    };

    // The values of above data dictionary is now passed onto url address of our php file i.e. signin.php.
    var res = await http.post(url_address, body: login_data);

    if (jsonDecode(res.body) == "Account does not exists") {
      Fluttertoast.showToast(
          msg: "Account does not exists.", toastLength: Toast.LENGTH_SHORT);
    } else {
      if (jsonDecode(res.body) == "false") {
        Fluttertoast.showToast(
            msg: "Incorrect password.", toastLength: Toast.LENGTH_SHORT);
      } else {
        print(jsonDecode(res.body));
        preferences.setBool('adminLogin', false);
        preferences.setString('admin_id',
            (jsonDecode(res.body)["result"][0]["admin_id"]).toString());
        preferences.setString('adminPassword', (jsonDecode(res.body)["result"][0]["password"]).toString());

        print("Admin details");
        print((jsonDecode(res.body)["result"][0]["admin_id"]).toString());
        print((jsonDecode(res.body)["result"][0]["password"]).toString());
        Fluttertoast.showToast(
            msg:
                "Welcome ${(jsonDecode(res.body)["result"][0]["position"]).toString()}",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminPanel()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Admin Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: defaultSize * 2,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SvgPicture.asset(
              "assets/icons/adminLogin.svg",
              height: size.height * 0.30,
            ),
            SizedBox(
              height: size.height * 0.03,
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
                  loginAdmin();
                }
              },
              text: "LOGIN",
              textColor: Colors.white,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: defaultSize * 3,
                  height: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: kPrimaryColor),
                  ),
                ),
                SizedBox(
                  width: defaultSize,
                ),
                Text(
                  'Login as',
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: defaultSize,
                ),
                SizedBox(
                  width: defaultSize * 3,
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
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              child: Text(
                "Customer",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
