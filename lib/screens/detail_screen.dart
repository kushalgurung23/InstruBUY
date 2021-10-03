import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/components/detailScreenBody.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/smallComponents/detailScreenCustomAppBar.dart';

//Creating an argument class since we are using named route

class ProductDetailsArguments {
  // Here product will work as an argument.
  final Product product;

  // Index of the selected product is passed here as an argument.
  ProductDetailsArguments({  @required this.product});
}

class DetailScreen extends StatefulWidget {
  static const String id = "detail_screen.dart";

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    //ModalRoute is a route that block interaction with previous routes
    //settings = settings for this route
    //argument is the argument that is passed to this route
    final ProductDetailsArguments arguments =
        ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DetailScreenCustomAppBar(),
        // Product of a particular index will be passed as an argument to DetailScreenBody.
        body: DetailScreenBody(
          // Here product is an argument.
          product: arguments.product,
        ),
      ),
    );
  }
}
