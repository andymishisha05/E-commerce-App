import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  //var _showFavoriteOnly = false;

  List<Product> get items {
    /*if (_showFavoriteOnly) {
      return _items.where((element) => element.isFavorite).toList();
    }*/
    return _items; //[..._items]
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  /* void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }*/

  Product findById(String id) {
    return _items.firstWhere((element) => id == element.id);
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://other-d1821.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loaded = [];
      extractedData.forEach((key, value) {
        loaded.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'] as double,
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite']));
      });
      _items = loaded;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product item) async {
    var url = Uri.parse('https://other-d1821.firebaseio.com/products.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imageUrl': item.imageUrl,
            'isFavorite': item.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: item.title,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> updateProduct(String id, Product item) async {
    final index = _items.indexWhere((element) => element.id == id);

    if (index < 0) return;
    var url =
        Uri.parse('https://other-d1821.firebaseio.com/products/${id}.json');

    try {
      await http.patch(url,
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imageUrl': item.imageUrl,
            'isFavorite': item.isFavorite
          }));
      _items[index] = item;

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  void deleteProduct(String id) {
    var url =
        Uri.parse('https://other-d1821.firebaseio.com/products/${id}.json');

    final int index = _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[index];

    _items.removeWhere((element) => id == element.id);
    notifyListeners();

    http.delete(url).then((value) {
      if (value.statusCode >= 400) {
        throw HttpExeption('Could not delete');
      }
    }).catchError((error) {
      _items.insert(index, existingProduct);
      notifyListeners();
    });
  }
}
