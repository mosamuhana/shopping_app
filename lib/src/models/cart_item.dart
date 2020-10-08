class CartItem {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const PRICE = "price";
  static const SIZE = "size";
  static const COLOR = "color";

  String _id;
  String _name;
  String _image;
  String _productId;
  String _size;
  String _color;
  double _price = 0;

  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get productId => _productId;
  String get size => _size;
  String get color => _color;
  double get price => _price ?? 0;
  String get priceAsString => price == 0 ? '0' : price.toStringAsFixed(2);

  CartItem.fromMap(Map<String, dynamic> data) {
    _id = data[ID];
    _name = data[NAME];
    _image = data[IMAGE];
    _productId = data[PRODUCT_ID];
    _price = data[PRICE];
    _size = data[SIZE];
    _color = data[COLOR];
  }

  Map<String, dynamic> toMap() {
    return {
      ID: _id,
      IMAGE: _image,
      NAME: _name,
      PRODUCT_ID: _productId,
      PRICE: _price,
      SIZE: _size,
      COLOR: _color,
    };
  }

  static List<CartItem> fromList(List<dynamic> list) {
    return (list ?? []).map((item) => CartItem.fromMap(item)).toList();
  }
}
