import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  get totalValue =>
      double.parse((this.price * this.quantity).toStringAsFixed(2));
}

class Cart with ChangeNotifier {
  // Inicializando o map
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  /**
   * Recupera o items de lementos no carrinho.
   */
  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return double.parse(total.toStringAsFixed(2));
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existentItem) => CartItem(
          id: existentItem.id,
          productId: product.id,
          title: existentItem.title,
          quantity: existentItem.quantity + 1,
          price: existentItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
