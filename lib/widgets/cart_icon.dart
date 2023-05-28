import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/client/cart/cart_page.dart';

final itemsProvider = StreamProvider.autoDispose((ref) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('carts')
      .doc(userId)
      .collection('items')
      .snapshots();
});

class ItemsNumber extends ConsumerWidget {
  final String userId;

  const ItemsNumber({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsyncValue = ref.watch(itemsProvider);

    return itemsAsyncValue.when(
      data: (items) {
        return Stack(
          children: <Widget>[
            IconButton(
              icon: Image.asset(ImageAssets.bag),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
            Positioned(
              top: 2,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '${items.docs.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => const Text('Something went wrong'),
    );
  }
}
