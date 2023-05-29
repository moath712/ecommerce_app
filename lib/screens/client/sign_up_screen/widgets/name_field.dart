import 'package:ecommerce_app/style/app_style.dart';
import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({
    super.key,
    required TextEditingController firstNameController,
  }) : _firstNameController = firstNameController;

  final TextEditingController _firstNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _firstNameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Name';
          }
          return null;
        },
       decoration: AppStyles.formStyle(
          context,
          'Name',
        ),
      ),
    );
  }
}
