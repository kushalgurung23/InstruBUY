import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instrubuy/components/categoryProducts.dart';
import 'package:instrubuy/components/drumProducts.dart';
import 'package:instrubuy/components/otherProducts.dart';
import 'package:instrubuy/components/pianoProducts.dart';
import 'package:instrubuy/components/ukuleleProducts.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/screens/detail_screen.dart';
import 'package:instrubuy/screens/selectedProducts.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';

double defaultSize = SizeConfig.defaultSize;

class ProductData extends StatefulWidget {
  @override
  _ProductDataState createState() => _ProductDataState();
}

class _ProductDataState extends State<ProductData> {

  List<Product> _products = [];
  List<Product> get product {
    return List.from(_products);
  }

  Future allProduct() async {
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

    return json.decode(response.body);
  }

  Future categoryProduct() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/product_category.php";
    var response = await http.get(url);

    return json.decode(response.body);
  }

  String totalDrumCount;
  String totalPianoCount;
  String totalUkuleleCount;
  String totalOtherCount;

  Future drumCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/drum_count.php";
    var response = await http.get(url);
    totalDrumCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future pianoCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/piano_count.php";
    var response = await http.get(url);
    totalPianoCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future ukuleleCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/ukulele_count.php";
    var response = await http.get(url);
    totalUkuleleCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  Future otherCount() async {
    var url =
        "https://instrubuy.000webhostapp.com/instrubuy_products/other_count.php";
    var response = await http.get(url);
    totalOtherCount = await json.decode(response.body)[0]['count(*)'];
    return json.decode(response.body)[0]['count(*)'];
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    Orientation orientation = _mediaQueryData.orientation;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(defaultSize * 2),
          child: TitleText(
            title: "Browse by Categories",
            color: kTitleColor,
          ),
        ),
        Container(
          height: defaultSize * 30,
          child: FutureBuilder(
              future: categoryProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          List list = snapshot.data;
                          // Calling category methods to get total product count of four categories.
                          drumCount();
                          pianoCount();
                          ukuleleCount();
                          otherCount();
                          return Row(
                            children: [
                              // Four Category Products
                              CategoryProducts(
                                  image:
                                      "https://instrubuy.000webhostapp.com/instrubuy_images/${list[0]['category_image']}",
                                  category_name: list[0]['category_name'],
                                  textWidget: FutureBuilder(
                                    future: drumCount(),
                                    builder: (context, snapshot) {
                                      var value = (snapshot.connectionState ==
                                              ConnectionState.done
                                          ? '${totalDrumCount}'
                                          : '0');
                                      return Text(
                                        value + " products",
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectedProducts(
                                          title: "Drum Products",
                                          selectedProducts: DrumProducts(),
                                        ),
                                      ),
                                    );
                                  }),
                              CategoryProducts(
                                  image:
                                      "https://instrubuy.000webhostapp.com/instrubuy_images/${list[1]['category_image']}",
                                  category_name: list[1]['category_name'],
                                  textWidget: FutureBuilder(
                                    future: pianoCount(),
                                    builder: (context, snapshot) {
                                      var value = (snapshot.connectionState ==
                                              ConnectionState.done
                                          ? '${totalPianoCount}'
                                          : '0');
                                      return Text(
                                        value + " products",
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectedProducts(
                                          title: "Piano Products",
                                          selectedProducts: PianoProducts(),
                                        ),
                                      ),
                                    );
                                  }),
                              CategoryProducts(
                                  image:
                                      "https://instrubuy.000webhostapp.com/instrubuy_images/${list[2]['category_image']}",
                                  category_name: list[2]['category_name'],
                                  textWidget: FutureBuilder(
                                    future: ukuleleCount(),
                                    builder: (context, snapshot) {
                                      var value = (snapshot.connectionState ==
                                              ConnectionState.done
                                          ? '${totalUkuleleCount}'
                                          : '0');
                                      return Text(
                                        value + " products",
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectedProducts(
                                          title: "Guitar and Ukulele Products",
                                          selectedProducts: UkuleleProducts(),
                                        ),
                                      ),
                                    );
                                  }),
                              CategoryProducts(
                                  image:
                                      "https://instrubuy.000webhostapp.com/instrubuy_images/${list[3]['category_image']}",
                                  category_name: list[3]['category_name'],
                                  textWidget: FutureBuilder(
                                    future: otherCount(),
                                    builder: (context, snapshot) {
                                      var value = (snapshot.connectionState ==
                                              ConnectionState.done
                                          ? '${totalOtherCount}'
                                          : '0');
                                      return Text(
                                        value + " products",
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectedProducts(
                                          title: "Other Products",
                                          selectedProducts: OtherProducts(),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                          backgroundColor: kPrimaryLightColor,
                        ),
                      );
              }),
        ),
        Padding(
          padding: EdgeInsets.all(defaultSize * 2),
          child: TitleText(
            title: "Recommended For You",
            color: kTitleColor,
          ),
        ),
        // Main products
        Container(
          child: FutureBuilder(
              future: allProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              List list = snapshot.data;
                              return Padding(
                                padding: EdgeInsets.all(defaultSize * 1.5),
                                child: GridView.count(
                                  mainAxisSpacing: 20.0,
                                  //distance between each product row to another row
                                  crossAxisSpacing: 20.0,
                                  //distance between two products of a row
                                  childAspectRatio: 0.6,
                                  // It does not let the user scroll the products
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount:
                                      orientation == Orientation.landscape
                                          ? 3
                                          : 2,
                                  scrollDirection: Axis.vertical,
                                  //shrinkWrap is a constructor for creating a scrollable for large number of children.
                                  shrinkWrap: true,
                                  children: [
                                    ...List.generate(
                                      snapshot.data.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            DetailScreen.id,
                                            arguments: ProductDetailsArguments(
                                              product: product[index],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: defaultSize * 45, //145
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [Colors.deepPurpleAccent, Colors.blue]),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 0.3,
                                            child: Column(
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 0.85,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://instrubuy.000webhostapp.com/instrubuy_images/${list[index]['image_location']}",
                                                    placeholder:
                                                        (context, url) =>
                                                            Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  defaultSize *
                                                                      8.5,
                                                              horizontal:
                                                                  defaultSize *
                                                                      7),
                                                      child:
                                                          new CircularProgressIndicator(
                                                        color: kPrimaryColor,
                                                        backgroundColor:
                                                            kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: defaultSize),
                                                  child: TitleText(
                                                    title: list[index]['title'],
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: defaultSize / 2,
                                                ),
                                                Text(
                                                  "Rs. " + list[index]['price'],
                                                  style: TextStyle(
                                                    color: kPrimaryLightColor,
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: defaultSize * 10),
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                            backgroundColor: kPrimaryLightColor,
                          ),
                        ),
                      );
              }),
        ),
      ],
    );
  }
}
