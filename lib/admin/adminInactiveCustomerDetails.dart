import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/admin/customerStatus.dart';
import 'package:instrubuy/admin/updateCustomerStatus.dart';
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class AdminInactiveCustomerDetails extends StatefulWidget {
  @override
  _AdminInactiveCustomerDetailsState createState() =>
      _AdminInactiveCustomerDetailsState();
}

class _AdminInactiveCustomerDetailsState
    extends State<AdminInactiveCustomerDetails> {
  Future fetchInactiveCustomerData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchInactiveCustomerData.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  void deleteInactiveCustomer({String customer_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/deleteCustomer.php";
    var res = await http.post(url, body: {
      'customer_id': customer_id,
    });
    if (jsonDecode(res.body) == "Customer is in cart table") {
      Fluttertoast.showToast(
          msg:
              "Sorry, this customer account cannot be deleted, because this customer has products added to their cart.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "Customer is in order table") {
      Fluttertoast.showToast(
          msg:
              "Sorry, this customer account cannot be deleted, because it's details are stored in order details.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "true") {
      Fluttertoast.showToast(
          msg: "Customer's account has been deleted permanently.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Error, please try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Inactive Customer Details',
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
          future: fetchInactiveCustomerData(),
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
                                Text(
                                    "Customer ID: " +
                                        list[index]['customer_id'],
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    "Name:\t\t\t\t\t\t\t\t\t\t\t" +
                                        list[index]['full_name'],
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Email:\t\t\t\t\t\t\t\t\t\t\t\t" +
                                          list[index]['email_address'],
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  Text(
                                      "Address:\t\t\t\t\t\t\t " +
                                          list[index]['address'],
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
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateCustomerStatus(
                                                  customer_id: list[index]
                                                      ['customer_id'],
                                                  customerStatus: list[index]
                                                      ['status'],
                                                  email_address: list[index]
                                                      ['email_address'],
                                                )));
                                    setState(() {
                                      build(context);
                                    });
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Are you sure you want to delete this customer permanently?"),
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
                                                  onPressed: () =>
                                                      {Navigator.pop(context)}),
                                              TextButton(
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                onPressed: () =>
                                                    deleteInactiveCustomer(
                                                        customer_id: list[index]
                                                            ['customer_id']),
                                              ),
                                            ],
                                          );
                                        },
                                        barrierDismissible: false,
                                      );
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
