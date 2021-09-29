import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminInactiveOrderDetails.dart';
import 'package:instrubuy/admin/adminInactiveProducts.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:http/http.dart' as http;

class UpdateProductStatus extends StatefulWidget {

  final String product_id, product_status;

  UpdateProductStatus({this.product_id, this.product_status});

  @override
  _UpdateProductStatusState createState() => _UpdateProductStatusState();
}

class _UpdateProductStatusState extends State<UpdateProductStatus> {
  String selectedProductStatus;
  List productStatusOption = [
    "Active",
    "Inactive",
  ];

  updateProductStatus() async {
    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateProductStatus.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['product_id'] = widget.product_id;
    request.fields['status'] = selectedProductStatus;

    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Product's status has been updated successfully.",
          toastLength: Toast.LENGTH_SHORT);

      String status = "ok";
      await Navigator.pop(context, status);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminInactiveProducts()));
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
    if(widget.product_status != null) {
      selectedProductStatus = widget.product_status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Update Product Status",
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
                      title: "Product Status",
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
                      hint: Text("Select product status"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedProductStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedProductStatus = newValue;
                        });
                      },
                      items: productStatusOption.map((valueItem) {
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
                          if(selectedProductStatus == 'Inactive') {
                            Fluttertoast.showToast(
                                msg: "Product's status is inactive already.",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                          else {
                            updateProductStatus();
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
