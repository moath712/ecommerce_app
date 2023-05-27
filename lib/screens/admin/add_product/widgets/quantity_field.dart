import 'package:flutter/material.dart';

class QuantityField extends StatelessWidget {
  const QuantityField({
    super.key,
    required TextEditingController quantityController,
  }) : _quantityController = quantityController;

  final TextEditingController _quantityController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(width: 2, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the quantity';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}