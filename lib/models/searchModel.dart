import 'dart:convert';
import 'package:instrubuy/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class SearchModel extends Model {
  List<Product> _products = [];

  List<Product> get listOfProducts {
    return List.from(_products);
  }

  void searchProducts() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/all_products.php";
    var response = await http.get(url);

    final List fetchedData = json.decode(response.body);
    final List<Product> fetchedProductItems = [];

    fetchedData.forEach((data) {
      // Assigning values of Product's properties with fetched data
      Product product = Product(
        product_id: double.parse(data["product_id"]),
        title: data["title"],
        price: double.parse(data["price"]),
        image_location: data["image_location"],
        category_id: data["category_id"],
        description: data["description"],
      );

      fetchedProductItems.add(product);
    });

    _products = fetchedProductItems;
  }
}