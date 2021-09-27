import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderDetails extends StatefulWidget {
  static const String id = "orderScreen.dart";

  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  Future fetchCustomerOrderData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_order/customerOrder.php';
    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url, body: data);
    return json.decode(response.body);
  }

  void deleteOrderHistory({String order_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_order/deleteOrderHistory.php";
    var res = await http.post(url, body: {
      'order_id': order_id,
    });
    if (jsonDecode(res.body) == "true") {
      Fluttertoast.showToast(
          msg: "Your order history has been deleted.",
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Order History',
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
          future: fetchCustomerOrderData(),
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
                            vertical: SizeConfig.defaultSize),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.defaultSize),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Colors.blue]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                list[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Number of item: " +
                                        list[index]['total_item'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Customer: " + list[index]['full_name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Time: " + list[index]['payment_time'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Date: " + list[index]['payment_date'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Total amount: Rs. " +
                                        list[index]['total_amount'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Payment method: " +
                                        list[index]['payment_method'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    (() {
                                      if (list[index]['is_paid'] == '1') {
                                        return "Payment status: Paid";
                                      }

                                      return "Payment status: Unpaid";
                                    })(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Product delivery: " + list[index]['status'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              "Are you sure you want to delete this order history?"),
                                          actions: [
                                            TextButton(
                                                child: Text("No", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                                onPressed: () =>
                                                    {Navigator.pop(context)}),
                                            TextButton(
                                              child: Text("Yes", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                              onPressed: () =>
                                                  deleteOrderHistory(
                                                      order_id: list[index]
                                                          ['order_id']),
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: false,
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    backgroundColor: kPrimaryLightColor,
                  ));
          },
        ),
      ),
    );
  }
}
