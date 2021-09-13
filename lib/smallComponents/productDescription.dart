import 'package:flutter/material.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class ProductDescription extends StatelessWidget {
  final Product product;

  ProductDescription({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
          child: Text(
            product.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: defaultSize * 2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
          child: Text(
            product.description,
            style: TextStyle(
              color: kPrimaryLightColor,
            ),
          ),
        ),
      ],
    );
  }
}
