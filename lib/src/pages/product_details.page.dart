import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils/nav.dart';
import '../styles.dart';
import '../models/product.dart';
import '../providers.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading.dart';
import '../pages.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _key = GlobalKey<ScaffoldState>();
  String _color = "";
  String _size = "";
  bool _busy = false;
  AuthProvider auth;

  Product get product => widget.product;

  set busy(bool value) {
    if (_busy != value) {
      setState(() => _busy = value);
    }
  }

  @override
  void initState() {
    super.initState();
    _color = product.colors[0];
    _size = product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
        child: _bodyContent(context),
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Loading(),
                ),
              ),
              Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: product.picture,
                  fit: BoxFit.fill,
                  height: 400,
                  width: double.infinity,
                ),
              ),
              Align(alignment: Alignment.topCenter, child: _container1),
              Align(alignment: Alignment.bottomCenter, child: _container2),
              Positioned(
                bottom: 0,
                child: _productNameAndPrice,
              ),
              Positioned(
                right: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Nav.gotoPage(context, CartPage()),
                    child: Padding(
                      padding: _insets4,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: _insets8,
                          child: Icon(Icons.shopping_cart),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Styles.colors.red,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(35)),
                      ),
                      child: Padding(
                        padding: _insets4,
                        child: Padding(
                          padding: _insets12,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black, offset: Offset(2, 5), blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: _insets0,
                    child: Row(
                      children: [
                        Padding(
                          padding: _insetsH8,
                          child: CustomText(
                            text: "Select a Color",
                            color: Styles.colors.white,
                          ),
                        ),
                        Padding(
                          padding: _insetsH8,
                          child: _buildDropdownButton(_color, product.colors, (v) => setState(() => _color = v)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: _insets0,
                    child: Row(
                      children: [
                        Padding(
                          padding: _insetsH8,
                          child: CustomText(
                            text: "Select a Size",
                            color: Styles.colors.white,
                          ),
                        ),
                        Padding(
                          padding: _insetsH8,
                          child: _buildDropdownButton(_size, product.sizes, (v) => setState(() => _size = v)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: _insets8,
                      child: Text('Description:\n$_LOREM_TEXT', style: _whiteStyle),
                    ),
                  ),
                  Padding(
                    padding: _insets8,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      elevation: 0,
                      child: MaterialButton(
                        onPressed: _busy ? null : () => _onAddToCart(),
                        minWidth: MediaQuery.of(context).size.width,
                        child:
                            _busy ? Loading() : Text("Add to cart", textAlign: TextAlign.center, style: _blackBoldS20Style),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _container1 {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.07),
            Colors.black.withOpacity(0.05),
            Colors.black.withOpacity(0.025),
          ],
        ),
      ),
      child: Padding(padding: _insetsT8, child: Container()),
    );
  }

  Widget get _container2 {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.07),
            Colors.black.withOpacity(0.05),
            Colors.black.withOpacity(0.025),
          ],
        ),
      ),
      child: Padding(padding: _insetsT8, child: Container()),
    );
  }

  Widget get _productNameAndPrice {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: _insets10,
            child: Text(product.name, style: _whiteW300S20Style),
          ),
          Padding(
            padding: _insets10,
            child: Text('\$${product.priceAsString}', textAlign: TextAlign.end, style: _whiteBoldS20Style),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String value, List<String> items, ValueChanged onChanged) {
    if (items.length == 0) return Container();
    if (items.length == 1) return Text(items[0]);

    return DropdownButton<String>(
      value: value,
      style: _whiteStyle,
      onChanged: onChanged,
      items: [
        for (var item in items)
          DropdownMenuItem<String>(
            value: item,
            child: CustomText(text: item, color: Styles.colors.red),
          ),
      ],
    );
  }

  Future<void> _onAddToCart() async {
    busy = true;
    try {
      bool success = await auth.addToCart(product: widget.product, color: _color, size: _size);
      if (success) {
        _key.currentState.showSnackBar(SnackBar(content: Text("Added to Cart!")));
        await auth.reloadUserModel();
      } else {
        _key.currentState.showSnackBar(SnackBar(content: Text("Not added to Cart!")));
      }
    } catch (e) {
      //...
    } finally {
      busy = false;
    }
  }

  final _blackBoldS20Style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
  final _whiteStyle = TextStyle(color: Colors.white);
  final _whiteW300S20Style = TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20);
  final _whiteBoldS20Style = TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold);

  final _insets4 = EdgeInsets.all(4);
  final _insets0 = EdgeInsets.all(0);
  final _insets8 = EdgeInsets.all(8);
  final _insets10 = EdgeInsets.all(10);
  final _insets12 = EdgeInsets.all(12);
  final _insetsH8 = EdgeInsets.symmetric(horizontal: 8);
  final _insetsT8 = EdgeInsets.only(top: 8);
}

const _LOREM_TEXT =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s  Lorem Ipsum has been the industry standard dummy text ever since the 1500s ';
