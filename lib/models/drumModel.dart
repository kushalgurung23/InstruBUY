import 'dart:convert';
import 'package:instrubuy/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
// http is used to make it easy for us to use http classes
import 'package:http/http.dart' as http;

// Model is a pre-defined base class that holds some data and allows other classes to listen to changes to that data.
class DrumModel extends Model {
  List<Product> _drumProducts = [];

  // When scoped_model is used, we are using the same list so it won't affect the children list
  List<Product> get drumProducts{
    return List.from(_drumProducts);
  }

  List<Map<String, dynamic>> drumValue = [];

  void fetchDrumProducts() {

    http.get("https://instrubuy.000webhostapp.com/instrubuy_products/drum_products.php").then((http.Response response) {
      final List fetchedData = json.decode(response.body);
      //print(fetchedData);

      final List<Product> fetchedDrumProduct = [];
      // Separating each product from the list of fetched data
      // we will get map value which consists of key and value pair
      fetchedData.forEach((data) {
        //print(data);
        drumValue.add(data);

        Product product = Product(
          product_id: double.parse(data["product_id"]),
          title: data["title"],
          price: double.parse(data["price"]),
          image_location: data["image_location"],
          category_id: data["category_id"],
          description: data["description"],
        );

        fetchedDrumProduct.add(product);
      });

      _drumProducts = fetchedDrumProduct;
      print("Drum Products ${_drumProducts.length}");
    });

  }

}