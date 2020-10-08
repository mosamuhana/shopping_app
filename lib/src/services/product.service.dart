import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductService {
  static ProductService _instance;
  static ProductService get instance => _instance ??= ProductService();

  CollectionReference get collection => FirebaseFirestore.instance.collection('products');

  Future<List<Product>> getAll() async {
    final result = await collection.get();
    return _getList(result);
  }

  Future<List<Product>> search(String term) async {
    final searchKey = term[0].toUpperCase() + term.substring(1);
    final q = collection.orderBy("name").startAt([searchKey]).endAt([searchKey + '\uf8ff']);
    final result = await q.get();
    return _getList(result);
  }

  List<Product> _getList(QuerySnapshot q) {
    return q.docs.map((doc) => Product.fromDoc(doc)).toList();
  }
}
