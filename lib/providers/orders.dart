import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';

import '../const/constantes.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

class Orders extends ChangeNotifier {
  String? _token;
  String? _userId;
  List<Order> _items = [];

  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  /**
   * Recupera o items de lementos no carrinho.
   */
  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final date = DateTime.now();
    Map<String, String> params = {"auth": _token!};
    var _uri = Uri.https(Constantes.baseUrl, "/orders/$_userId.json", params);
    final response = await http.post(_uri,
        body: jsonEncode({
          'total': total,
          'products': products
              .map((cardItem) => {
                    'id': cardItem.id,
                    'productId': cardItem.productId,
                    'title': cardItem.title,
                    'quantity': cardItem.quantity,
                    'price': cardItem.price,
                  })
              .toList(),
          'date': date.toIso8601String()
        }));

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: total,
        products: products,
        date: date,
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    Map<String, String> params = {"auth": _token!};
    var _uri = Uri.https(Constantes.baseUrl, "/orders/$_userId.json", params);
    final response = await http.get(_uri);

    switch (response.statusCode) {
      case 200:
        if (response.body == "null") {
          print("Usuario: $_userId não tem pedidos");
          _items.clear();
          return Future.value();
        }
        Map<String, dynamic> data = jsonDecode(response.body);
        _items.clear();
        if (data != null) {
          data.forEach((orderId, orderData) {
            _items.add(
              Order(
                id: orderId,
                total: orderData['total'],
                date: DateTime.parse(orderData['date']),
                products:
                    (orderData['products'] as List<dynamic>).map((cardItem) {
                  return CartItem(
                    id: cardItem['id'],
                    productId: cardItem['productId'],
                    title: cardItem['title'],
                    quantity: cardItem['quantity'],
                    price: cardItem['price'],
                  );
                }).toList(),
              ),
            );
          });
          notifyListeners();
        }
        _items = _items.reversed.toList();
        return Future.value();
      default:
        throw Exception(response.reasonPhrase);
    }
  }
}
