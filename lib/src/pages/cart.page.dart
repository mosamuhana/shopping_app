import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../providers.dart';
import '../styles.dart';
import '../widgets.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _key = GlobalKey<ScaffoldState>();
  AuthProvider auth;
  bool _busy = false;

  UserModel get model => auth.userModel;
  List<CartItem> get cartItems => auth.userModel.cartItems;

  set busy(bool value) {
    if (_busy != value) {
      setState(() => _busy = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);

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
      elevation: 0,
      title: CustomText(text: "Shopping Cart"),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget get _body {
    if (_busy) return Loading();

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (_, i) {
        final cartItem = cartItems[i];
        return CartItemCard(
          item: cartItem,
          onRemove: _busy ? null : () => _onRemoveCartItem(cartItem),
        );
      },
    );
  }

  Widget get _bottomNavigationBar {
    return Container(
      height: 70,
      child: Padding(
        padding: _insets8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Total: ", style: _greyW400S22Style),
                  TextSpan(text: " \$${model.totalPriceAsString}", style: _blackS22Style),
                ],
              ),
            ),
            Container(
              decoration: _checkoutButtonDecoration,
              child: FlatButton(
                onPressed: _onCheckout,
                child: Text("Check out", style: _whiteS20Style),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onCheckout() async {
    if (model.totalPrice == 0) {
      await InfoDialog.show(context, 'Your cart is emty');
    } else {
      await CheckoutDialog.show(context);
    }
  }

  Future<void> _onRemoveCartItem(CartItem cartItem) async {
    busy = true;
    try {
      bool success = await auth.removeFromCart(cartItem: cartItem);
      if (success) {
        await auth.reloadUserModel();
        print("Item removed from cart");
        _key.currentState.showSnackBar(SnackBar(content: Text("Removed from Cart!")));
      }
    } catch (e) {
      // ...
    } finally {
      busy = false;
    }
  }

  final _insets8 = EdgeInsets.all(8);

  final _greyW400S22Style = TextStyle(color: Styles.colors.grey, fontSize: 22, fontWeight: FontWeight.w400);
  final _blackS22Style = TextStyle(color: Styles.colors.black, fontSize: 22, fontWeight: FontWeight.normal);
  final _whiteS20Style = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal);

  final _checkoutButtonDecoration = BoxDecoration(borderRadius: BorderRadius.circular(20), color: Styles.colors.black);
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const CartItemCard({
    Key key,
    @required this.item,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _blackBoldS20Style = TextStyle(color: Styles.colors.black, fontSize: 20, fontWeight: FontWeight.bold);
    final _blackW300S18Style = TextStyle(color: Styles.colors.black, fontSize: 18, fontWeight: FontWeight.w300);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Styles.colors.white,
          boxShadow: [
            BoxShadow(color: Styles.colors.red.withOpacity(0.2), offset: Offset(3, 2), blurRadius: 30),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.network(
                item.image,
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
                        TextSpan(text: '${item.name}\n', style: _blackBoldS20Style),
                        TextSpan(text: "\$${item.priceAsString}\n\n", style: _blackW300S18Style),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Styles.colors.red),
                    onPressed: onRemove,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
