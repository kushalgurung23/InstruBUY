import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/smallComponents/roundedInputField.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  String getDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String getTime = DateFormat("hh:mm:ss").format(DateTime.now());

  static const String id = "payment.dart";
  final String phoneNumber;
  final String selectedProvince;
  final String city;
  final String streetAddress;
  final String streetNumber;
  final String paymentMethod;
  final String totalAmount;

  Payment(
      {this.totalAmount,
      this.city,
      this.streetAddress,
      this.streetNumber,
      this.phoneNumber,
      this.selectedProvince,
      this.paymentMethod});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController amountText;
  SharedPreferences preferences;
  String yourCustomer_id;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    amountText = TextEditingController(text: '');
    amountText.text = widget.totalAmount;
    super.initState();
    initial();
  }

  Future payWithKhalti() async {
    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_order/khaltiOption.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['customer_id'] = yourCustomer_id;
    request.fields['phone_number'] = widget.phoneNumber;
    request.fields['province'] = widget.selectedProvince;
    request.fields['city'] = widget.city;
    request.fields['street_address'] = widget.streetAddress;
    request.fields['street_number'] = widget.streetNumber;
    request.fields['payment_time'] = widget.getTime;
    request.fields['payment_date'] = widget.getDate;
    request.fields['payment_method'] = widget.paymentMethod;
    request.fields['total_amount'] = amountText.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Your order has been received.",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.pushNamed(context, HomeScreen.id);
    } else {
      Fluttertoast.showToast(
          msg: "Please try again after some time.",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: size.width / 2,
            child: Column(
              children: [
                RoundedInputField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Amount",
                  onChanged: (value) {
                    amountText.text = value;
                  },
                  keyBoardType: TextInputType.number,
                  textEditingController: amountText,
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 2,
                ),
                ExtendedFlatButton(
                  buttonName: "Pay with Khalti",
                  onPress: () {
                    if (amountText.text == "") {
                      Fluttertoast.showToast(
                          msg: "Enter total payment amount.",
                          toastLength: Toast.LENGTH_SHORT);
                    } else if (double.parse(amountText.text.toString()) < 1) {
                      Fluttertoast.showToast(
                          msg: "Payment amount must be at least Rs. 1.",
                          toastLength: Toast.LENGTH_SHORT);
                    } else if (double.parse(amountText.text.toString()) > 1000) {
                      Fluttertoast.showToast(
                          msg: "Payment amount must be less than Rs. 1000.",
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      _makePayment(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _makePayment(BuildContext context) {
    double amount = double.parse(amountText.text.trim()) * 100;

    // Test public key should be used instead of live key for testing purpose.
    FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
        publicKey: "Enter your public key...",
        urlSchemeIOS: "KhaltiPayFlutterExampleSchema");

    KhaltiProduct product = KhaltiProduct(
        id: "test", amount: amount, name: "Payment for musical instrument");

    _flutterKhalti.startPayment(
        product: product,
        onSuccess: (data) {
          payWithKhalti();
        },
        onFaliure: (error) {
          Fluttertoast.showToast(
              msg: "Payment unsuccessful.", toastLength: Toast.LENGTH_SHORT);
        });
  }

  AppBar buildAppBar(BuildContext context) {
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      title: Column(
        children: [
          Text(
            "Payment",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
