import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityField extends StatelessWidget {
  const QuantityField({
    super.key,
    required TextEditingController quantityController,
  }) : _quantityController = quantityController;

  final TextEditingController _quantityController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
       decoration: CustomBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
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
