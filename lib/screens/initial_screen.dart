import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/screens/splash_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InitialScreen extends StatefulWidget {
  static const id = "initial_screen.dart";

  final ParentModel parentModel;
  InitialScreen({this.parentModel});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  SharedPreferences preferences;
  String customer_id, accountStatus;
  bool isNewUser, isAppUsed, isNewAdmin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    await fetchAllProduct();
    await getCustomerAccountStatus();
  }

  void fetchAllProduct() async {
    await widget.parentModel.fetchDrumProducts();
    await widget.parentModel.fetchPianoProducts();
    await widget.parentModel.fetchUkuleleProducts();
    await widget.parentModel.fetchOtherProducts();
    await widget.parentModel.searchProducts();
  }

  void getCustomerAccountStatus() async {
    preferences = await SharedPreferences.getInstance();
    customer_id = preferences.getString('customer_id');
    // If customer id is not null, we will use id to get account status to determine whether it is active or not.
    if (customer_id != null) {
      var url = 'https://instrubuy.000webhostapp.com/instrubuy_logindetails/accountCheck.php';
      var data = {
        "customer_id": customer_id,
      };
      var response = await http.post(url, body: data);
        accountStatus = ((json.decode(response.body)).length > 0 ? json.decode(response.body)[0]["status"] : '').toString();
    }
    checkAllStatus();
  }

  void checkAllStatus() async {
    preferences = await SharedPreferences.getInstance();

    // Splash screen will only be displayed when isAppUsed value == false.
    // So, when we go to login page, it's value will be true,
    // because splash screen will only be displayed once when it is installed for the first time.
    isAppUsed = (preferences.getBool('appUsed') ?? false);

    // isNewUser will store value of login, If it is null, it will store true.
    // true means new user, false means already logged in user.
    isNewUser = (preferences.getBool('login') ?? true);
    isNewAdmin = (preferences.getBool('adminLogin') ?? true);

    // If app is launched for the first time
    if (isAppUsed == false) {
      Navigator.pushReplacementNamed(context, SplashScreen.id);
    }
    // If app is already launched before
    else {
      // If user is already logged in
      if (isNewUser == false && isNewAdmin == true) {
        // If user's account is active
        if (accountStatus == "Active") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
        // If user's account has been deactivated by admin
        else if (accountStatus == "Inactive") {
          setLoginPreference();
          Navigator.pushReplacementNamed(context, LoginScreen.id);
          Fluttertoast.showToast(
              msg: "Your account has been deactivated.",
              toastLength: Toast.LENGTH_SHORT);
        } else {
          setLoginPreference();
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }
      }
      // If admin is already logged in
      else if (isNewAdmin == false && isNewUser == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminPanel()));
      }
      // If neither user nor admin is logged in (i.e. both isNewUser and isNewAdmin == true)
      else {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      }
    }
  }

  void setLoginPreference() {
    setState(() {
      // setting login to true, because when it is false, app will be navigated to home screen.
      preferences.setBool('login', true);

      // Removing credentials of the logged in user.
      preferences.remove('customer_id');
      preferences.remove('full_name');
      preferences.remove('address');
      preferences.remove('email_address');
      preferences.remove('password');
      preferences.remove('image');
      preferences.remove('status');
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {});
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.defaultSize * 4,
                width: SizeConfig.defaultSize * 4,
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                  backgroundColor: kPrimaryLightColor,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              Text(
                "InstruBUY",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: SizeConfig.defaultSize * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
