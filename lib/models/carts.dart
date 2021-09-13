import 'package:flutter/material.dart';
import 'package:instrubuy/models/product.dart';

class Carts {
  final double cart_id, numberOfItems, customer_id, price;
  final String productName, image_location;

  Carts({@required this.cart_id, @required this.customer_id, @required this.numberOfItems, @required this.image_location, @required this.productName, @required this.price});
}
