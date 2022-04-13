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
  List<Order> _items = [];

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
    // final combine = (t, i) => t + (i.price * i.quantity);
    // final totalp = products.fold(0.0, combine);
    final date = DateTime.now();
    var _uri = Uri.https(Constantes.baseUrl, "/orders.json");
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
    var _uri = Uri.https(Constantes.baseUrl, "/orders.json");
    final response = await http.get(_uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        _items.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((cardItem) {
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
  }
}
