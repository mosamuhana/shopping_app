import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/nav.dart';
import '../styles.dart';
import '../providers.dart';
import '../widgets/custom_text.dart';
import '../widgets/featured_products.dart';
import '../widgets/product_card.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: Styles.colors.white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Styles.colors.black),
              accountName: CustomText(
                text: userProvider.userModel?.name ?? "username lading...",
                color: Styles.colors.white,
                fontWeight: FontWeight.bold,
                size: 18,
              ),
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "email loading...",
                color: Styles.colors.white,
              ),
            ),
            ListTile(
              onTap: () async {
                await userProvider.getOrders();
                await Nav.gotoPage(context, OrderPage());
              },
              leading: Icon(Icons.bookmark_border),
              title: CustomText(text: "My orders"),
            ),
            ListTile(
              onTap: () {
//                userProvider.signOut();
              },
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Log out"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar
            Stack(
              children: <Widget>[
                Positioned(
                  top: 10,
                  right: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState.openEndDrawer();
                          },
                          child: Icon(Icons.menu))),
                ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                      alignment: Alignment.topRight,
                      child:
                          GestureDetector(onTap: () => Nav.gotoPage(context, CartPage()), child: Icon(Icons.shopping_cart))),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        _key.currentState.showSnackBar(SnackBar(content: Text("User profile")));
                      },
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'What are\nyou Shopping for?',
                    style: TextStyle(fontSize: 30, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),

//          Search Text field
//            Search(),

            Container(
              decoration: BoxDecoration(
                  color: Styles.colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Styles.colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Styles.colors.black,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern) async {
                        await productProvider.search(productName: pattern);
                        await Nav.gotoPage(context, ProductSearchPage());
                      },
                      decoration: InputDecoration(
                        hintText: "blazer, dress...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

//            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(alignment: Alignment.centerLeft, child: new Text('Featured products')),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(alignment: Alignment.centerLeft, child: new Text('Recent products')),
                ),
              ],
            ),

            Column(
              children: productProvider.products
                  .map((item) => GestureDetector(
                        child: ProductCard(
                          product: item,
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
//Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//GestureDetector(
//onTap: (){
//key.currentState.openDrawer();
//},
//child: Icon(Icons.menu))
//],
//),
