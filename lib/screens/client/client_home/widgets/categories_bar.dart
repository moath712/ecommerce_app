import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/client/products_Screen/products_screen.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';

class CategoriesBar extends StatelessWidget {
  const CategoriesBar({
    super.key,
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 170, horizontal: 50),
              child: SizedBox(
                  height: 25, width: 25, child: CircularProgressIndicator()),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var doc = snapshot.data!.docs[index];
              String title = doc['name'];
              String image = doc['imageUrl'];

              return FutureBuilder<QuerySnapshot>(
                // Fetch the 'products' subcollection
                future: firestore
                    .collection('categories')
                    .doc(doc['name'])
                    .collection('products')
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(100.0),
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Get the number of products
                  int numOfProducts = productSnapshot.data!.docs.length;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryProducts(categoryName: title),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 190,
                        height: 250,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Image.asset(
                                ImageAssets.categorybox,
                                width: 190,
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      image,
                                      width: 220,
                                      height: 220,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          ' $numOfProducts+ Products',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
