import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/screens/change_password.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/screens/orderScreen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/Drawer/Profile.dart';
import 'package:instrubuy/smallComponents/showAlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class SideBar extends StatefulWidget {
  // Profile image is fetched from home screen, because when sidebar's widgets are loaded, values of image fetched from sharedPreferences way will still be null.
  // Hence, cached network image will fetch null image when passing value through shared preference, which shows error.
  // Hence, image's value is fetched from home screen.
//  final String fetchedIProfileImage;
//  SideBar({this.fetchedIProfileImage});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  static const String defaultImage = "image_picker3418853472357847431.jpg";

  SharedPreferences preferences;
  String yourCustomer_id,
      yourFullName,
      yourAddress,
      yourEmailAddress,
      yourPassword,
      yourImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
      yourFullName = preferences.getString('full_name');
      yourAddress = preferences.getString('address');
      yourEmailAddress = preferences.getString('email_address');
      yourPassword = preferences.getString('password');
      yourImage = preferences.getString('image');

      print("Here are the details: ");
      print(yourCustomer_id);
      print(yourFullName);
      print(yourAddress);
      print(yourEmailAddress);
      print(yourPassword);
      print(yourImage);
      print(preferences.getString('status'));
    });
  }

  void deleteAccount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_account/deleteAccount.php";
    var body = {"customer_id": yourCustomer_id};
    http.Response response = await http.post(url, body: body);
    if (jsonDecode(response.body) == "true") {
      await removePreferenceData();
      Fluttertoast.showToast(msg: "Account has been deleted.");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } else {
      Fluttertoast.showToast(msg: "Please try again later.");
    }
  }

  void removePreferenceData() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              '$yourFullName',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            accountEmail: Text(
              '$yourEmailAddress',
              style: TextStyle(
                color: Colors.grey,
                //fontSize: 15,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://instrubuy.000webhostapp.com/instrubuy_images/${yourImage ?? defaultImage}",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.blue]),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://wallpaperset.com/w/full/4/5/0/9934.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "My Profile",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Closing the side bar first then pushing to Profile.
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            fullName: yourFullName,
                            address: yourAddress,
                            emailAddress: yourEmailAddress,
                            image: yourImage,
                          )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_basket,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "My Order",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, CustomerOrderDetails.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.vpn_key,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "Change Password",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePassword()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShowAlertDialog(
                      contentText:
                          "Are you sure you want to delete your account permanently?",
                      onPress: () => deleteAccount());
                },
                barrierDismissible: false,
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.deepPurpleAccent,
            ),
            title: Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
            onTap: () {
              setState(() {
                removePreferenceData();

                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.id, (route) => false);
                //Navigator.pushNamed(context, LoginScreen.id);
                Fluttertoast.showToast(
                    msg: "Logged out successfully",
                    toastLength: Toast.LENGTH_SHORT);
              });
            },
          ),
        ],
      ),
    );
  }
}
