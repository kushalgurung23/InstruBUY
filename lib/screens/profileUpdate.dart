import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instrubuy/Drawer/Profile.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/smallComponents/ProfileInputTextField.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';

double defaultSize = SizeConfig.defaultSize;

class ProfileUpdate extends StatefulWidget {
  static const String id = 'profile.dart';

  final String fullName, address, emailAddress, image;

  ProfileUpdate({this.fullName, this.address, this.emailAddress, this.image});

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  SharedPreferences preferences;
  String yourCustomer_id,
      yourImage,
      yourFullName,
      yourAddress,
      yourEmailAddress,
      yourPassword;

  void initial() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      yourCustomer_id = preferences.getString('customer_id');
      yourFullName = preferences.getString('full_name');
      yourAddress = preferences.getString('address');
      yourEmailAddress = preferences.getString('email_address');
      yourPassword = preferences.getString('password');
      yourImage = preferences.getString('image');
    });
  }

  bool showPassword = true;
  File _image;

  // For setting new image name in shared preference.
  String newUserImage;
  final picker = ImagePicker();

  TextEditingController fullNameText;
  TextEditingController addressText;
  TextEditingController emailAddressText;

  @override
  void initState() {
    // Calling initial() method to get the preference details of the customer.
    initial();

    fullNameText = TextEditingController(text: '');
    addressText = TextEditingController(text: '');
    emailAddressText = TextEditingController(text: '');

    // Assigning the profile values to our text fields in profile update UI.
    if (widget.fullName != null &&
        widget.address != null &&
        widget.emailAddress != null) {
      fullNameText.text = widget.fullName;
      addressText.text = widget.address;
      emailAddressText.text = widget.emailAddress;
    }
    super.initState();
  }

  Future selectImage(ImageSource source) async {
    var pickedImage = await picker.getImage(source: source);
    setState(() {
      _image = File(pickedImage.path);
      newUserImage = _image.path.split('/').last;
      //debugPrint("New user image: "+ newUserImage.toString());
    });
  }

  void imageIncluded() async {

    Map withImageMapData;

    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_profile/updateProfile.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['customer_id'] = yourCustomer_id;
    request.fields['full_name'] = fullNameText.text;
    request.fields['address'] = addressText.text;
    request.fields['email_address'] = emailAddressText.text;

    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    print("The image value is: $pic");
    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Profile updated successfully.",
          toastLength: Toast.LENGTH_SHORT);

      preferences.setString('full_name', fullNameText.text);
      preferences.setString('address', addressText.text);
      preferences.setString('email_address', emailAddressText.text);
      preferences.setString('image', newUserImage);

      withImageMapData = {"fullName": fullNameText.text, "address": addressText.text, "emailAddress": emailAddressText.text, "image": newUserImage};

      Navigator.of(context).pop(withImageMapData);

    } else {
      Fluttertoast.showToast(
          msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
    }
  }

  void imageNotIncluded() async {
    Map noImageMapData;
    final uri = Uri.parse(
        "https://instrubuy.000webhostapp.com/instrubuy_profile/noImageProfileUpdate.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['customer_id'] = yourCustomer_id;
    request.fields['full_name'] = fullNameText.text;
    request.fields['address'] = addressText.text;
    request.fields['email_address'] = emailAddressText.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Profile updated successfully.",
          toastLength: Toast.LENGTH_SHORT);

      preferences.setString('full_name', fullNameText.text);
      preferences.setString('address', addressText.text);
      preferences.setString('email_address', emailAddressText.text);

      noImageMapData = {"fullName": fullNameText.text, "address": addressText.text, "emailAddress": emailAddressText.text, "image": null};

      Navigator.pop(context, noImageMapData);
    } else {
      Fluttertoast.showToast(
          msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Change Profile",
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
              left: defaultSize * 1.8,
              top: defaultSize * 2.5,
              right: defaultSize * 1.8),
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
                            image: _image == null
                                ? NetworkImage(
                                    "https://instrubuy.000webhostapp.com/instrubuy_images/${widget.image}")
                                : FileImage(File(_image.path)),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white),
                            color: kPrimaryColor,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(right: 0),
                            iconSize: SizeConfig.defaultSize * 2.5,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => imageOption()));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 2.5,
                ),
                ProfileInputTextField(
                  labelText: "Full Name",
                  placeHolder: "Your Full Name",
                  isPasswordTextField: false,
                  textEditingController: fullNameText,
                  textEnable: true,
                ),
                ProfileInputTextField(
                  labelText: "Address",
                  placeHolder: "Your Address",
                  isPasswordTextField: false,
                  textEditingController: addressText,
                  textEnable: true,
                ),
                ProfileInputTextField(
                  labelText: "Email Address",
                  placeHolder: "Your Email Address",
                  isPasswordTextField: false,
                  textEditingController: emailAddressText,
                  textEnable: true,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: defaultSize),
                  child: Container(
                    height: defaultSize * 6,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          elevation: 1.0,
                          backgroundColor: kPrimaryColor,
                          //side: BorderSide(color: kPrimaryLightColor),
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultSize * 2),
                          )),
                      onPressed: () {
                        setState(() {
                          if (_image != null) {
                            imageIncluded();
                          } else {
                            imageNotIncluded();
                          }
                        });
                      },
                      child: Text(
                        "UPDATE",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Padding(
//                      padding: EdgeInsets.only(bottom: defaultSize),
//                      child: OutlinedButton(
//                        style: OutlinedButton.styleFrom(
//                            elevation: 1.0,
//                            backgroundColor: Colors.white24,
//                            //side: BorderSide(color: kPrimaryLightColor),
//                            padding: EdgeInsets.symmetric(horizontal: 50.0),
//                            shape: RoundedRectangleBorder(
//                              borderRadius:
//                                  BorderRadius.circular(defaultSize * 2),
//                            )),
//                        onPressed: () {
//                          Navigator.pop(context);
//                        },
//                        child: Text(
//                          "Cancel",
//                          style: TextStyle(
//                              fontSize: 14,
//                              letterSpacing: 2.2,
//                              color: Colors.black),
//                        ),
//                      ),
//                    ),
//
//                  ],
//                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageOption() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultSize * 2,
        vertical: SizeConfig.defaultSize * 2,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () => selectImage(ImageSource.camera),
                icon: Icon(Icons.camera, color: Colors.black),
                label: Text("Camera", style: TextStyle(color: Colors.black)),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () => selectImage(ImageSource.gallery),
                icon: Icon(Icons.image, color: Colors.black),
                label: Text("Gallery", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
