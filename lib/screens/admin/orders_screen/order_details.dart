import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    final userData = order['userData'];
    final cartItems = order['cartItems'] as List<dynamic>;

    // Calculate total price
    final totalPrice = cartItems.fold(
      0.0,
      (double previousValue, item) =>
          previousValue + ((item['price'] ?? 0) * (item['userQuantity'] ?? 1)),
    );

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Image.asset(ImageAssets.back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userData['photoUrl']),
                    radius: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Customer Name: ${userData['firstName']}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Placed at ${DateFormat.yMd().add_jm().format((order['timestamp'] as Timestamp).toDate())}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Phone Number: ${userData['Phone Number']}'),
                ),
                ...cartItems.map((item) {
                  return ListTile(
                    leading: Image.network(item['imageURL']),
                    title: Text(item['title']),
                    trailing: Text('Quantity: ${item['userQuantity']}'),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
