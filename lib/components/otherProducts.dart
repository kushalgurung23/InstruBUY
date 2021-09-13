import 'package:flutter/material.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/screens/detail_screen.dart';
import 'package:instrubuy/smallComponents/allProducts.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:scoped_model/scoped_model.dart';

double defaultSize = SizeConfig.defaultSize;

class OtherProducts extends StatefulWidget {
  @override
  _OtherProductsState createState() => _OtherProductsState();
}

class _OtherProductsState extends State<OtherProducts> {
  @override
  Widget build(BuildContext context) {
    // ScopedModelDescendant is generic type, so ParentModel mixin class is passed.
    return ScopedModelDescendant<ParentModel>(
      // ScopedModelDescendant class expect BuildContext, widget and model
      builder: (BuildContext context, Widget child, ParentModel parentModel) {
        return Padding(
          padding: EdgeInsets.all(defaultSize * 1.5),
          child: GridView.count(
            mainAxisSpacing:
                20.0, //distance between each product row to another row
            crossAxisSpacing: 20.0, //distance between two products of a row
            childAspectRatio: 0.6,
            //It does not let the user scroll the products
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            //shrinkWrap is a constructor for creating a scrollable for large number of children.
            shrinkWrap: true,
            children: [
              ...List.generate(
                parentModel.otherValue.length,
                (index) => AllProducts(
                  product: parentModel.otherProducts[index],
                  press: () => Navigator.pushNamed(context, DetailScreen.id,
                      arguments: ProductDetailsArguments(
                        product: parentModel.otherProducts[index],
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
