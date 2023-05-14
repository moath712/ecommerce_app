import 'package:ecommerce_app/screens/client/cart/cart_page.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartState extends StateNotifier<List<Map<String, dynamic>>> {
  CartState() : super([]);
  String userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> addToCart(
      Map<String, dynamic> product, BuildContext context) async {
    try {
      var productWithUserQuantity = {...product, 'userQuantity': 1};
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .add(productWithUserQuantity);
      // Add the id to the product
      productWithUserQuantity['id'] = docRef.id;
      state = [...state, productWithUserQuantity];

      // If everything goes well, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // If something goes wrong, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product to cart'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartState, List<Map<String, dynamic>>>(
        (ref) => CartState());

class ProductDetails extends ConsumerWidget {
  final Map<String, dynamic> productData;

  const ProductDetails({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> productColors =
        List<Map<String, dynamic>>.from(productData['colors'] ?? []);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 420,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(255, 232, 236, 237),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Image.asset(ImageAssets.back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: Image.asset(ImageAssets.bag),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CartPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                productData['category'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                productData['title']
                                    .split(" ")
                                    .map((word) => word + "\n")
                                    .join(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "From",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${productData['price']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (productColors.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  "Available Colors",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productColors.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          backgroundColor: productColors[index]
                                                  ['hex'] is String
                                              ? Color(int.parse(
                                                  '0xFF${productColors[index]['hex'].substring(1)}'))
                                              : Colors.transparent,
                                          radius: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -60,
                    child: SizedBox(
                      width: 320,
                      height: 320,
                      child: Image.network(
                        productData['imageURL'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    productData['subTitle'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    productData['description'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () => ref
                              .read(cartProvider.notifier)
                              .addToCart(productData, context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: const Color(0xFFA95EFA),
                          ),
                          child: const Text(
                            'Add To Cart',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
