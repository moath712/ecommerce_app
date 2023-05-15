import 'package:ecommerce_app/screens/admin/orders_screen/order_details.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersState extends StateNotifier<List<Map<String, dynamic>>> {
  OrdersState() : super([]) {
    loadOrders();
  }

  void loadOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      state = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersState, List<Map<String, dynamic>>>(
        (ref) => OrdersState());

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

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
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final userData = order['userData'];
                final cartItems = order['cartItems'] as List<dynamic>;

                // Calculate total price
                final totalPrice = cartItems.fold(
                  0.0,
                  (double previousValue, item) =>
                      previousValue +
                      ((item['price'] ?? 0) * (item['userQuantity'] ?? 1)),
                );

                return ExpansionTile(
                  title: Text('Customer Name: ${userData['firstName']}'),
                  subtitle: Text(
                      'Placed at ${DateFormat.yMd().add_jm().format(order['timestamp'].toDate())}, Total: \$${totalPrice.toStringAsFixed(2)}'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['photoUrl']),
                    radius: 30,
                  ),
                  children: [
                    Text('Phone Number: ${userData['Phone Number']}'),
                    ...cartItems.map((item) {
                      return ListTile(
                        leading: Image.network(item['imageURL']),
                        title: Text(item['title']),
                        trailing: Text('Quantity: ${item['userQuantity']}'),
                      );
                    }).toList(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsPage(order: order),
                          ),
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
