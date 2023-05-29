
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatelessWidget {
  const PriceField({
    super.key,
    required TextEditingController priceController,
  }) : _priceController = priceController;

  final TextEditingController _priceController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Container(
      decoration: CustomBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: TextFormField(
              inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}