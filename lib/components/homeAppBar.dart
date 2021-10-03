import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/models/product.dart';
import 'package:instrubuy/screens/cart_screen.dart';
import 'package:instrubuy/screens/detail_screen.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class HomeAppBar extends StatefulWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ParentModel>(
        builder: (BuildContext context, Widget child, ParentModel parentModel) {
      return AppBar(
        centerTitle: true,
        title: Text(
          "InstruBUY",
          style: TextStyle(
            color: kTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/menu.svg",
            height: SizeConfig.defaultSize * 2, //20
            color: kTitleColor,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
              height: SizeConfig.defaultSize * 2,
              color: kTitleColor,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate:
                      ProductSearch(finalProduct: parentModel.listOfProducts));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: kTitleColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.id);
            },
          ),
          SizedBox(
            width: SizeConfig.defaultSize,
          )
        ],
      );
    });
  }
}

class ProductSearch extends SearchDelegate<Product> {
  // List of Product generic data type is passed to finalProduct when search button is clicked.
  final List<Product> finalProduct;
  ProductSearch({this.finalProduct});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      query,
      style: TextStyle(fontSize: 20.0),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // p is an instance(every row) of the list.
    final myList = query.isEmpty
        ? finalProduct
        : finalProduct
            .where((p) => p.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? Center(
            child: Text(
            "No results found.",
            style: TextStyle(fontSize: 18),
          ))
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Product listItem = myList[index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DetailScreen.id,
                    arguments: ProductDetailsArguments(
                      product: finalProduct
                          .where((p) => p.title
                              .toLowerCase()
                              .startsWith(query.toLowerCase()))
                          .toList()[index],
                    ),
                  );
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listItem.title,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize / 2,
                    ),
                    Text(
                      "Rs. " + listItem.price.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize,
                    ),
                  ],
                ),
              );
            });
  }
}
