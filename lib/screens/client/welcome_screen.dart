import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'home_widgets/forgot_password.dart';
import 'home_widgets/login_btn.dart';
import 'home_widgets/sign_up_btn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xffFEDCE0),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    ImageAssets.welcome,
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Style My Space",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SignUpButton(),
                const SizedBox(height: 18),
                const LoginButton(),
                const SizedBox(height: 5),
                const ForgotPassword(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
