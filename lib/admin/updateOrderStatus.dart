import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminOrderDetails.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:http/http.dart' as http;

class UpdateOrderStatus extends StatefulWidget {
  final String order_id, paymentStatus, orderStatus;

  UpdateOrderStatus({this.order_id, this.paymentStatus, this.orderStatus});

  @override
  _UpdateOrderStatusState createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  String selectedPaymentStatus;
  String selectedOrderStatus;
  List paymentStatus = [
    "Paid",
    "Unpaid",
  ];

  List orderStatus = [
    "Complete",
    "Incomplete",
  ];

  updateOrderStatus() async {
    Map mapData;

    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateOrderStatus.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['order_id'] = widget.order_id;
    request.fields['payment_status'] =
        selectedPaymentStatus == 'Paid' ? '1' : '0';
    request.fields['order_status'] = selectedOrderStatus;

    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order detail is updated successfully.",
          toastLength: Toast.LENGTH_SHORT);

      mapData = {"is_paid": selectedPaymentStatus == 'Paid' ? '1' : '0', "order_status": selectedOrderStatus};

      Navigator.pop(context, mapData);
    } else {
      Fluttertoast.showToast(
          msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.paymentStatus != null && widget.orderStatus != null) {
      if (widget.paymentStatus == '1') {
        selectedPaymentStatus = 'Paid';
      } else {
        selectedPaymentStatus = 'Unpaid';
      }
      selectedOrderStatus = widget.orderStatus;
      print(widget.order_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Update Order Status",
        onPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize * 2, 0, SizeConfig.defaultSize * 2, SizeConfig.defaultSize * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultSize * 1, vertical: defaultSize * 2),
                    child: TitleText(
                      title: "Payment Status",
                      color: kTitleColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      hint: Text("Select payment"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedPaymentStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedPaymentStatus = newValue;
                        });
                      },
                      items: paymentStatus.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultSize * 1, vertical: defaultSize * 2),
                    child: TitleText(
                      title: "Order Status",
                      color: kTitleColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      hint: Text("Select order"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedOrderStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOrderStatus = newValue;
                        });
                      },
                      items: orderStatus.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize * 3),
                    child: ExtendedFlatButton(
                      buttonName: "Update",
                      onPress: () {
                        setState(() {
                          updateOrderStatus();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
