import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/customAppBar.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';

double defaultSize = SizeConfig.defaultSize;

class SelectedProducts extends StatefulWidget {
  static const String id = "selectedProducts.dart";
  //final ParentModel parentModel;
  final String title;
  final Widget selectedProducts;

  SelectedProducts({@required this.selectedProducts, @required this.title});

  @override
  _SelectedProductsState createState() => _SelectedProductsState();
}

class _SelectedProductsState extends State<SelectedProducts> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleName: "InstruBUY",
          onPress: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ProductCategories(),
              Padding(
                padding: EdgeInsets.all(defaultSize * 2),
                child: Center(
                  child: TitleText(
                    title: widget.title.toString().toUpperCase(),
                    color: kTitleColor,
                  ),
                ),
              ),
              widget.selectedProducts,
            ],
          ),
        ),
      ),
    );
  }
}
