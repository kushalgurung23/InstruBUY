import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/profileUpdate.dart';
import 'package:instrubuy/smallComponents/ProfileInputTextField.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:kf_drawer/kf_drawer.dart';

class Profile extends StatefulWidget {
  static const String id = 'profile.dart';

  final String fullName, address, emailAddress, image;

  Profile(
      {this.fullName,
      this.address,
      this.emailAddress,
      this.image});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController fullNameText;
  TextEditingController addressText;
  TextEditingController emailAddressText;

  @override
  void initState() {
    // TODO: implement initState
    fullNameText = TextEditingController(text: '');
    addressText = TextEditingController(text: '');
    emailAddressText = TextEditingController(text: '');

    if (widget.fullName != null &&
        widget.address != null &&
        widget.emailAddress != null) {
      fullNameText.text = widget.fullName;
      addressText.text = widget.address;
      emailAddressText.text = widget.emailAddress;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Same color as the background of the page.
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.id);
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10)),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://instrubuy.000webhostapp.com/instrubuy_images/${widget.image}"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 2.5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 11),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        elevation: 1.0,
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.zero,
                        shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileUpdate(
                                fullName: widget.fullName,
                                address: widget.address,
                                emailAddress: widget.emailAddress,
                                image: widget.image,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: SizeConfig.defaultSize,
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 2,
                ),
                ProfileInputTextField(
                  labelText: "Full Name",
                  placeHolder: "Your Full Name",
                  isPasswordTextField: false,
                  textEditingController: fullNameText,
                  textEnable: false,
                ),
                ProfileInputTextField(
                  labelText: "Address",
                  placeHolder: "Your Address",
                  isPasswordTextField: false,
                  textEditingController: addressText,
                  textEnable: false,
                ),
                ProfileInputTextField(
                  labelText: "Email Address",
                  placeHolder: "Your Email Address",
                  isPasswordTextField: false,
                  textEditingController: emailAddressText,
                  textEnable: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
