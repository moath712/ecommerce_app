import 'package:ecommerce_app/widgets/cart_icon.dart';
import 'package:ecommerce_app/screens/client/product_details/product_details.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProducts extends StatefulWidget {
  final String categoryName;

  const CategoryProducts({super.key, required this.categoryName});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  late Stream<QuerySnapshot> _productStream;

  @override
  void initState() {
    super.initState();
    _updateProductStream(widget.categoryName);
  }

  void _updateProductStream(String categoryName) {
    _productStream = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryName)
        .collection('products')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(ImageAssets.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            widget.categoryName,
            style: const TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
        actions: [ItemsNumber(userId: FirebaseAuth.instance.currentUser!.uid)],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 7.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  productData: product,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shadowColor: Colors.transparent,
                            color: const Color.fromARGB(255, 232, 236, 237),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: Hero(
                                      tag: 'hero-tag-${product['productId']}',
                                      child: Image.network(
                                        product['imageURL'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        product['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        '\$${product['price']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      if (product['quantity'] <= 0)
                                        const Text(
                                          'Out of stock',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
