class ProductDetails {
  final String productId;
  final String imageURL;
  final String title;
  final double price;
  final int quantity;
  final List<Map<String, dynamic>> colors;

  ProductDetails({
    required this.productId,
    required this.imageURL,
    required this.title,
    required this.price,
    required this.quantity,
    required this.colors,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productId: json['productId'],
      imageURL: json['imageURL'],
      title: json['title'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      colors: List<Map<String, dynamic>>.from(json['colors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'imageURL': imageURL,
      'title': title,
      'price': price,
      'quantity': quantity,
      'colors': colors,
    };
  }
}
