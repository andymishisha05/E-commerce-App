import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    var oldSatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    var url =
        Uri.parse('https://other-d1821.firebaseio.com/products/${id}.json');

    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        throw HttpExeption("Error");
      }
    } catch (error) {
      isFavorite = oldSatus;
      notifyListeners();
    }
  }
}
