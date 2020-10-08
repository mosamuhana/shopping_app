import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String _id;
  String _description;
  String _userId;
  String _status;
  DateTime _createdAt;
  double _total = 0;
  List cart;

  String get id => _id;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  double get total => _total ?? 0;
  DateTime get createdAt => _createdAt;
  String get totalAsString => total == 0 ? '0' : total.toStringAsFixed(2);

  Order.fromDoc(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _description = snapshot[DESCRIPTION];
    _total = snapshot[TOTAL];
    _status = snapshot[STATUS];
    _userId = snapshot[USER_ID];
    var createdAtValue = snapshot[CREATED_AT];
    _createdAt = createdAtValue == null ? null : DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    cart = snapshot[CART];
  }
}
