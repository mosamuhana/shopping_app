import 'package:flutter/material.dart';

import '../models.dart';
import '../services.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _productsSearched = [];
  bool _initialized = false;

  List<Product> get products => _products;
  List<Product> get productsSearched => _productsSearched;

  ProductProvider();

  void init() {
    if (_initialized) return;
    load();
  }

  Future<void> load() async {
    _products = await ProductService.instance.getAll();
    _initialized = true;
    notifyListeners();
  }

  Future<void> search(String term) async {
    _productsSearched = await ProductService.instance.search(term);
    notifyListeners();
  }
}
