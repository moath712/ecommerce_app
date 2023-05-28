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
        decoration: InputDecoration(
          labelText: 'Address',
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFA95EFA),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFA95EFA),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFA95EFA),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFA95EFA),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
