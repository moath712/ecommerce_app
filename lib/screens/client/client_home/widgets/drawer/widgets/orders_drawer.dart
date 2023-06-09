import 'package:ecommerce_app/screens/client/orders/user_orders_screen.dart';
import 'package:flutter/material.dart';

class OrdersDrawer extends StatelessWidget {
  const OrdersDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list),
      title: const Text(
        'Orders',
        style: TextStyle(fontSize: 22),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserOrdersPage()),
        );
      },
    );
  }
}
