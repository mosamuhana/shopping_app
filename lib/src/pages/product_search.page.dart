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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.colors.black),
        backgroundColor: Styles.colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(text: "Products", size: 20),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget get _noProducts {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Styles.colors.grey, size: 30),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "No products Found",
              color: Styles.colors.grey,
              fontWeight: FontWeight.w300,
              size: 22,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).productsSearched;

    if (products.length == 0) return _noProducts;

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => Nav.gotoPage(context, ProductDetailsPage(product: product)),
          child: ProductCard(product: product),
        );
      },
    );
  }
}
