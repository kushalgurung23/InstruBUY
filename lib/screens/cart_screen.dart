import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:instrubuy/buttons/defaultFlatButton.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/cartBody.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/screens/deliveryDetails.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String id = "cart_screen.dart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ParentModel>(
      builder: (BuildContext context, Widget child, ParentModel parentModel) {
        return Scaffold(
          appBar: buildAppBar(context, parentModel),
          body: CartBody(),
          bottomNavigationBar: CartBottomContainer(),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context, ParentModel parentModel) {
    return AppBar(
      centerTitle: true,
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
              Navigator.pushNamed(context, HomeScreen.id);
            },
          ),
        ),
      ),
      title: Column(
        children: [
          Text(
            "My Cart",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CartBottomContainer extends StatefulWidget {

  String totalAmount;

  @override
  _CartBottomContainerState createState() => _CartBottomContainerState();
}

class _CartBottomContainerState extends State<CartBottomContainer> {

  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  Future getTotalAmount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/total_amount.php";

    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url, body: data);
    widget.totalAmount = await json.decode(response.body)[0]['sum(line_total)'];
    print(json.decode(response.body)[0]['sum(line_total)']);
    return json.decode(response.body)[0]['sum(line_total)'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, defaultSize /2),
      height: SizeConfig.defaultSize * 17.5,
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(5),
        horizontal: getProportionateScreenWidth(30),
      ),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            // Raises the container x-axis and y-axis
            offset: Offset(0, -15),
            blurRadius: 20.0,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Total:"),
                  FutureBuilder(
                    future: getTotalAmount(),
                    builder: (context, snapshot) {
                      var value =
                          (snapshot.connectionState == ConnectionState.done
                              ? '${widget.totalAmount}'
                              : '0');
                      return Text(
                        (() {
                          if (value == 'null') {
                            return "Rs. 0";
                          }

                          return "Rs. " + value;
                        })(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: getProportionateScreenWidth(40.0),
              ),
              DefaultFlatButton(
                buttonName: "Update Cart",
                buttonColor: Colors.green[500],
                onPress: () async {
                  setState(() {
                    getTotalAmount();
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: defaultSize * 2,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: ExtendedFlatButton(
              buttonName: "Check Out",
              onPress: () {
                if (widget.totalAmount == null || widget.totalAmount == '0') {
                  Fluttertoast.showToast(
                      msg: "You don't have any items in your cart.",
                      toastLength: Toast.LENGTH_SHORT);
                } else {
                  Navigator.pushNamed(context, DeliveryDetails.id);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
