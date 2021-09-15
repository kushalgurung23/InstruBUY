import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/buttons/defaultFlatButton.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/screens/deliveryDetails.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/detailScreenBottomContainer.dart';
import 'package:instrubuy/smallComponents/detailScreenImages.dart';
import 'package:instrubuy/smallComponents/productDescription.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instrubuy/components/cartNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreenBody extends StatefulWidget {
  final Product product;

  CartNumber cartNumber = CartNumber();

  DetailScreenBody({this.product});

  @override
  _DetailScreenBodyState createState() => _DetailScreenBodyState();
}

class _DetailScreenBodyState extends State<DetailScreenBody> {
  void addToCart({String customer_id, int total_item}) async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/addCart.php";
    var data = {
      "product_id": widget.product.product_id.toString(),
      "customer_id": customer_id,
      "total_item": total_item.toString(),
      "price": widget.product.price.toString(),
      "line_total": ((widget.product.price) * (total_item)).toString(),
    };

    // The values of above data dictionary is now passed onto url address of our php file i.e. signup.php.
    var res = await http.post(url_address, body: data);
    if (jsonDecode(res.body) == "no account") {
      accountDisable();
      Navigator.pushNamed(context, LoginScreen.id);
      Fluttertoast.showToast(
          msg: "Your account has been deactivated.",
          toastLength: Toast.LENGTH_SHORT);
    }
    // If product already exists
    else if (jsonDecode(res.body) == "Product already exists") {
      Fluttertoast.showToast(
          msg: "This product is already added in your cart",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "not enough quantity") {
      Fluttertoast.showToast(
          msg: "Sorry, we don't have selected amount of quantity.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "true2") {
      Fluttertoast.showToast(
          msg: "Added to cart successfully", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Error, please try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  void checkOut({String customer_id, int total_item}) async {
    var url_address =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/addCart.php";
    var data = {
      // cart_id, product_id, no.of items
      "product_id": widget.product.product_id.toString(),
      "customer_id": customer_id,
      "total_item": total_item.toString(),
      "price": widget.product.price.toString(),
      "line_total": ((widget.product.price) * (total_item)).toString(),
    };

    // The values of above data dictionary is now passed onto url address of our php file i.e. signup.php.
    var res = await http.post(url_address, body: data);

    // If product already exists in cart
    if (jsonDecode(res.body) == "Product already exists") {
      Fluttertoast.showToast(
          msg: "This product is already added in your cart",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "not enough quantity") {
      Fluttertoast.showToast(
          msg: "Sorry, we don't have selected amount of quantity.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) == "true2") {
      Navigator.pushNamed(context, DeliveryDetails.id);
    } else {
      Fluttertoast.showToast(
          msg: "Error, please try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  void accountDisable() {
    setState(() {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DetailScreenImages(product: widget.product),
        DetailScreenBottomContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProductDescription(
                          product: widget.product,
                        ),
                        SizedBox(
                          height: defaultSize * 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CartNumber(),
              Padding(
                padding: EdgeInsets.fromLTRB(defaultSize * 2, defaultSize, defaultSize * 2, defaultSize * 2),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: defaultSize),
                      height: defaultSize * 5.0,
                      width: defaultSize * 6.0,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultSize * 1.5),
                          border: Border.all(
                            color: kPrimaryLightColor,
                          )),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: kPrimaryLightColor,
                        ),
                        onPressed: () async {
                          //await decreaseProductQuantity(total_item: CartQuantity.cartQuantity);
                          await addToCart(
                            customer_id: yourCustomer_id,
                            total_item: CartQuantity.cartQuantity,
                          );
                        },
                      ),
                    ),
                    DefaultFlatButton(
                      buttonName: "Buy Now",
                      buttonColor: Colors.deepOrangeAccent,
                      onPress: () async {
                        // It will set the value of quantity = 1 in detail screen
                        await checkOut(
                          customer_id: yourCustomer_id,
                          total_item: CartQuantity.cartQuantity,
                          // It will set the value of quantity = 1 in detail screen
                        );
                        CartQuantity.cartQuantity = 1;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
