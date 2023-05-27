import 'package:ecommerce_app/screens/client/cart/widgets/checkout_bar.dart';
import 'package:ecommerce_app/screens/client/orders/user_orders_screen.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:ecommerce_app/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

final cartProvider =
    StateNotifierProvider<CartState, List<Map<String, dynamic>>>(
        (ref) => CartState(ref.read(authProvider).currentUser!.uid));

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    double totalPrice = cart.fold(
        0,
        (previousValue, element) =>
            previousValue +
            ((element['price'] ?? 0) * (element['userQuantity'] ?? 1)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(ImageAssets.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("My Cart",
            style: TextStyle(fontSize: 30, color: AppColors.cartpink)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 236, 237),
                    boxShadow: const [],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(cart[index]['imageURL'])),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cart[index]['title'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cartpink),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '\$${(cart[index]['price'] ?? 0) * (cart[index]['userQuantity'] ?? 0)}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.totalpink),
                            ),
                          ),
                          Row(
                            children: [
                              if (cart[index]['selectedColor'] != null)
                                CircleAvatar(
                                  backgroundColor: Color(int.parse(
                                      '0xFF${cart[index]['selectedColor']['hex'].substring(1)}')),
                                  radius: 5,
                                ),
                              const SizedBox(width: 8),
                              if (cart[index]['selectedColor'] != null)
                                Text(
                                    '${cart[index]['selectedColor']['color']}'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Remove from cart'),
                                    content: const Text(
                                        'Are you sure you want to remove this item from your cart?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('YES'),
                                        onPressed: () {
                                          cartNotifier.removeFromCart(
                                              cart[index]['id']);
                                          Navigator.of(context)
                                              .pop(); // Dismiss the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Text(
                            '${cart[index]['userQuantity']}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: AppColors.cartpink),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Image.asset(ImageAssets.plus),
                                onPressed: () => cartNotifier
                                    .increaseUserQuantity(cart[index]['id']),
                              ),
                              IconButton(
                                icon: Image.asset(ImageAssets.minus),
                                onPressed: cart[index]['userQuantity'] > 1
                                    ? () => cartNotifier
                                        .decreaseUserQuantity(cart[index]['id'])
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CheckOutBar(cartNotifier: cartNotifier, totalPrice: totalPrice),
        ],
      ),
    );
  }
}
