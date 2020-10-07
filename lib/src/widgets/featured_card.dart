import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models.dart';
import '../pages.dart';
import '../utils/nav.dart';
import 'loading.dart';

class FeaturedCard extends StatelessWidget {
  final Product product;

  const FeaturedCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () => Nav.gotoPage(context, ProductDetailsPage(product: product)),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Color.fromARGB(62, 168, 174, 201), offset: Offset(0, 9), blurRadius: 14),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                _spinner,
                _productImage,
                _decoratedContainer,
                _productDetails,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _spinner {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Loading(),
      ),
    );
  }

  Widget get _productDetails {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '${product.name} \n', style: TextStyle(fontSize: 18)),
              TextSpan(
                text: '\$${product.priceAsString} \n',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _productImage {
    return Center(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: product.picture,
        fit: BoxFit.cover,
        height: 220,
        width: 200,
      ),
    );
  }

  Widget get _decoratedContainer {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.025),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(),
        ),
      ),
    );
  }
}
