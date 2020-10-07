import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import 'featured_card.dart';

class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Container(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (_, i) => FeaturedCard(product: products[i]),
      ),
    );
  }
}
