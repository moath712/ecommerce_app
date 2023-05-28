import 'package:ecommerce_app/screens/client/client_home/client_home_screen.dart';
import 'package:ecommerce_app/screens/client/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAuthentication extends StatefulWidget {
  const CheckAuthentication({super.key});

  @override
  State<CheckAuthentication> createState() => _CheckAuthenticationState();
}

class _CheckAuthenticationState extends State<CheckAuthentication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClientHome()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
