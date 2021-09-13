import 'package:flutter/material.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/smallComponents/constants.dart';

class CartNumber extends StatefulWidget {
  int numberOfItem = 1;
  @override
  _CartNumberState createState() => _CartNumberState();
}

class _CartNumberState extends State<CartNumber> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultSize * 2),
      child: Row(
        children: [
          Text(
            "Number of items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: defaultSize * 1.8,
              color: Colors.white,
            ),
          ),
          Spacer(),
          buildItemNumberButton(
            iconData: Icons.remove,
            onPress: () {
              if (widget.numberOfItem >= 2) {
                setState(() {
                  widget.numberOfItem--;
                  CartQuantity.cartQuantity = widget.numberOfItem;
                });
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(defaultSize),
            child: Text(
              //If the number of our item is a single digit, 0 will be added in front.
              widget.numberOfItem.toString().padLeft(2, "0"),
              style: TextStyle(
                color: kPrimaryLightColor,
                fontSize: 20,
              ),
            ),
          ),
          buildItemNumberButton(
            iconData: Icons.add,
            onPress: () {
              if (widget.numberOfItem > 0 && widget.numberOfItem <= 19) {
                setState(() {
                  widget.numberOfItem++;
                  CartQuantity.cartQuantity = widget.numberOfItem;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  SizedBox buildItemNumberButton({IconData iconData, Function onPress}) {
    return SizedBox(
      height: defaultSize * 3.5,
      width: defaultSize * 3.8,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: kPrimaryLightColor),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultSize * 2),
            )),
        onPressed: onPress,
        child: Icon(
          iconData,
          color: kPrimaryLightColor,
        ),
      ),
    );
  }
}

class CartQuantity {
  static int cartQuantity = 1;
}
