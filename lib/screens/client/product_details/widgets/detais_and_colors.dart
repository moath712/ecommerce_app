import 'package:flutter/material.dart';

class DetailsAndColors extends StatelessWidget {
  const DetailsAndColors({
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
    return Padding(
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
                          onTap: () =>
                              selectedColor.value = productColors[index],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: productColors[index]['hex'] is String
                                    ? Color(int.parse(
                                        '0xFF${productColors[index]['hex'].substring(1)}'))
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 20,
                              height: 30,
                              alignment: Alignment.center,
                              child: selectedColor.value == productColors[index]
                                  ? Icon(Icons.check,
                                      size: 15,
                                      color: productColors[index]['hex'] ==
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
    );
  }
}
