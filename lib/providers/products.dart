import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final _url = 'flutter-paiterdigital-default-rtdb.firebaseio.com';
  List<Product> _items = [];

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

  /**
   * Carrega os produtos vindo do firebase.
   * Obs.: await aguarda a resposta da requisição
   */
  Future<void> loadProducts() async {
    var _uri = Uri.https(_url, "/products.json");
    final response = await http.get(_uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite: productData['isFavorite'] ?? false,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    var _uri = Uri.https(_url, "/products.json");
    final response = await http.post(_uri, body: jsonEncode(newProduct));
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
