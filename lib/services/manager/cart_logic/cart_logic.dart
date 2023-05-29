
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartState extends StateNotifier<List<Map<String, dynamic>>> {
  CartState(this.userId) : super([]) {
    loadCartItems();
  }

  Future<void> confirmOrder(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Prepare order data
      final orderData = {
        'userId': userId,
        'userData': userData.data(),
        'cartItems': state,
        'timestamp': Timestamp.now(),
      };

      // Add order to Firestore
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      for (var item in state) {
        // Get the document of the item from Firestore
        var itemDoc = await FirebaseFirestore.instance
            .collection('categories')
            .doc(item['category'])
            .collection('products')
            .doc(item['productId'])
            .get();

        // If the document exists, update the quantity
        if (itemDoc.exists) {
          int originalQuantity = itemDoc.data()!['quantity'];
          int userQuantity = item['userQuantity'];

          // Update the quantity
          await FirebaseFirestore.instance
              .collection('categories')
              .doc(item['category'])
              .collection('products')
              .doc(item['productId'])
              .update({'quantity': originalQuantity - userQuantity});
        } else {
          if (kDebugMode) {
            print('Item does not exist');
          }
        }
      }
      // Clear current cart
      FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Refresh local state
      loadCartItems();

      // If everything goes well, show a success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order confirmed'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // If something goes wrong, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to confirm order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;
  void removeFromCart(String itemId) {
    FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();

    loadCartItems(); // refresh cart items
  }

  void loadCartItems() {
    FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .listen((snapshot) {
      state =
          snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    });
  }

  void addToCart(Map<String, dynamic> product) {
    state = [...state, product];
    FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .add(product);
  }

  void updateCartItem(String itemId, int quantity) {
    FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .update({'quantity': quantity});
    loadCartItems(); // refresh cart items
  }

  void increaseUserQuantity(String itemId) {
    var index = state.indexWhere((item) => item['id'] == itemId);
    var updatedItem = {
      ...state[index],
      'userQuantity': state[index]['userQuantity'] + 1
    };

    state = [...state];
    state[index] = updatedItem;

    FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .update({'userQuantity': updatedItem['userQuantity']});
  }

  void decreaseUserQuantity(String itemId) {
    var index = state.indexWhere((item) => item['id'] == itemId);
    if (state[index]['userQuantity'] > 1) {
      var updatedItem = {
        ...state[index],
        'userQuantity': state[index]['userQuantity'] - 1
      };

      state = [...state];
      state[index] = updatedItem;

      FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .update({'userQuantity': updatedItem['userQuantity']});
    }
  }
}