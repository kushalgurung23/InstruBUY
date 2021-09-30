import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instrubuy/admin/adminAllProducts.dart';
import 'package:instrubuy/admin/adminList.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/inputTextField.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(p);

class UpdateAdmin extends StatefulWidget {
  final List list;
  final int index;

  UpdateAdmin({this.list, this.index});

  @override
  _UpdateAdminState createState() => _UpdateAdminState();
}

class _UpdateAdminState extends State<UpdateAdmin> {
  TextEditingController emailAddressController, positionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAddressController = new TextEditingController();
    positionController = new TextEditingController();

    if (widget.index != null) {
      emailAddressController.text = widget.list[widget.index]['email_address'];
      positionController.text = widget.list[widget.index]['position'];
    }
  }

  updateAdmin() async {
    if (widget.list[widget.index]['email_address'] ==
            emailAddressController.text &&
        widget.list[widget.index]['position'] == positionController.text) {
      Navigator.pop(context);
    } else {
      Map mapData;

      final uri = Uri.parse(
          "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateAdmin.php");
      var request = http.MultipartRequest('POST', uri);

      request.fields['admin_id'] = widget.list[widget.index]['admin_id'];
      request.fields['email_address'] = emailAddressController.text;
      request.fields['position'] = positionController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        mapData = {
          "email_address": emailAddressController.text,
          "position": positionController.text
        };
        Navigator.pop(context, mapData);
        Fluttertoast.showToast(
            msg: "Updated successfully.", toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(
            msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "Update Admin",
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
                InputTextField(
                  hintText: "Email Address",
                  onChanged: (value) {},
                  textEditingController: emailAddressController,
                ),
                InputTextField(
                  hintText: "Position",
                  onChanged: (value) {},
                  textEditingController: positionController,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
                  child: ExtendedFlatButton(
                    buttonName: "Update Admin",
                    onPress: () {
                      setState(() {
                        if (!regExp
                            .hasMatch(emailAddressController.text.toString())) {
                          Fluttertoast.showToast(
                              msg: "Please enter correct email address.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else {
                          updateAdmin();
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
