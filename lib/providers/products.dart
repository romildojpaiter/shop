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
        ? _items.where((element) => element.isFavorite).toList()
        : items;
  }

  void addProduct(Product product) {
    _items.add(product);
    // Sempre que realizado um mudança notificamos os envolvidos com método abaixo
    notifyListeners();
  }
}
