import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';

class UserService {
  static UserService _instance;
  static UserService get instance => _instance ??= UserService();

  CollectionReference get collection => FirebaseFirestore.instance.collection('users');

  Future<void> createUser(Map<String, dynamic> data) async {
    await collection.doc(data["uid"]).set(data);
  }

  Future<UserModel> getUserById(String id) async {
    final doc = await collection.doc(id).get();
    return UserModel.fromDoc(doc);
  }

  Future<void> addToCart({String userId, CartItem cartItem}) async {
    await collection.doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  Future<void> removeFromCart({String userId, CartItem cartItem}) async {
    await collection.doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }
}
