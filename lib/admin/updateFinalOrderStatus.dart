import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminInactiveOrderDetails.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:http/http.dart' as http;

class UpdateFinalOrderStatus extends StatefulWidget {

  final String order_id, finalOrder_status;

  UpdateFinalOrderStatus({this.order_id, this.finalOrder_status});

  @override
  _UpdateFinalOrderStatusState createState() => _UpdateFinalOrderStatusState();
}

class _UpdateFinalOrderStatusState extends State<UpdateFinalOrderStatus> {
  String selectedOrderStatus;
  List finalStatusOption = [
    "Active",
    "Inactive",
  ];

  updateFinalOrderStatus() async {
    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateFinalOrderStatus.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['order_id'] = widget.order_id;
    request.fields['final_status'] = selectedOrderStatus;

    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Final order status has been updated successfully.",
          toastLength: Toast.LENGTH_LONG);
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
    if(widget.finalOrder_status != null) {
      selectedOrderStatus = widget.finalOrder_status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleName: "Update Final Order Status",
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
                      title: "Final Order Status",
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
                      hint: Text("Select final order status"),
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
                      items: finalStatusOption.map((valueItem) {
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
                          if(selectedOrderStatus == "Inactive") {
                            Fluttertoast.showToast(
                                msg: "Final order status is inactive already.",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                          else {
                            updateFinalOrderStatus();
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
