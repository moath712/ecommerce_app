import 'package:ecommerce_app/style/app_style.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email address';
          }
          return null;
        },
        decoration: AppStyles.formStyle(
          context,
          'Email',
        ),
      ),
    );
  }
}
