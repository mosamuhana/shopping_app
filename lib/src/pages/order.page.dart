import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers.dart';
import '../styles.dart';
import '../widgets/custom_text.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Styles.colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.colors.black),
        backgroundColor: Styles.colors.white,
        elevation: 0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: auth.orders.length,
        itemBuilder: (_, index) {
          Order order = auth.orders[index];
          return ListTile(
            leading: CustomText(
              text: "\$${order.totalAsString}",
              fontWeight: FontWeight.bold,
            ),
            title: Text(order.description),
            subtitle: Text(order.createdAt?.toString() ?? ''),
            trailing: CustomText(text: order.status, color: Styles.colors.green),
          );
        },
      ),
    );
  }
}
