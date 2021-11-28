import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order(
      {required this.id,
      required this.total,
      required this.products,
      required this.date});
}

class Orders extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double total) {
    // final combine = (t, i) => t + (i.price * i.quantity);
    // final totalp = products.fold(0.0, combine);
    _orders.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: total,
        products: products,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
