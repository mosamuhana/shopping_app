import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const QUANTITY = "quantity";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const SIZES = "sizes";
  static const COLORS = "colors";

  String _id;
  String _name;
  String _picture;
  String _description;
  String _category;
  String _brand;
  int _quantity;
  double _price;
  bool _sale;
  bool _featured;
  List<String> _colors;
  List<String> _sizes;

  String get id => _id;
  String get name => _name;
  String get picture => _picture;
  String get brand => _brand;
  String get category => _category;
  String get description => _description;
  int get quantity => _quantity;
  double get price => _price;
  bool get featured => _featured;
  bool get sale => _sale;
  List<String> get colors => _colors ?? [];
  List<String> get sizes => _sizes ?? [];

  String get priceAsString => _price == null ? '' : _price.toStringAsFixed(2);

  Product.fromDoc(DocumentSnapshot snapshot) {
    _id = snapshot.id;
    _brand = snapshot[BRAND];
    _sale = snapshot[SALE];
    _description = snapshot[DESCRIPTION] ?? " ";
    _featured = snapshot[FEATURED];
    _price = snapshot[PRICE];
    _category = snapshot[CATEGORY];
    _colors = snapshot[COLORS];
    _sizes = snapshot[SIZES];
    _name = snapshot[NAME];
    _picture = snapshot[PICTURE];
  }
}
