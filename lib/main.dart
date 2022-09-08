import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/product_screen.dart';
import 'package:shop/widgets/auth_or_home_screen.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //

  _getRoutes(BuildContext ctx) {
    return {
      AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
      AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
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
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(null, []),
          update: (context, auth, previewsProdutcs) => new Products(
            auth.token,
            previewsProdutcs!.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(null, []),
          update: (context, auth, previewsOrders) => new Orders(
            auth.token,
            previewsOrders!.items,
          ),
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
            headline1: TextStyle(
              color: Colors.white,
            ),
            caption: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: AppRoutes.AUTH_HOME,
        routes: _getRoutes(context),
      ),
    );
  }
}
