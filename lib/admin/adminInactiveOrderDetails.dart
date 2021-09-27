import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/admin/orderStatus.dart';
import 'package:instrubuy/admin/updateFinalOrderStatus.dart';
import 'package:instrubuy/admin/updateOrderStatus.dart';
import 'dart:convert';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class AdminInactiveOrderDetails extends StatefulWidget {

  @override
  _AdminInactiveOrderDetailsState createState() => _AdminInactiveOrderDetailsState();
}

class _AdminInactiveOrderDetailsState extends State<AdminInactiveOrderDetails> {

  Future fetchInactiveOrderData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchInactiveOrderData.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "Inactive Order Details",
          onPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrderStatus()));
          },
        ),
        body: FutureBuilder(
          future: fetchInactiveOrderData(),
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
                                  builder: (context) =>
                                      UpdateFinalOrderStatus(
                                        order_id: list[index]['order_id'],
                                        finalOrder_status: list[index]['final_status'],
                                      )));
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
