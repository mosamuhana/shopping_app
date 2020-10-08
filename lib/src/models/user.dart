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
  double _totalPrice = 0;
  List<CartItem> _cartItems = [];

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get stripeId => _stripeId;
  double get totalPrice => _totalPrice ?? 0;
  String get totalPriceAsString => totalPrice == 0 ? '0' : totalPrice.toStringAsFixed(2);
  List<CartItem> get cartItems => _cartItems;

  UserModel.fromDoc(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _name = snapshot[NAME];
    _email = snapshot[EMAIL];
    _stripeId = snapshot[STRIPE_ID] ?? "";
    _cartItems = CartItem.fromList(snapshot[CART] ?? []);
    _totalPrice = _cartItems.map((x) => x.price).fold(0, (x, y) => x + y);
  }
}
