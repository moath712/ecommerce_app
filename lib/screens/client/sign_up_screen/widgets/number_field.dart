import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({
    Key? key,
    required TextEditingController phonenumbercontroller,
  })  : _phonenumbercontroller = phonenumbercontroller,
        super(key: key);

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
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        decoration: InputDecoration(
          labelText: 'Phone Number',
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
