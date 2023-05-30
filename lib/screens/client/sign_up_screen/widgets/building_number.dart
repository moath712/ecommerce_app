import 'package:ecommerce_app/style/app_style.dart';
import 'package:flutter/material.dart';

class BuildingNumberField extends StatelessWidget {
  const BuildingNumberField({
    super.key,
    required TextEditingController buildingNumber,
  }) : _buildingNumber = buildingNumber;

  final TextEditingController _buildingNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _buildingNumber,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your building number';
          }
          return null;
        },
        decoration: AppStyles.formStyle(
          context,
          'building number',
        ),
      ),
    );
  }
}
