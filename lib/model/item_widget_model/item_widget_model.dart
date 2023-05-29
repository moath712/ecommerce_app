import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String imageURL;
  final double price;

  Product({
    required this.id, 
    required this.title, 
    required this.imageURL, 
    required this.price
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: data['productId'] ?? '',
      title: data['title'] ?? '',
      imageURL: data['imageURL'] ?? '',
      price: data['price'] ?? 0.0,
    );
  }
}
