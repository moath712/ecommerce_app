class Product {
  final String productId;
  final String imageURL;
  final String title;
  final double price;
  final int quantity;
  final String category;
  final String subTitle;
  final String description;

  List<Map<String, dynamic>> colors;

  Product(
    this.category,
    this.subTitle,
    this.description,
    this.quantity,
    this.productId,
    this.imageURL,
    this.title,
    this.price, {
    this.colors = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['category'],
      json['subTitle'],
      json['description'],
      json['quantity'],
      json['productId'],
      json['imageURL'],
      json['title'],
      json['price'].toDouble(),
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
      'category': category,
      'subTitle': subTitle,
      'description': description,
      'colors': colors,
    };
  }
}
