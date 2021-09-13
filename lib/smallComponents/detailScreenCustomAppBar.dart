import 'package:flutter/material.dart';
import 'package:instrubuy/buttons/roundedIconButton.dart';
import 'package:instrubuy/components/cartNumber.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

class DetailScreenCustomAppBar extends PreferredSize {

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "InstruBUY",
        style: TextStyle(
          color: kTitleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(5),
          vertical: getProportionateScreenWidth(2),),
        child: Padding(
          padding: EdgeInsets.only(left: 6, top: 2),
          child: RoundedIconButton(
            iconData: Icons.arrow_back_ios,
            press: () {
              // It will set the value of quantity = 1 in detail screen
              CartQuantity.cartQuantity = 1;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
