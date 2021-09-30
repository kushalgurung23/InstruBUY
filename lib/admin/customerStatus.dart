import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminCustomerDetails.dart';
import 'package:instrubuy/admin/adminInactiveCustomerDetails.dart';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';

class CustomerStatus extends StatefulWidget {
  @override
  _CustomerStatusState createState() => _CustomerStatusState();
}

class _CustomerStatusState extends State<CustomerStatus> {
  String selectedCustomerOption;
  List customerOption = [
    "Active Customers",
    "Inactive Customers",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Customer Details",
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
                      value: selectedCustomerOption,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCustomerOption = newValue;
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
                      buttonName: "View",
                      onPress: () {
                        setState(() {
                          if (selectedCustomerOption == 'Active Customers') {
                            Navigator.pushNamed(
                                context, AdminCustomerDetails.id);
                          }
                          else if (selectedCustomerOption == 'Inactive Customers') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminInactiveCustomerDetails()));
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: "Please select a customer status.",
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
