import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";

  String _id;
  String _name;
  String _email;
  String _stripeId;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get stripeId => _stripeId;

  List<CartItem> cart;
  int totalCartPrice;

  UserModel.fromDoc(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _name = snapshot[NAME];
    _email = snapshot[EMAIL];
    _stripeId = snapshot[STRIPE_ID] ?? "";
    cart = CartItem.fromList(snapshot[CART] ?? []);
    totalCartPrice = cart.map((x) => x.price).fold(0, (x, y) => x + y);
  }
}
