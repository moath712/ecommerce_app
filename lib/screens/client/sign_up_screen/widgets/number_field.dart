import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({
    super.key,
    required TextEditingController phonenumbercontroller,
  }) : _phonenumbercontroller = phonenumbercontroller;

  final TextEditingController _phonenumbercontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _phonenumbercontroller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Phone Number';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          // TODO: Too much redundant code
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
