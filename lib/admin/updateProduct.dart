import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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

class UpdateProduct extends StatefulWidget {
  static const String id = "updateProduct.dart";

  final List list;
  final int index;

  UpdateProduct({this.list, this.index});

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  File _image;
  String oldImage;
  final picker = ImagePicker();

  bool editMode = false;

  TextEditingController titleText;
  TextEditingController priceText;
  TextEditingController product_quantityText;
  TextEditingController descriptionText;

  @override
  void initState() {
    // TODO: implement initState
    titleText = TextEditingController(text: '');
    priceText = TextEditingController(text: '');
    product_quantityText = TextEditingController(text: '');
    descriptionText = TextEditingController(text: '');

    if (widget.index != null) {
      titleText.text = widget.list[widget.index]['title'];
      priceText.text = widget.list[widget.index]['price'];
      product_quantityText.text = widget.list[widget.index]['product_quantity'];
      descriptionText.text = widget.list[widget.index]['description'];
      selectedValue = widget.list[widget.index]['category_id'];
      oldImage = widget.list[widget.index]['image_location'];
    }
    super.initState();
  }

  updateData() async {
    // It includes new image of the product
    if (_image != null) {
      final uri = Uri.parse(
          "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/updateProducts.php");
      var request = http.MultipartRequest('POST', uri);

      request.fields['product_id'] = widget.list[widget.index]['product_id'];
      request.fields['titleText'] = titleText.text;
      request.fields['priceText'] = priceText.text;
      request.fields['product_quantityText'] = product_quantityText.text;
      request.fields['descriptionText'] = descriptionText.text;
      request.fields['category_id'] = selectedValue.toString();

      var pic = await http.MultipartFile.fromPath("image", _image.path);
      request.files.add(pic);
      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Product updated successfully.",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushNamed(context, AdminAllProducts.id);
      } else {
        Fluttertoast.showToast(
            msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
      }
    }
    // If no new image of product is selected by admin
    else {
      final uri = Uri.parse(
          "https://instrubuy.000webhostapp.com/instrubuy_adminPanel/noImageUpdateProducts.php");
      var request = http.MultipartRequest('POST', uri);

      request.fields['product_id'] = widget.list[widget.index]['product_id'];
      request.fields['titleText'] = titleText.text;
      request.fields['priceText'] = priceText.text;
      request.fields['product_quantityText'] = product_quantityText.text;
      request.fields['descriptionText'] = descriptionText.text;
      request.fields['category_id'] = selectedValue.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Product updated successfully.",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.pushNamed(context, AdminAllProducts.id);
      } else {
        Fluttertoast.showToast(
            msg: "Please try again.", toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  Future selectImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
      print("Value of selected new image: " + _image.toString());
    });
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
          titleName: "Update Product",
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
                  child: _image != null
                      ? Image.file(_image)
                      : CachedNetworkImage(
                          imageUrl:
                              "https://instrubuy.000webhostapp.com/instrubuy_images/${oldImage}",
                          placeholder: (context, url) => Center(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.defaultSize),
                            child: new Text(
                              "Loading...",
                              style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 2),
                            ),
                          )),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
                  child: ExtendedFlatButton(
                    buttonName: "Update Product",
                    onPress: () {
                      setState(() {
                        if (priceText.text.length > 7) {
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
                          updateData();
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
