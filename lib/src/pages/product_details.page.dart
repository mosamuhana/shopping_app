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

  @override
  void initState() {
    super.initState();
    _color = widget.product.colors[0];
    _size = widget.product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
          child: Container(
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
                    image: widget.product.picture,
                    fit: BoxFit.fill,
                    height: 400,
                    width: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      // Box decoration takes a gradient
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.07),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.025),
                        ],
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(top: 8.0), child: Container()),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      // Box decoration takes a gradient
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
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
                    child: Padding(padding: const EdgeInsets.only(top: 8.0), child: Container()),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.product.name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '\$${widget.product.priceAsString}',
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Nav.gotoPage(context, CartPage()),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black, offset: Offset(2, 5), blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "Select a Color",
                              color: Styles.colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                              value: _color,
                              style: TextStyle(color: Styles.colors.white),
                              items: widget.product.colors
                                  .map<DropdownMenuItem<String>>(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: CustomText(text: value, color: Styles.colors.red),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() => _color = value),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "Select a Size",
                              color: Styles.colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                                value: _size,
                                style: TextStyle(color: Styles.colors.white),
                                items: widget.product.sizes
                                    .map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                                        value: value,
                                        child: CustomText(
                                          text: value,
                                          color: Styles.colors.red,
                                        )))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _size = value;
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description:\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s  Lorem Ipsum has been the industry standard dummy text ever since the 1500s ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool success =
                                  await userProvider.addToCart(product: widget.product, color: _color, size: _size);
                              if (success) {
                                _key.currentState.showSnackBar(SnackBar(content: Text("Added to Cart!")));
                                userProvider.reloadUserModel();
                                appProvider.changeIsLoading();
                                return;
                              } else {
                                _key.currentState.showSnackBar(SnackBar(content: Text("Not added to Cart!")));
                                appProvider.changeIsLoading();
                                return;
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: appProvider.isLoading
                                ? Loading()
                                : Text(
                                    "Add to cart",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
