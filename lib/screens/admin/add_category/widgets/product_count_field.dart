import 'package:flutter/material.dart';

class ProductCountField extends StatelessWidget {
  const ProductCountField({
    super.key,
    required TextEditingController productCountController,
    // TODO: private variable 
  }) : _productCountController = productCountController;

  final TextEditingController _productCountController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _productCountController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Product Count',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the product count';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
