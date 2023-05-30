import 'package:ecommerce_app/style/app_style.dart';
import 'package:flutter/material.dart';

class StreetNameField extends StatelessWidget {
  const StreetNameField({
    super.key,
    required TextEditingController streetname,
  }) : _streetname = streetname;

  final TextEditingController _streetname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _streetname,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Street name';
          }
          return null;
        },
        decoration: AppStyles.formStyle(
          context,
          'Street name',
        ),
      ),
    );
  }
}
