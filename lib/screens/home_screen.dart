import 'package:ecommerce_app/screens/client/client_login_checker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'admin/home_screen.dart';

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
          child: kIsWeb ? AdminPage() : CheckAuthentication(),
        ),
      ),
    );
  }
}
