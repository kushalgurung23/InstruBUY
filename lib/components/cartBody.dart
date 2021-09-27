import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instrubuy/screens/cart_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  Future getCartItems() async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/loadCart.php";
    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url_address, body: data);
    return json.decode(response.body);
  }

  String totalAmount = '0';

  Future getTotalAmount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/total_amount.php";

    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url, body: data);
    totalAmount = await json.decode(response.body)[0]['sum(line_total)'];
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
      child: FutureBuilder(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Dismissible(
                            key: Key(
                              list[index]['product_id'].toString(),
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE6E6),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: [
                                  Spacer(),
                                  SvgPicture.asset("assets/icons/Trash.svg"),
                                ],
                              ),
                            ),
                            onDismissed: (direction) async {
                              var url =
                                  "https://instrubuy.000webhostapp.com/instrubuy_cart/deleteCartProduct.php";
                              await http.post(url, body: {
                                'product_id': list[index]['product_id'],
                                'customer_id': list[index]['customer_id'],
                                'total_item': list[index]['total_item']
                              });
                              setState(() {
                                Navigator.pushNamed(context, CartScreen.id);
                                list.removeAt(index);
                              });
                            },
                            child: CartItems(
                              list: list,
                              index: index,
                            ),
                          ),
                        );
                      }),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    backgroundColor: kPrimaryLightColor,
                  ),
                );
        },
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    @required this.list,
    @required this.index,
    Key key,
  }) : super(key: key);
  final List list;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(88.0),
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Image.network(
                  "https://instrubuy.000webhostapp.com/instrubuy_images/${list[index]['image_location']}"),
            ),
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(20.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list[index]['title'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              maxLines: 2,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text.rich(
              TextSpan(
                text: "Rs. ${list[index]['price']}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
                children: [
                  TextSpan(
                    text: " x ${list[index]['total_item']}",
                    style: TextStyle(
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
