import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class AdminCustomerDetails extends StatefulWidget {
  static const String id = "adminCustomerDetails.dart";

  @override
  _AdminCustomerDetailsState createState() => _AdminCustomerDetailsState();
}

class _AdminCustomerDetailsState extends State<AdminCustomerDetails> {
  Future fetchCustomerData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchCustomerData.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  void deleteActiveCustomer({String customer_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/deleteActiveCustomer.php";
    var res = await http.post(url, body: {
      'customer_id': customer_id,
    });
    if (jsonDecode(res.body) == 'true') {
      Fluttertoast.showToast(
          msg: "Customer's account has been deleted temporarily.",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res.body) == 'false') {
      Fluttertoast.showToast(
          msg: "Sorry, customer's account couldn't be deleted.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Please try again later.", toastLength: Toast.LENGTH_SHORT);
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
            'Active Customer Details',
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
          future: fetchCustomerData(),
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
                            trailing: GestureDetector(
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
                                          "Are you sure you want to delete this customer temporarily?"),
                                      actions: [
                                        TextButton(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            onPressed: () =>
                                                {Navigator.pop(context)}),
                                        TextButton(
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () => deleteActiveCustomer(
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
