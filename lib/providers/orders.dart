import 'dart:convert';

import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {this.id, this.amount, required this.products, required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://other-d1821.firebaseio.com/orders.json');
    final response = await http.get(url);
    print(response.body);
    final List<OrderItem> loaded = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null || extractedData.isEmpty) return;
    extractedData.forEach((key, value) {
      loaded.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['product'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loaded.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final timestamp = DateTime.now();
    var url = Uri.parse('https://other-d1821.firebaseio.com/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'product': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp));
    notifyListeners();
  }
}
