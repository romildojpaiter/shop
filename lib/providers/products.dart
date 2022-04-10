import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

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

  Future<void> addProduct(Product newProduct) async {
    const _url = 'flutter-paiterdigital-default-rtdb.firebaseio.com';
    var _uri = Uri.https(_url, "/products.json");

    return http.post(_uri, body: jsonEncode(newProduct)).then(
      (response) {
        if (response.statusCode == 200) {
          _items.add(Product(
              id: jsonDecode(response.body)['name'],
              title: newProduct.title,
              description: newProduct.description,
              imageUrl: newProduct.imageUrl,
              price: newProduct.price));
          // Sempre que realizado um mudança notificamos os envolvidos com método abaixo
          notifyListeners();
        }
      },
    );
    // Estratégia de capturar erros e tratar em tela!
    // .catchError((error) {
    //   print(error);
    //   throw error;
    // });
  }

  void updateProduct(Product product) {
    print(_items);
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      print('update product ${index}');
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
