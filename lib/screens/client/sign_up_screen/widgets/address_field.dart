import 'package:ecommerce_app/style/app_style.dart';
import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  const AddressField({
    super.key,
    required TextEditingController addressController,
  }) : _addressController = addressController;

  final TextEditingController _addressController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email address';
          }
          return null;
        },
        decoration: AppStyles.formStyle(
          context,
          'Address',
        ),
      ),
    );
  }
}
