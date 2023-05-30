import 'package:ecommerce_app/screens/admin/orders_screen/order_details/order_details.dart';
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
      backgroundColor: const Color.fromARGB(255, 232, 236, 237),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
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
                            ((item['price'] ?? 0) *
                                (item['userQuantity'] ?? 1)),
                      );

                      return ExpansionTile(
                        title: Text('Customer Name: ${userData['firstName']}'),
                        subtitle: Text(
                            'Placed at ${DateFormat.yMd().add_jm().format(order['timestamp'].toDate())}, Total: \$${totalPrice.toStringAsFixed(2)}'),
                        leading: CircleAvatar(
                          radius: 30.0,
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: userData['imageUrl'] != null
                                  ? Image.network(
                                      userData['imageUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons.account_circle,
                                            size: 80.0);
                                      },
                                    )
                                  : const Icon(Icons.account_circle,
                                      size: 30.0),
                            ),
                          ),
                        ),
                        children: [
                          ...cartItems.map((item) {
                            return ListTile(
                              leading: Image.network(item['imageURL']),
                              title: Text(item['title']),
                              trailing:
                                  Text('Quantity: ${item['userQuantity']}'),
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
          ),
        ),
      ),
    );
  }
}
