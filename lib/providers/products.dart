import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  /**
   * Recupera o items de lementos no carrinho.
   */
  int get itemsCount {
    return _items.length;
  }

  List<Product> itemsFavorite(bool isFavorite) {
    return isFavorite
        ? _items.where((prod) => prod.isFavorite).toList()
        : items;
  }

  void addProduct(Product newProduct) {
    _items.add(Product(
        id: Random().nextDouble().toString(),
        title: newProduct.title,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price));
    // Sempre que realizado um mudança notificamos os envolvidos com método abaixo
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id != null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}
