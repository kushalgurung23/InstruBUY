import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/admin/orderStatus.dart';
import 'package:instrubuy/admin/updateOrderStatus.dart';
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class AdminOrderDetails extends StatefulWidget {
  static const String id = "adminOrderDetails.dart";

  @override
  _AdminOrderDetailsState createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {

  void deleteOrder({String order_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/deleteOrder.php";
    var res = await http.post(url, body: {
      'order_id': order_id,
    });
    if (jsonDecode(res.body) ==
        "true") {
      Fluttertoast.showToast(
          msg: "Order detail has been deleted temporarily.",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg:
          "Error, please try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  Future fetchOrderData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchOrderData.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "Active Order Details",
          onPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrderStatus()));
          },
        ),
        body: FutureBuilder(
          future: fetchOrderData(),
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
                            vertical: SizeConfig.defaultSize, horizontal: SizeConfig.defaultSize * 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blue]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: GestureDetector(
                              child: Icon(Icons.edit, color: Colors.white,),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateOrderStatus(
                                              order_id: list[index]['order_id'],
                                              paymentStatus: list[index]
                                                  ['is_paid'],
                                              orderStatus: list[index]['status'],
                                            )));
                                debugPrint('Edit button clicked');
                              },
                            ),
                            title: Text(
                              "Customer: " + list[index]['full_name'],
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Product: " + list[index]['title'], style: TextStyle(color: Colors.white),
                                ),
                                Text("Number of item: " +
                                    list[index]['total_item'], style: TextStyle(color: Colors.white)),
                                Text("Time: " + list[index]['payment_time'], style: TextStyle(color: Colors.white)),
                                Text("Date: " + list[index]['payment_date'], style: TextStyle(color: Colors.white)),
                                Text("Total amount: Rs. " +
                                    list[index]['total_amount'], style: TextStyle(color: Colors.white)),
                                Text("Payment method: " +
                                    list[index]['payment_method'], style: TextStyle(color: Colors.white)),
                                Text((() {
                                  if (list[index]['is_paid'] == '1') {
                                    return "Payment status: Paid";
                                  }

                                  return "Payment status: Unpaid";
                                })(), style: TextStyle(color: Colors.white)),
                                Text("Product delivery: " + list[index]['status'], style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            trailing: GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Are you sure you want to delete this order detail temporarily?"),
                                        actions: [
                                          TextButton(
                                              child: Text("No", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                              onPressed: () =>
                                              {Navigator.pop(context)}),
                                          TextButton(
                                            child: Text("Yes", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                            onPressed: () =>
                                                deleteOrder(order_id: list[index]['order_id']),
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
