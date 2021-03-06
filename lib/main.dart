import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/product_overview_screen.dart';
import 'package:shop/views/product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //

  _getRoutes(BuildContext ctx) {
    return {
      AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
      AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
      AppRoutes.CART: (ctx) => CartScreen(),
      AppRoutes.ORDERS: (ctx) => OrdersScreen(),
      AppRoutes.PRODUCTS: (ctx) => ProductScreeen(),
      AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
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
        ChangeNotifierProvider(
          create: (_) => new Orders(),
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
