import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminChangePassword.dart';
import 'package:instrubuy/admin/adminList.dart';
import 'package:instrubuy/admin/adminLogin.dart';
import 'package:instrubuy/admin/adminRegister.dart';
import 'package:instrubuy/admin/customerStatus.dart';
import 'package:instrubuy/admin/orderStatus.dart';
import 'package:instrubuy/admin/productOptionScreen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdminPanel extends StatefulWidget {
  static const String id = 'adminPanel.dart';

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  SharedPreferences preferences;

  String customerCount, productCount, highestOrderAmount, totalProductOrder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future getCustomerCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/customer_count.php";
    var response = await http.get(url);
    customerCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future getProductCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/product_count.php";
    var response = await http.get(url);
    productCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future getHighestOrderAmount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/highest_order_amount.php";
    var response = await http.get(url);
    highestOrderAmount =
        await json.decode(response.body)[0]['max(total_amount)'];
    return json.decode(response.body)[0]['max(total_amount)'];
  }

  Future getTotalProductOrder() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/totalProductOrder.php";
    var response = await http.get(url);
    totalProductOrder = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "InstruBUY Admin Panel",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kPrimaryColor, kPrimaryLightColor]),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize,
                        horizontal: SizeConfig.defaultSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize * 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
                          child: Text(
                            "Total Customers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.defaultSize, 0, SizeConfig.defaultSize * 2),
                          child: FutureBuilder(
                            future: getCustomerCount(),
                            builder: (context, snapshot) {
                              var value = (snapshot.connectionState ==
                                      ConnectionState.done
                                  ? '${customerCount}'
                                  : 'Loading..');
                              return Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kPrimaryLightColor, kPrimaryColor]),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize,
                        horizontal: SizeConfig.defaultSize),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize * 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
                          child: Text(
                            "Total Products",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.defaultSize, 0, SizeConfig.defaultSize * 2),
                          child: FutureBuilder(
                            future: getProductCount(),
                            builder: (context, snapshot) {
                              var value = (snapshot.connectionState ==
                                      ConnectionState.done
                                  ? '${productCount}'
                                  : 'Loading..');
                              return Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize / 2,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kPrimaryColor, kPrimaryLightColor]),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize,
                        horizontal: SizeConfig.defaultSize),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize * 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Highest Order Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.defaultSize, 0, SizeConfig.defaultSize * 2),
                          child: FutureBuilder(
                            future: getHighestOrderAmount(),
                            builder: (context, snapshot) {
                              var value = (snapshot.connectionState ==
                                      ConnectionState.done
                                  ? 'Rs. ${highestOrderAmount}'
                                  : 'Loading..');
                              return Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [kPrimaryLightColor, kPrimaryColor]),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize,
                        horizontal: SizeConfig.defaultSize),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize * 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
                          child: Text(
                            "Total Product Orders",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.defaultSize, 0, SizeConfig.defaultSize * 2),
                          child: FutureBuilder(
                            future: getTotalProductOrder(),
                            builder: (context, snapshot) {
                              var value = (snapshot.connectionState ==
                                      ConnectionState.done
                                  ? '${totalProductOrder}'
                                  : 'Loading..');
                              return Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1,
            ),
            GestureDetector(
              onTap: () async {
                 await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductOptionScreen()));
                setState(() {
                  build(context);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    Icons.music_note,
                    color: kPrimaryColor,
                  ),
                  title: Text('Musical Instruments'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderStatus()));
                setState(() {
                  build(context);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.shopping_cart,
                    color: kPrimaryColor,
                  ),
                  title: Text('Order Details'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerStatus()));
                setState(() {
                  build(context);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: kPrimaryColor,
                  ),
                  title: Text('Customer Details'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminList()));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    Icons.verified_user,
                    color: kPrimaryColor,
                  ),
                  title: Text('Admin Details'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminRegister()));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.person_add_solid,
                    color: kPrimaryColor,
                  ),
                  title: Text('Register New Admin'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminChangePassword()));
                //Navigator.pushNamed(context, AdminOrderDetails.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                margin: EdgeInsets.all(SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize / 2),
                child: ListTile(
                  leading: Icon(
                    Icons.vpn_key,
                    color: kPrimaryColor,
                  ),
                  title: Text('Change Password'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 2,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.defaultSize * 2.5,
                  horizontal: SizeConfig.defaultSize * 3),
              child: RaisedButton(
                elevation: 0,
                padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.defaultSize * 3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign out",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                color: kPrimaryColor,
                onPressed: () {
                  setState(() {
                    // setting adminLogin to true.
                    preferences.setBool('adminLogin', true);

                    // Removing admin_id credential
                    preferences.remove('admin_id');
                    preferences.remove('adminPassword');
                  });
                  Navigator.pushNamedAndRemoveUntil(context, AdminLogin.id, (route) => false);
                  Fluttertoast.showToast(
                      msg: "Logged out successfully",
                      toastLength: Toast.LENGTH_SHORT);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
