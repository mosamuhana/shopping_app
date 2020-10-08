import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';

class OrderService {
  static OrderService _instance;
  static OrderService get instance => _instance ??= OrderService();

  CollectionReference get collection => FirebaseFirestore.instance.collection('orders');

  Future<void> create({
    String userId,
    String id,
    String description,
    String status,
    List<CartItem> cart,
    double totalPrice,
  }) async {
    await collection.doc(id).set({
      "userId": userId,
      "id": id,
      "cart": (cart ?? []).map((x) => x.toMap()).toList(),
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });
  }

  Future<List<Order>> getUserOrders(String userId) async {
    final snapshot = await collection.where("userId", isEqualTo: userId).get();
    return snapshot.docs.map((x) => Order.fromDoc(x)).toList();
  }
}
