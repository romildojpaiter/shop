// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  //
  String? _token;
  String? _userId;
  List<Product> _items = [];

  // Constructor
  Products([this._token, this._userId, this._items = const []]);

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
    Map<String, String> params = {"auth": _token!};
    var _uri = Uri.https(Constantes.baseUrl, "/products.json", params);
    final responseProduct = await http.get(_uri);

    var _uriFav =
        Uri.https(Constantes.baseUrl, "/userFavorites/$_userId.json", params);
    final responseFav = await http.get(_uriFav);
    final favMap = jsonDecode(responseFav.body);
    print('Lista Fav: ${favMap}');
    Map<String, dynamic> data = jsonDecode(responseProduct.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    Map<String, String> params = {"auth": _token!};
    var _uri = Uri.https(Constantes.baseUrl, "/products.json", params);
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

  Future<void> updateProduct(Product product) async {
    Map<String, String> params = {"auth": _token!};

    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      var _uri =
          Uri.https(Constantes.baseUrl, "/products/${product.id}.json", params);
      await http.patch(
        _uri,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      print('update product ${index}');
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      var _uri = Uri.https(Constantes.baseUrl, "/products/${product.id}");
      final response = await http.delete(_uri);
      print(response.statusCode);
      if (response.statusCode != 200) {
        print(
            "[ERROR] Ocorreu um problema ao excluir o produto: ${product.id}.json");
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            "Ocorreu um erro ao excluir o produto: ${product.title}");
      }
    }
  }
}
