import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/addProduct.dart';
import 'package:instrubuy/admin/adminInactiveProducts.dart';
import 'package:instrubuy/admin/adminPanel.dart';
import 'package:instrubuy/admin/adminAllProducts.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class ProductOptionScreen extends StatefulWidget {
  @override
  _ProductOptionScreenState createState() => _ProductOptionScreenState();
}

class _ProductOptionScreenState extends State<ProductOptionScreen> {
  String selectedProductOption;
  List productOption = [
    "Add Product",
    "Active Products",
    "Inactive Products",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Product Details",
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
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      hint: Text("Select option"),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedProductOption,
                      onChanged: (newValue) {
                        setState(() {
                          selectedProductOption = newValue;
                        });
                      },
                      items: productOption.map((valueItem) {
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
                      buttonName: "Select",
                      onPress: () {
                        setState(() {
                          if (selectedProductOption == 'Add Product') {
                            Navigator.pushNamed(context, AddProductScreen.id);
                          } else if (selectedProductOption ==
                              'Active Products') {
                            Navigator.pushNamed(context, AdminAllProducts.id);
                          } else if(selectedProductOption ==
                              'Inactive Products'){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminInactiveProducts()));
                          }
                          else {
                            Fluttertoast.showToast(
                                msg:
                                "Please select an option.",
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
