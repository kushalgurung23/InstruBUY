import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminInactiveCustomerDetails.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:http/http.dart' as http;

class UpdateCustomerStatus extends StatefulWidget {

  final String customer_id, customerStatus, email_address;

  UpdateCustomerStatus({this.customer_id, this.customerStatus, this.email_address});

  @override
  _UpdateCustomerStatusState createState() => _UpdateCustomerStatusState();
}

class _UpdateCustomerStatusState extends State<UpdateCustomerStatus> {
  String selectedCustomerStatus;
  List customerOption = [
    "Active",
    "Inactive",
  ];

  updateCustomerStatus() async {
    var url = "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateCustomerStatus.php";
    var customerData = {
      "customer_id": widget.customer_id,
      "status": selectedCustomerStatus,
      "email_address": widget.email_address
    };

    var response = await http.post(url, body: customerData);

    if(jsonDecode(response.body) == "Account already exists") {
      Fluttertoast.showToast(
          msg: "Another active account with this email address is present already.", toastLength: Toast.LENGTH_LONG);
    }
    else if(jsonDecode(response.body) == "true") {
      Fluttertoast.showToast(
          msg: "Customer status has been updated successfully.",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminInactiveCustomerDetails()));
    }
    else {
      Fluttertoast.showToast(
          msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.customerStatus != null) {
      selectedCustomerStatus = widget.customerStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Update Customer Status",
        onPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        defaultSize * 1, 0, defaultSize * 1, defaultSize * 2),
                    child: TitleText(
                      title: "Customer Status",
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
                      hint: Text("Select customer status"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedCustomerStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCustomerStatus = newValue;
                        });
                      },
                      items: customerOption.map((valueItem) {
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
                      buttonName: "Update Status",
                      onPress: () {
                        setState(() {
                          if(selectedCustomerStatus == 'Inactive') {
                            Fluttertoast.showToast(
                                msg: "Customer status set to inactive.",
                                toastLength: Toast.LENGTH_SHORT);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminInactiveCustomerDetails()));
                          }
                          else if (selectedCustomerStatus == 'Active') {
                            updateCustomerStatus();
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
      ),
    );
  }
}
