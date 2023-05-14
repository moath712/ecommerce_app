import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
