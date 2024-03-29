import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id = "",
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    try {
      Map<String, String> params = {"auth": token};
      var _uri = Uri.https(
        Constantes.baseUrl,
        "/userFavorites/$userId/${this.id}.json",
        params,
      );
      final response = await http.put(
        _uri,
        body: json.encode(isFavorite),
      );
      if (response.statusCode != 200) {
        print(
            "[ERROR] Ocorreu um erro ao definir o produto, ${this.id}, como favorito!");
        _toggleFavorite();
      }
    } catch (errror) {
      _toggleFavorite();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
