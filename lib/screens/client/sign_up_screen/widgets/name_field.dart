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
        decoration: InputDecoration(
          labelText: 'Name',
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
