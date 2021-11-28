import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/product_detail.dart';
import 'package:shop/views/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //

  _getRoutes(BuildContext ctx) {
    return {
      AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetail(),
      AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
      AppRoutes.CART: (ctx) => CartScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
          primaryTextTheme: TextTheme(
            caption: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: AppRoutes.HOME,
        routes: _getRoutes(context),
      ),
    );
  }
}
