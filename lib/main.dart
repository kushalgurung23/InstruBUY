// InstruBUY E-Commerce Application
// Last updated: October 03, 2021. 07:29 PM

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instrubuy/Drawer/Profile.dart';
import 'package:instrubuy/admin/addProduct.dart';
import 'package:instrubuy/admin/adminCustomerDetails.dart';
import 'package:instrubuy/admin/adminAllProducts.dart';
import 'package:instrubuy/admin/adminLogin.dart';
import 'package:instrubuy/admin/adminOrderDetails.dart';
import 'package:instrubuy/models/parentModel.dart';
import 'package:instrubuy/screens/deliveryDetails.dart';
import 'package:instrubuy/screens/detail_screen.dart';
import 'package:instrubuy/screens/home_screen.dart';
import 'package:instrubuy/screens/initial_screen.dart';
import 'package:instrubuy/screens/login_screen.dart';
import 'package:instrubuy/screens/orderScreen.dart';
import 'package:instrubuy/screens/payment.dart';
import 'package:instrubuy/screens/signUp_screen.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/screens/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:instrubuy/screens/cart_screen.dart';

var email;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Creating an instance of ProductModel
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ParentModel parentModel = ParentModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ParentModel>(
      // We assign the instance of ParentModel to the model property of ScopedModel
      model: parentModel,
      // MaterialApp is surrounded with ScopedModel, so that we can use our fetched data of our product model anywhere that we like.
      // Generic class
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InstruBUY',
        theme: ThemeData(
          //applying DM Sans as our default font
          //applying text color to all flutter textTheme
          textTheme:
              GoogleFonts.dmSansTextTheme().apply(displayColor: kTitleColor),
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0.0,
          ),
          //returns a visual density based on default target platforms
          visualDensity: VisualDensity.adaptivePlatformDensity,
          //scaffoldBackgroundColor: Color(0xFF647aa3),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: InitialScreen(parentModel: parentModel),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          DetailScreen.id: (context) => DetailScreen(),
          SplashScreen.id: (context) => SplashScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          CartScreen.id: (context) => CartScreen(),
          AdminAllProducts.id: (context) => AdminAllProducts(),
          AddProductScreen.id: (context) => AddProductScreen(),
          AdminLogin.id: (context) => AdminLogin(),
          Payment.id: (context) => Payment(),
          DeliveryDetails.id: (context) => DeliveryDetails(),
          AdminOrderDetails.id: (context) => AdminOrderDetails(),
          AdminCustomerDetails.id: (context) => AdminCustomerDetails(),
          CustomerOrderDetails.id: (context) => CustomerOrderDetails(),
          Profile.id: (context) => Profile(),
        },
      ),
    );
  }
}
