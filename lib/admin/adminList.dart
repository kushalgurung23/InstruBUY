import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/admin/updateAdmin.dart';
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminList extends StatefulWidget {
  static const String id = "adminCustomerDetails.dart";

  @override
  _AdminListState createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  SharedPreferences sharedPreferences;
  String current_adminId;
  Map mapData;

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      current_adminId = sharedPreferences.getString('admin_id');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  Future fetchAdminData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchAdminData.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  void deleteAdmin({String admin_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/deleteAdmin.php";
    var res = await http.post(url, body: {
      'admin_id': admin_id,
    });
    if (jsonDecode(res.body) == 'true') {
      Fluttertoast.showToast(
          msg: "Admin deleted permanently.", toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Sorry, admin's account couldn't be deleted.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Please try again later.", toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  void updateAdmin({String emailAddress, String position}) {
    setState(() {
      emailAddress = mapData["email_address"];
      position = mapData["position"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Admin Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(5),
              vertical: getProportionateScreenWidth(2),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 6, top: 2),
              child: RoundedIconButton(
                iconData: Icons.arrow_back_ios,
                press: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: fetchAdminData(),
          // snapshot is a library that implements data classes. It simplifies accessing and converting properties in a JSON-like object.
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize,
                            horizontal: SizeConfig.defaultSize * 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.defaultSize),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Colors.blue]),
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Admin ID: " + list[index]['admin_id'],
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Email: \t\t\t\t\t\t" +
                                          list[index]['email_address'],
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  Text(
                                      "Position: \t " + list[index]['position'],
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () async {
                                    mapData = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateAdmin(
                                                  list: list,
                                                  index: index,
                                                )));
                                    if (mapData == null) {
                                      return;
                                    } else {
                                      updateAdmin(
                                          emailAddress: list[index]
                                              ['email_address'],
                                          position: list[index]['position']);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      if (current_adminId ==
                                          list[index]['admin_id']) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You cannot delete your own account.",
                                            toastLength: Toast.LENGTH_SHORT);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  "Are you sure you want to delete this admin permanently?"),
                                              actions: [
                                                TextButton(
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    onPressed: () => {
                                                          Navigator.pop(context)
                                                        }),
                                                TextButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  onPressed: () => deleteAdmin(
                                                      admin_id: list[index]
                                                          ['admin_id']),
                                                ),
                                              ],
                                            );
                                          },
                                          barrierDismissible: false,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
