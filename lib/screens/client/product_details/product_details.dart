import 'package:ecommerce_app/services/manager/color_list/color_list.dart';
import 'package:ecommerce_app/widgets/cart_icon.dart';
import 'package:ecommerce_app/screens/client/orders/user_orders_screen.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartState extends StateNotifier<List<Map<String, dynamic>>> {
  CartState(this.userId) : super([]);
  String userId = FirebaseAuth.instance.currentUser!.uid;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  Future<void> addToCart(
    Map<String, dynamic> product,
    BuildContext context,
    Map<String, String> colorHexValues,
  ) async {
    try {
      isLoading.value = true;

      final firestore = FirebaseFirestore.instance;

      final cartRef =
          firestore.collection('carts').doc(userId).collection('items');

      final colorHex = colorHexValues[product['color']];

      final existingProductQuery = await cartRef
          .where('selectedColor', isEqualTo: product['selectedColor'])
          .where('productId', isEqualTo: product['productId'])
          .get();

      if (existingProductQuery.docs.isNotEmpty) {
        var existingProduct = existingProductQuery.docs.first;
        await cartRef.doc(existingProduct.id).update({
          'userQuantity': existingProduct['userQuantity'] + 1,
        });
      } else {
        var productWithUserQuantity = {
          ...product,
          'userQuantity': 1,
          'color': colorHex
        };
        DocumentReference docRef = await cartRef.add(productWithUserQuantity);
        productWithUserQuantity['id'] = docRef.id;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added to cart'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product to cart'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartState, List<Map<String, dynamic>>>(
        (ref) => CartState(ref.read(authProvider).currentUser!.uid));

class ProductDetails extends ConsumerWidget {
  final Map<String, dynamic> productData;

  const ProductDetails({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> productColors =
        List<Map<String, dynamic>>.from(productData['colors'] ?? []);

    final selectedColor =
        ValueNotifier(productColors.isNotEmpty ? productColors[0] : null);

    return ValueListenableBuilder(
        valueListenable: selectedColor,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 232, 236, 237),
              elevation: 0,
              leading: IconButton(
                icon: Image.asset(ImageAssets.back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                ItemsNumber(userId: FirebaseAuth.instance.currentUser!.uid)
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 460,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 380,
                            width: MediaQuery.of(context).size.width,
                            color: const Color.fromARGB(255, 232, 236, 237),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                                        fontSize: 22,
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
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productColors.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () => selectedColor.value =
                                                  productColors[index],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: productColors[index]
                                                            ['hex'] is String
                                                        ? Color(int.parse(
                                                            '0xFF${productColors[index]['hex'].substring(1)}'))
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  width: 20,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  child: selectedColor.value ==
                                                          productColors[index]
                                                      ? Icon(Icons.check,
                                                          size: 15,
                                                          color: productColors[
                                                                          index]
                                                                      ['hex'] ==
                                                                  "#FFFFFF"
                                                              ? Colors.black
                                                              : Colors.white)
                                                      : null,
                                                ),
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
                            child: Hero(
                              tag: 'hero-tag-${productData['productId']}',
                              child: Image.network(
                                productData['imageURL'],
                                fit: BoxFit.cover,
                              ),
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
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ValueListenableBuilder<bool>(
                                valueListenable:
                                    ref.watch(cartProvider.notifier).isLoading,
                                builder: (context, isLoading, child) {
                                  return ElevatedButton(
                                    onPressed: (productData['quantity'] > 0 &&
                                            !isLoading)
                                        ? () {
                                            final Map<String, String>
                                                colorHexValues = ColorUtils
                                                    .generateColorHexValues();
                                            ref
                                                .read(cartProvider.notifier)
                                                .addToCart({
                                              ...productData,
                                              'selectedColor':
                                                  selectedColor.value,
                                            }, context, colorHexValues);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          productData['quantity'] > 0 &&
                                                  !isLoading
                                              ? const Color(0xFFA95EFA)
                                              : Colors.grey,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20.0,
                                            width: 20.0,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.0,
                                            ),
                                          )
                                        : const Text(
                                            'Add To Cart',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                  );
                                },
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
        });
  }
}
