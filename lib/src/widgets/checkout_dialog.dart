import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers.dart';
import '../services.dart';
import '../styles.dart';
import '../utils/snack.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You will be charged \$${auth.userModel.totalPriceAsString} upon delivery!',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 320,
                child: RaisedButton(
                  onPressed: () => onAccept(context, auth),
                  child: Text("Accept", style: TextStyle(color: Colors.white)),
                  color: Color(0xFF1BC0C5),
                ),
              ),
              SizedBox(
                width: 320,
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
  }

  Future<void> onAccept(BuildContext context, AuthProvider auth) async {
    final id = Uuid().v4();

    await OrderService.instance.create(
      userId: auth.user.uid,
      id: id,
      description: "Some random description",
      status: "complete",
      totalPrice: auth.userModel.totalPrice,
      cart: auth.userModel.cartItems,
    );

    final cartItems = auth.userModel.cartItems ?? [];

    for (var item in cartItems) {
      bool isRemoved = await auth.removeFromCart(cartItem: item);
      if (isRemoved) {
        auth.reloadUserModel();
        print("Item added to cart");
        //_key.currentState.showSnackBar(SnackBar(content: Text("Removed from Cart!")));
        Snack.show(context, "Removed from Cart!");
      } else {
        print("ITEM WAS NOT REMOVED");
      }
    }

    Snack.show(context, "Order created!");
    Navigator.pop(context);
  }

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => CheckoutDialog(),
    );
  }
}
