import 'package:ecommerce_app/screens/client/product_details/widgets/detais_and_colors.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.productData,
    required this.productColors,
    required this.selectedColor,
  });

  final Map<String, dynamic> productData;
  final List<Map<String, dynamic>> productColors;
  final ValueNotifier<Map<String, dynamic>?> selectedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          DetailsAndColors(
              productData: productData,
              productColors: productColors,
              selectedColor: selectedColor),
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
    );
  }
}
