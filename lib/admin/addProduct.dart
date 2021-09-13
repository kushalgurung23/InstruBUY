import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instrubuy/admin/adminAllProducts.dart';
import 'package:instrubuy/buttons/extendedFlatButton.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/inputTextField.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:http/http.dart' as http;

class AddProductScreen extends StatefulWidget {
  static const String id = "addProduct.dart";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File _image;
  final picker = ImagePicker();

  bool editMode = false;

  TextEditingController titleText = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController product_quantityText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  Future selectImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future addProduct() async {
    // If image is provided
    if (_image != null) {
      final uri = Uri.parse(
          "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/addProducts.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields['title'] = titleText.text;
      request.fields['price'] = priceText.text;
      request.fields['quantity'] = product_quantityText.text;
      request.fields['description'] = descriptionText.text;
      request.fields['category_id'] = selectedValue.toString();

      var pic = await http.MultipartFile.fromPath("image", _image.path);
      request.files.add(pic);
      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Product added successfully.",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushNamed(context, AdminAllProducts.id);
      } else {
        Fluttertoast.showToast(
            msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {});
      // If image is not provided
    } else {
      Fluttertoast.showToast(
          msg: "Please provide image of the product.",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  String selectedValue;
  List listItem = [
    "01 Drum Set",
    "02 Piano",
    "03 Guitar and Ukulele",
    "04 Others"
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "Add Product",
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
                  hintText: "Product Name",
                  onChanged: (value) {},
                  textEditingController: titleText,
                ),
                InputTextField(
                  textInputType: TextInputType.number,
                  textInputFormatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Price",
                  onChanged: (value) {},
                  textEditingController: priceText,
                ),
                InputTextField(
                  textInputType: TextInputType.number,
                  textInputFormatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: "Quantity",
                  onChanged: (value) {},
                  textEditingController: product_quantityText,
                ),
                InputTextField(
                  containerSize: SizeConfig.defaultSize * 15,
                  hintText: "Description",
                  onChanged: (value) {},
                  textEditingController: descriptionText,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      hint: Text("Select Category: "),
                      dropdownColor: Colors.blueGrey[100],
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    selectImage();
                  },
                ),
                Container(
                  child: _image == null
                      ? Text('No image selected')
                      : Image.file(_image),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
                  child: ExtendedFlatButton(
                    buttonName: "Add Product",
                    onPress: () {
                      setState(() {
                        if (titleText.text.toString() == '' ||
                            priceText.text.toString() == '' ||
                            product_quantityText.text.toString() == '' ||
                            descriptionText.text.toString() == '' ||
                            selectedValue == null) {
                          Fluttertoast.showToast(
                              msg: "Please provide all details.",
                              toastLength: Toast.LENGTH_SHORT);
                        } else if (priceText.text.length > 7) {
                          Fluttertoast.showToast(
                              msg:
                                  "Price of the product must be of less than 8 digits.",
                              toastLength: Toast.LENGTH_LONG);
                        } else if (product_quantityText.text.length > 9) {
                          Fluttertoast.showToast(
                              msg:
                                  "Quantity of the product must be of less than 10 digits.",
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          addProduct();
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
