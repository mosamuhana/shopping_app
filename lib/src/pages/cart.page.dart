import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../styles.dart';
import '../providers.dart';
import '../services.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _key = GlobalKey<ScaffoldState>();
  AuthProvider auth;
  AppProvider app;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: _appBar,
      backgroundColor: Styles.colors.white,
      body: _body,
      bottomNavigationBar: _bottomNavigationBar,
    );
  }

  Widget get _appBar {
    return AppBar(
      iconTheme: IconThemeData(color: Styles.colors.black),
      backgroundColor: Styles.colors.white,
      elevation: 0.0,
      title: CustomText(text: "Shopping Cart"),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget get _body {
    if (app.loading) return Loading();
    return ListView.builder(
      itemCount: auth.userModel.cart.length,
      itemBuilder: (_, index) => _buildItem(index),
    );
  }

  Widget get _bottomNavigationBar {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Total: ",
                    style: TextStyle(color: Styles.colors.grey, fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: " \$${auth.userModel.totalCartPrice / 100}",
                    style: TextStyle(color: Styles.colors.black, fontSize: 22, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Styles.colors.black),
              child: FlatButton(
                onPressed: () {
                  if (auth.userModel.totalCartPrice == 0) {
                    showEmptyDialog();
                  } else {
                    showAcceptDialog();
                  }
                },
                child: CustomText(
                  text: "Check out",
                  size: 20,
                  color: Styles.colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Styles.colors.white,
          boxShadow: [BoxShadow(color: Styles.colors.red.withOpacity(0.2), offset: Offset(3, 2), blurRadius: 30)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: Image.network(
                auth.userModel.cart[index].image,
                height: 120,
                width: 140,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: auth.userModel.cart[index].name + "\n",
                          style: TextStyle(color: Styles.colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "\$${auth.userModel.cart[index].price / 100} \n\n",
                          style: TextStyle(color: Styles.colors.black, fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Styles.colors.red),
                    onPressed: () async {
                      app.loading = true;
                      bool success = await auth.removeFromCart(cartItem: auth.userModel.cart[index]);
                      if (success) {
                        auth.reloadUserModel();
                        print("Item added to cart");
                        _key.currentState.showSnackBar(SnackBar(content: Text("Removed from Cart!")));
                        app.loading = false;
                        return;
                      } else {
                        app.loading = false;
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onAccept(BuildContext context, AuthProvider userProvider) async {
    final id = Uuid().v4();

    await OrderService.instance.create(
      userId: userProvider.user.uid,
      id: id,
      description: "Some random description",
      status: "complete",
      totalPrice: userProvider.userModel.totalCartPrice,
      cart: userProvider.userModel.cart,
    );

    final cartItems = userProvider.userModel.cart ?? [];

    for (var item in cartItems) {
      bool isRemoved = await userProvider.removeFromCart(cartItem: item);
      if (isRemoved) {
        userProvider.reloadUserModel();
        print("Item added to cart");
        _key.currentState.showSnackBar(SnackBar(content: Text("Removed from Cart!")));
      } else {
        print("ITEM WAS NOT REMOVED");
      }
    }

    _key.currentState.showSnackBar(SnackBar(content: Text("Order created!")));

    Navigator.pop(context);
  }

  Future<void> onRemove(int index) async {
    app.loading = true;
    bool success = await auth.removeFromCart(cartItem: auth.userModel.cart[index]);
    if (success) {
      auth.reloadUserModel();
      print("Item added to cart");
      _key.currentState.showSnackBar(SnackBar(content: Text("Removed from Cart!")));
      app.loading = false;
      return;
    } else {
      app.loading = false;
    }
  }

  void showEmptyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your cart is emty',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showAcceptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          //this right here
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You will be charged \$${auth.userModel.totalCartPrice / 100} upon delivery!',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () => onAccept(context, auth),
                      child: Text("Accept", style: TextStyle(color: Colors.white)),
                      color: const Color(0xFF1BC0C5),
                    ),
                  ),
                  SizedBox(
                    width: 320.0,
                    child: RaisedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Reject", style: TextStyle(color: Colors.white)),
                      color: Styles.colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
