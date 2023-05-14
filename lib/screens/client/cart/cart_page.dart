import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:ecommerce_app/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartState extends StateNotifier<List<Map<String, dynamic>>> {
  CartState() : super([]) {
    loadCartItems();
  }
  Future<void> confirmOrder(BuildContext context) async {
    try {
      // Get user data
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Prepare order data
      final orderData = {
        'userId': userId,
        'userData': userData.data(),
        'cartItems': state,
        'timestamp':
            Timestamp.now(), // optional, for keeping track of order time
      };

      // Add order to Firestore
      await FirebaseFirestore.instance.collection('orders').add(orderData);

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order confirmed'),
          backgroundColor: Colors.green,
        ),
      );
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

  final String userId = FirebaseAuth.instance.currentUser!.uid;
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
        (ref) => CartState());

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(ImageAssets.back),
                ),
              ],
            ),
          ),
          const Text("My Cart",
              style: TextStyle(fontSize: 30, color: AppColors.cartpink)),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                          Text(
                            '\$${(cart[index]['price'] ?? 0) * (cart[index]['userQuantity'] ?? 0)}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.totalpink),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                cartNotifier.removeFromCart(cart[index]['id']),
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
                                onPressed: () => cartNotifier
                                    .decreaseUserQuantity(cart[index]['id']),
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
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 60,
                              child: InkWell(
                                onTap: () => cartNotifier.confirmOrder(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFBB6BD9),
                                        Color(0xFFBB6BD9),
                                        Color(0xFF151A6A),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Confirm Order',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "TOTAL",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.cartpink),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${totalPrice.toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.totalpink),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
