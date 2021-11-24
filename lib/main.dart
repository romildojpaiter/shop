import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/product_detail.dart';
import 'package:shop/views/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //

  _getRoutes(BuildContext ctx) {
    return {
      AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetail(),
      AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Products>(
      create: (_) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        initialRoute: AppRoutes.HOME,
        routes: _getRoutes(context),
      ),
    );
  }
}
