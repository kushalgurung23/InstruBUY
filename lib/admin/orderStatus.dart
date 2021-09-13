import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminInactiveOrderDetails.dart';
import 'package:instrubuy/admin/adminOrderDetails.dart';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';

class OrderStatus extends StatefulWidget {
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  String selectedOrderOption;
  List orderOption = [
    "Active order details",
    "Inactive order details",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Order Details",
        onPress: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminPanel()));
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
                      hint: Text("Select order status"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedOrderOption,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOrderOption = newValue;
                        });
                      },
                      items: orderOption.map((valueItem) {
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
                      buttonName: "View",
                      onPress: () {
                        setState(() {
                          if (selectedOrderOption == 'Active order details') {
                            Navigator.pushNamed(context, AdminOrderDetails.id);
                          } else if (selectedOrderOption ==
                              'Inactive order details') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdminInactiveOrderDetails()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select an order status.",
                                toastLength: Toast.LENGTH_SHORT);
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
