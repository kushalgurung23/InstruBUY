import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/admin/productOptionScreen.dart';
import 'package:instrubuy/admin/updateProduct.dart';
import 'package:instrubuy/admin/updateProductStatus.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminInactiveProducts extends StatefulWidget {
  @override
  _AdminInactiveProductsState createState() => _AdminInactiveProductsState();
}

class _AdminInactiveProductsState extends State<AdminInactiveProducts> {
  SharedPreferences preferences;
  String productImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  // For passing customer's profile image.
  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      productImage = preferences.getString('productImage');
    });
  }

  Future fetchProductData() async {
    var url =
        'https://instrubuy.000webhostapp.com/instrubuy_adminPanel/fetchInactiveProducts.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  void deleteInactiveProducts({String product_id}) async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/deleteProducts.php";
    var res = await http.post(url, body: {
      'product_id': product_id,
    });
    if (jsonDecode(res.body) ==
        "Product is in cart table") {
      Fluttertoast.showToast(
          msg:
          "Sorry, this product cannot be deleted, because it is in the cart of customer.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) ==
        "Product is in order table") {
      Fluttertoast.showToast(
          msg:
          "Sorry, this product cannot be deleted, because it's details are stored in order details of customer.",
          toastLength: Toast.LENGTH_LONG);
    } else if (jsonDecode(res.body) ==
        "true") {
      Fluttertoast.showToast(
          msg: "Product has been deleted permanently.",
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Musical Instruments',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductOptionScreen()));
                },
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: fetchProductData(),
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
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blue]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: SizeConfig.defaultSize,
                                horizontal: SizeConfig.defaultSize),
                            leading: CachedNetworkImage(
                              width: SizeConfig.defaultSize * 6,
                              imageUrl:
                                  "https://instrubuy.000webhostapp.com/instrubuy_images/${list[index]['image_location']}",
                              placeholder: (context, url) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 1.2),
                                child: new CircularProgressIndicator(
                                  color: kPrimaryColor,
                                  backgroundColor: kPrimaryLightColor,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            title: Text(list[index]['title'],
                                style: TextStyle(color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: SizeConfig.defaultSize / 2,
                                ),
                                Text("Product ID: " + list[index]['product_id'],
                                    style: TextStyle(color: Colors.white)),
                                Text("Amount: Rs. " + list[index]['price'],
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    "Quantity: " +
                                        list[index]['product_quantity'],
                                    style: TextStyle(color: Colors.white)),
                                Text("Category: " + list[index]['category_id'],
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProductStatus(
                                                  product_id: list[index]
                                                      ['product_id'],
                                                  product_status: list[index]
                                                      ['status'],
                                                )));
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Are you sure you want to delete this product permanently?"),
                                            actions: [
                                              TextButton(
                                                  child: Text("No", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                                  onPressed: () =>
                                                  {Navigator.pop(context)}),
                                              TextButton(
                                                child: Text("Yes", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                                                onPressed: () =>
                                                    deleteInactiveProducts(product_id: list[index]['product_id']),
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
