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
  AuthProvider auth;
  ProductProvider productProvider;
  bool _busy = false;

  set busy(bool v) {
    if (_busy != v) {
      setState(() => _busy = v);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: Styles.colors.white,
      endDrawer: _drawer,
      body: SafeArea(
        child: _bodyContent,
      ),
    );
  }

  Drawer get _drawer {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Styles.colors.black),
            accountName: CustomText(
              text: auth.userModel?.name ?? "username loading...",
              color: Styles.colors.white,
              fontWeight: FontWeight.bold,
              size: 18,
            ),
            accountEmail: CustomText(
              text: auth.userModel?.email ?? "email loading...",
              color: Styles.colors.white,
            ),
          ),
          ListTile(
            onTap: () async {
              await auth.getOrders();
              await Nav.gotoPage(context, OrderPage());
            },
            leading: Icon(Icons.bookmark_border),
            title: CustomText(text: "My orders"),
          ),
          ListTile(
            onTap: () {
              //userProvider.signOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "LOG OUT"),
          ),
        ],
      ),
    );
  }

  Widget get _bodyContent {
    return ListView(
      children: [
        Stack(
          children: [
            Positioned(
              top: 10,
              right: 20,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _key.currentState.openEndDrawer(),
                  child: Icon(Icons.menu),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 60,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Nav.gotoPage(context, CartPage()),
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 100,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _key.currentState.showSnackBar(SnackBar(content: Text("User profile"))),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: _insets8,
              child: Text('What are\nyou Shopping for?', style: _blackW400S30Style),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Styles.colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Padding(
            padding: _insetsL8T8R8B10,
            child: Container(
              decoration: BoxDecoration(
                color: Styles.colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(Icons.search, color: Styles.colors.black),
                title: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: _busy ? null : (term) => _onSearch(term),
                  decoration: InputDecoration(
                    hintText: "blazer, dress...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: _insets14,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Featured products'),
              ),
            ),
          ],
        ),
        FeaturedProducts(),
        Row(
          children: [
            Padding(
              padding: _insets14,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Recent products'),
              ),
            ),
          ],
        ),
        Column(
          children: productProvider.products.map((item) => ProductCard(product: item)).toList(),
        )
      ],
    );
  }

  Future<void> _onSearch(term) async {
    try {
      busy = true;
      await productProvider.search(term);
    } catch (e) {
      // ...
    } finally {
      busy = false;
    }
    await Nav.gotoPage(context, ProductSearchPage());
  }

  final _insets8 = EdgeInsets.all(8);
  final _insets14 = EdgeInsets.all(14);
  final _insetsL8T8R8B10 = EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10);

  final _blackW400S30Style = TextStyle(fontSize: 30, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w400);
}
