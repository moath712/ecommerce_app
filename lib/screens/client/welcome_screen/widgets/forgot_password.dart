import 'package:ecommerce_app/screens/client/forgot_password/forgot_passowrd.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordResetWidget()),
        );
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
