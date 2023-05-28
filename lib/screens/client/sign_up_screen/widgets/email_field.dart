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
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(   color: Color(0xFFA95EFA),),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(   color: Color(0xFFA95EFA),),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(   color: Color(0xFFA95EFA),),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(   color: Color(0xFFA95EFA),),
            borderRadius: BorderRadius.circular(25),
          ),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
