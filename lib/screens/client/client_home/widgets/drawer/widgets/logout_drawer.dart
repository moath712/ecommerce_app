import 'package:ecommerce_app/screens/client/welcome_screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
    );
  }
}
