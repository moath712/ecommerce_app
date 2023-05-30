import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/client/product_details/product_details.dart';
import 'package:flutter/material.dart';

class AllProductsGrid extends StatelessWidget {
  const AllProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collectionGroup('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 0.8,
          ),
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            final product = documents[index].data() as Map<String, dynamic>;
            return _buildProductCard(context, product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (product['imageURL'] != null)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Hero(
                        tag:
                            'hero-tag-${product['productId']}', 
                        child: Image.network(
                          product['imageURL'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8.0),
                Text(
                  product['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '\$${product['price']}',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 8.0),
                if (product['quantity'] <= 0)
                  const Text(
                    'Out of stock',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
