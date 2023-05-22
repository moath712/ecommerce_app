import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart/cart_page.dart';

class ItemsNumber extends StatelessWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  ItemsNumber({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items');

    return StreamBuilder<QuerySnapshot>(
      stream: items.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

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
                  '${snapshot.data!.docs.length}',
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
    );
  }
}
