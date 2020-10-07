import 'package:flutter/material.dart';

import '../models.dart';
import '../services.dart';

class ProductProvider with ChangeNotifier {
  List<Product> products = [];
  List<Product> productsSearched = [];
  bool _initialized = false;

  ProductProvider();

  /*
  ProductProvider.initialize() {
    load();
  }
  */

  void init() {
    if (_initialized) return;
    load();
  }

  load() async {
    products = await ProductService.instance.getAll();
    _initialized = true;
    notifyListeners();
  }

  Future search({String productName}) async {
    productsSearched = await ProductService.instance.search(productName: productName);
    notifyListeners();
  }
}
