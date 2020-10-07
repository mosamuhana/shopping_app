import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
import '../models/order.dart';
import '../providers.dart';
import '../widgets/custom_text.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.colors.black),
        backgroundColor: Styles.colors.white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Styles.colors.white,
      body: ListView.builder(
        itemCount: userProvider.orders.length,
        itemBuilder: (_, index) {
          Order _order = userProvider.orders[index];
          return ListTile(
            leading: CustomText(
              text: "\$${_order.total / 100}",
              fontWeight: FontWeight.bold,
            ),
            title: Text(_order.description),
            subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
            trailing: CustomText(
              text: _order.status,
              color: Styles.colors.green,
            ),
          );
        },
      ),
    );
  }
}
