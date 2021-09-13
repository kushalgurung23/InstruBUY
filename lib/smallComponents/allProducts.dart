import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/categoryCard.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:instrubuy/models/product.dart';

class AllProducts extends StatefulWidget {
//  final int index;
  final GestureTapCallback press;
//  final List list;
  final Product product;

//  final List<String> image_location;

  AllProducts({
    this.press,
    this.product,
  });

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        width: defaultSize * 45, //145
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurpleAccent, Colors.blue]),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: AspectRatio(
          aspectRatio: 0.3,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 0.85,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://instrubuy.000webhostapp.com/instrubuy_images/${widget.product.image_location}",
                  placeholder: (context, url) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultSize * 8.5,
                        horizontal: defaultSize * 7),
                    child: new CircularProgressIndicator(
                      color: kPrimaryColor,
                      backgroundColor: kPrimaryLightColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              //fit: BoxFit.cover,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultSize),
                child: TitleText(
                  title: widget.product.title.toString(),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: defaultSize / 2,
              ),
              Text(
                "Rs. " + (widget.product.price.toInt()).toString(),
                style: TextStyle(
                  color: kPrimaryLightColor,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
