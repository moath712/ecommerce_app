import 'package:ecommerce_app/screens/client/cart/widgets/checkout_bar.dart';
import 'package:ecommerce_app/screens/client/orders/user_orders_screen.dart';
import 'package:ecommerce_app/services/manager/cart_logic/cart_logic.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:ecommerce_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
