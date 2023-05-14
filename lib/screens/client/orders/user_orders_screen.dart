import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserOrdersState extends StateNotifier<List<Map<String, dynamic>>> {
  UserOrdersState(this.userId) : super([]) {
    loadUserOrders();
  }

  final String userId;

  void loadUserOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      state = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}

final userOrdersProvider =
    StateNotifierProvider<UserOrdersState, List<Map<String, dynamic>>>(
        (ref) => UserOrdersState(ref.read(authProvider).currentUser!.uid));

class UserOrdersPage extends ConsumerWidget {
  const UserOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userOrders = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: userOrders.length,
        itemBuilder: (context, index) {
          final order = userOrders[index];
          final cartItems = order['cartItems'] as List<dynamic>;

          final totalPrice = cartItems.fold(
            0.0,
            (previousValue, item) =>
                previousValue +
                ((item['price'] ?? 0) * (item['userQuantity'] ?? 1)),
          );

          return ExpansionTile(
            title: Text('Order ${index + 1}'),
            subtitle: Text(
                'Placed at ${DateFormat.yMd().add_jm().format(order['timestamp'].toDate())}, Total: \$${totalPrice.toStringAsFixed(2)}'),
            children: cartItems.map((item) {
              return ListTile(
                leading: Image.network(item['imageURL']),
                title: Text(item['title']),
                trailing: Text('Quantity: ${item['userQuantity']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// Replace with your own auth provider
final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
