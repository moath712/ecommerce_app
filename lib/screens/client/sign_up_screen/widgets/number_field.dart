import 'package:ecommerce_app/style/app_style.dart';
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
        ],
        decoration: AppStyles.formStyle(
          context,
          'Phone number',
        ),
      ),
    );
  }
}
