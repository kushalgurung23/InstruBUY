import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/payment.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/inputTextField.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryDetails extends StatefulWidget {
  static const String id = "deliveryDetails.dart";

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  String totalAmount;
  String totalCartItem;
  String getDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String getTime = DateFormat("hh:mm:ss").format(DateTime.now());
  TextEditingController cityText = TextEditingController();
  TextEditingController streetAddressText = TextEditingController();
  TextEditingController streetNumberText = TextEditingController();
  TextEditingController phoneNumberText = TextEditingController();
  String selectedProvince;
  List provinceList = [
    "Province No 1",
    "Province No 2",
    "Province No 3",
    "Province No 4",
    "Province No 5",
    "Province No 6",
    "Province No 7",
  ];

  String selectedPaymentMethod = '';

  Future getTotalAmount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/total_amount.php";

    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url, body: data);
    totalAmount = await json.decode(response.body)[0]['sum(line_total)'];
    //print(json.decode(response.body)[0]['sum(line_total)']);
    return json.decode(response.body)[0]['sum(line_total)'];
  }

  Future getCartItemNumber() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_cart/totalCartItem.php";

    var data = {
      "customer_id": yourCustomer_id,
    };
    var response = await http.post(url, body: data);
    totalCartItem = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future cashOnDelivery() async {
    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_order/cashOnDelivery.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['customer_id'] = yourCustomer_id;
    request.fields['phone_number'] = phoneNumberText.text;
    request.fields['province'] = selectedProvince.toString();
    request.fields['city'] = cityText.text;
    request.fields['street_address'] = streetAddressText.text;
    request.fields['street_number'] = streetNumberText.text;
    request.fields['payment_time'] = getTime.toString();
    request.fields['payment_date'] = getDate.toString();
    request.fields['payment_method'] = selectedPaymentMethod.toString();
    request.fields['total_amount'] = totalAmount.toString();

    var response = await request.send();

    if (response.statusCode == 200) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Order Received"),
            content: Text(
                "Delivery is on the way. Thank you for purchasing with InstruBUY."),
            actions: [
              TextButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600),
                  ),
                  onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false)
                  }),
            ],
          );
        },
        barrierDismissible: false,
      );

    } else {
      Fluttertoast.showToast(
          msg: "Sorry, please try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "Delivery Details",
          onPress: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(defaultSize, 0, 0, defaultSize * 2),
                  child: TitleText(
                    title: "Delivery Details",
                    color: kTitleColor,
                  ),
                ),
                InputTextField(
                  textInputType: TextInputType.number,
                  textInputFormatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Phone Number",
                  onChanged: (value) {},
                  textEditingController: phoneNumberText,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      hint: Text("Province"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedProvince,
                      onChanged: (newValue) {
                        setState(() {
                          selectedProvince = newValue;
                        });
                      },
                      items: provinceList.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                InputTextField(
                  hintText: "City",
                  onChanged: (value) {},
                  textEditingController: cityText,
                ),
                InputTextField(
                  hintText: "Street Address",
                  onChanged: (value) {},
                  textEditingController: streetAddressText,
                ),
                InputTextField(
                  // TextInputType.multiline
                  textInputType: TextInputType.number,
                  textInputFormatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Street Number",
                  onChanged: (value) {},
                  textEditingController: streetNumberText,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultSize * 1, vertical: defaultSize * 2),
                  child: TitleText(
                    title: "Payment Method",
                    color: kTitleColor,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: kPrimaryColor,
                      value: 'Cash on Delivery',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        selectedPaymentMethod = value;
                        setState(() {});
                      },
                    ),
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: kPrimaryColor,
                      value: 'Khalti',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        selectedPaymentMethod = value;
                        setState(() {});
                      },
                    ),
                    Text(
                      'Khalti',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1,
                          vertical: defaultSize * 2),
                      child: TitleText(
                        title: "Total cart item:",
                        color: kTitleColor,
                      ),
                    ),
                    FutureBuilder(
                      future: getCartItemNumber(),
                      builder: (context, snapshot) {
                        var value =
                            (snapshot.connectionState == ConnectionState.done
                                ? '${totalCartItem}'
                                : '${totalCartItem}');
                        return Text(
                          value,
                          style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1,
                          vertical: defaultSize * 2),
                      child: TitleText(
                        title: "Total Amount:  ",
                        color: kTitleColor,
                      ),
                    ),
                    FutureBuilder(
                      future: getTotalAmount(),
                      builder: (context, snapshot) {
                        var value =
                            (snapshot.connectionState == ConnectionState.done
                                ? '${totalAmount}'
                                : '${totalAmount}');
                        return Text(
                          (() {
                            if (value == 'null') {
                              return "Rs. 0";
                            }

                            return "Rs. " + value;
                          })(),
                          style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
                  child: ExtendedFlatButton(
                    buttonName: "Checkout",
                    onPress: () {
                      setState(() {
                        if (totalAmount.toString() == '0' ||
                            totalAmount == null) {
                          Fluttertoast.showToast(
                              msg: "You don't have any items in your cart.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (phoneNumberText.text.toString() == '' ||
                            selectedProvince == null ||
                            cityText.text.toString() == '' ||
                            streetAddressText.text.toString() == '' ||
                            streetNumberText.text.toString == '') {
                          Fluttertoast.showToast(
                              msg: "Please provide all details to proceed.",
                              toastLength: Toast.LENGTH_SHORT);
                          print("Your amount" + totalAmount);
                        } else if (phoneNumberText.text.length != 10) {
                          Fluttertoast.showToast(
                              msg:
                                  "Please provide your correct 10 digit phone number.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (selectedPaymentMethod == '') {
                          Fluttertoast.showToast(
                              msg: "Please select a payment method.",
                              toastLength: Toast.LENGTH_SHORT);
                          print("Selected province: " +
                              selectedProvince.toString());
                        }
                        // If correct delivery details are entered.
                        else {
                          if (selectedPaymentMethod == "Khalti") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payment(
                                          phoneNumber: phoneNumberText.text,
                                          selectedProvince:
                                              selectedProvince.toString(),
                                          city: cityText.text,
                                          streetAddress: streetAddressText.text,
                                          streetNumber: streetNumberText.text,
                                          paymentMethod:
                                              selectedPaymentMethod.toString(),
                                          totalAmount: totalAmount.toString(),
                                        )));
                          } else if (selectedPaymentMethod ==
                              "Cash on Delivery") {
                            cashOnDelivery();
                          }
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
