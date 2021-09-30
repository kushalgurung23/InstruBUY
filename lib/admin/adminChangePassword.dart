import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/smallComponents/ProfileInputTextField.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminChangePassword extends StatefulWidget {
  @override
  _AdminChangePasswordState createState() => _AdminChangePasswordState();
}

class _AdminChangePasswordState extends State<AdminChangePassword> {
  SharedPreferences preferences;
  String admin_id, adminPassword;
  TextEditingController oldPasswordController,
      newPasswordController,
      confirmNewPasswordController;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      admin_id = preferences.getString('admin_id');
      adminPassword = preferences.getString('adminPassword');
    });
  }

  void changePassword() async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/adminChangePassword.php";
    var password_data = {
      "admin_id": admin_id,
      "old_password": adminPassword,
      "confirm_old_password": oldPasswordController.text,
      "new_password": newPasswordController.text,
      "confirm_new_password": confirmNewPasswordController.text,
    };

    // The values of above data dictionary is now passed onto url address of our php file i.e. changePassword.php.
    var response = await http.post(url_address, body: password_data);

    if (jsonDecode(response.body) == "old passwords not matched") {
      Fluttertoast.showToast(
          msg: "Your old password did not match.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(response.body) == "new passwords not matched") {
      Fluttertoast.showToast(
          msg: "Your new passwords do not match with each other.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(response.body) == "false") {
      Fluttertoast.showToast(
          msg: "Please try again later.", toastLength: Toast.LENGTH_SHORT);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Password changed successfully.",
          toastLength: Toast.LENGTH_SHORT);
      preferences.setString(
          'adminPassword',
          (jsonDecode(response.body)["result"][0]["encrypted_password"])
              .toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
    oldPasswordController = new TextEditingController();
    newPasswordController = new TextEditingController();
    confirmNewPasswordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Same color as the background of the page.
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                ProfileInputTextField(
                  labelText: "Old Password",
                  placeHolder: "Enter old password",
                  isPasswordTextField: true,
                  textEditingController: oldPasswordController,
                  textEnable: true,

                ),
                ProfileInputTextField(
                  labelText: "New Password",
                  placeHolder: "Enter new password",
                  isPasswordTextField: true,
                  textEditingController: newPasswordController,
                  textEnable: true,
                ),
                ProfileInputTextField(
                  labelText: "Confirm New Password",
                  placeHolder: "Confirm new password",
                  isPasswordTextField: true,
                  textEditingController: confirmNewPasswordController,
                  textEnable: true,
                ),
                ExtendedFlatButton(
                    buttonName: "Confirm Password",
                    onPress: () {
                      setState(() {
                        if (oldPasswordController.text == "" &&
                            newPasswordController.text == "" &&
                            confirmNewPasswordController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Enter all details to change your password.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (oldPasswordController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Enter your old password.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (newPasswordController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Enter your new password.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (confirmNewPasswordController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Re-enter your new password.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (newPasswordController.text.length < 6 ||
                            confirmNewPasswordController.text.length < 6) {
                          Fluttertoast.showToast(
                              msg:
                              "Your new password must contain at least 6 letters.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else {
                          changePassword();
                        }
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
