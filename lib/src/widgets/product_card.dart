import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/product.dart';
import '../pages.dart';
import '../styles.dart';
import '../utils/nav.dart';
import 'loading.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Nav.gotoPage(context, ProductDetailsPage(product: product)),
        child: Container(
          decoration: BoxDecoration(
            color: Styles.colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey[300], offset: Offset(-2, -1), blurRadius: 5),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
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
                          fit: BoxFit.cover,
                          height: 140,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              _productDetails,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _productDetails {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${product.name} \n',
            style: TextStyle(fontSize: 20),
          ),
          TextSpan(
            text: 'by: ${product.brand} \n\n\n\n',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          TextSpan(
            text: '\$${product.priceAsString} \t',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: product.sale ? 'ON SALE ' : "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.red),
          ),
        ],
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
