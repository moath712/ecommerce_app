
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPriceField extends StatelessWidget {
  const EditPriceField({
    super.key,
    required TextEditingController priceController,
  }) : _priceController = priceController;

  final TextEditingController _priceController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: CustomBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
