import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/data/dummy_data.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  // bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  void addProductFromData(Map<String, Object> formData) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: formData['name'] as String,
      price: formData['price'] as double,
      description: formData['description'] as String,
      imageUrl: formData['imageUrl'] as String,
    );

    addProduct(newProduct);
  }

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((prod) => prod.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
