import 'package:flutter/material.dart';

class Product {
  final double product_id, price;
  final String title, description, image_location, category_id;
//  final List<String> images;

  Product({
    this.product_id,
    this.title,
    this.price,
    this.image_location,
    this.description,
    this.category_id,
  });
}
