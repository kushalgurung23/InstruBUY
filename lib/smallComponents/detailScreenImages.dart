import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class DetailScreenImages extends StatefulWidget {
  final Product product;

  DetailScreenImages({this.product});

  @override
  _DetailScreenImagesState createState() => _DetailScreenImagesState();
}

class _DetailScreenImagesState extends State<DetailScreenImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Image.network("https://instrubuy.000webhostapp.com/instrubuy_images/${widget.product.image_location}"),
          ),
        ),
      ],
    );
  }
}
