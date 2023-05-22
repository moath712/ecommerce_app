import 'package:ecommerce_app/screens/client/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutDrawer extends StatelessWidget {
  const LogoutDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text(
        'Logout',
        style: TextStyle(fontSize: 22),
      ),
      onTap: () async {
        try {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {}
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
