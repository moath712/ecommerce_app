import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/drawer/widgets/user_drawer_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.auth,
    required this.firestore,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<User?>(
        future: Future.value(auth.currentUser),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: firestore
                  .collection('users')
                  .doc(snapshot.data?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(0xFFA95EFA),
                        ),
                        child: DrawerData(userData: userData),
                      ),
                      ListTile(
                        leading: Icon(icon),
                        title: Text(
                          text,
                          style: const TextStyle(fontSize: 22),
                        ),
                        onTap: onTap,
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
