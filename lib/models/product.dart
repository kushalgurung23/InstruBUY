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

const String description = "A premium Drum Set made for all the drum set lovers.";

List<Product> loadProductItem() {
  var productItems = <Product> [
    Product(
      title: "Apple",
      price: 40,
    ),
    Product(
      title: "Biscuit",
      price: 20,
    ),
    Product(
      title: "Tea",
      price: 300,
    ),
    Product(
      title: "Lemonade",
      price: 160,
    ),
    Product(
      title: "Momo",
      price: 200,
    ),
  ];
  return productItems;
}