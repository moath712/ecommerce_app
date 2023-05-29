import 'package:ecommerce_app/screens/client/profile_screen/profile_page.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text(
        'profile',
        style: TextStyle(fontSize: 22),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfilePage()),
        );
      },
    );
  }
}
