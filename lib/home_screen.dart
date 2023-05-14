import 'package:ecommerce_app/screens/admin/admin_home_screen.dart';
import 'package:ecommerce_app/screens/client/welcome_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void main() => runApp(const MyHomePage());

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: Scaffold(
        body: Center(
          child: kIsWeb ? AdminHome() : WelcomeScreen(),
        ),
      ),
    );
  }
}
