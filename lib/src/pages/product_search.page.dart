import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../providers.dart';
import '../styles.dart';
import '../utils/nav.dart';
import '../widgets/custom_text.dart';
import '../widgets/product_card.dart';

class ProductSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.colors.black),
        backgroundColor: Styles.colors.white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: CustomText(
          text: "Products",
          size: 20,
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})],
      ),
      body: productProvider.productsSearched.length < 1
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Styles.colors.grey,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      text: "No products Found",
                      color: Styles.colors.grey,
                      fontWeight: FontWeight.w300,
                      size: 22,
                    ),
                  ],
                )
              ],
            )
          : ListView.builder(
              itemCount: productProvider.productsSearched.length,
              itemBuilder: (context, index) {
                final product = productProvider.productsSearched[index];
                return GestureDetector(
                  onTap: () => Nav.gotoPage(context, ProductDetailsPage(product: product)),
                  child: ProductCard(product: product),
                );
              },
            ),
    );
  }
}
