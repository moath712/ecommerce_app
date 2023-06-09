import 'package:ecommerce_app/screens/client/all_products/all_products.dart';
import 'package:ecommerce_app/widgets/cart_icon.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/categories_bar.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/drawer/widgets/logout_drawer.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/drawer/widgets/orders_drawer.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/drawer/widgets/profile_drawer.dart';
import 'package:ecommerce_app/screens/client/client_home/widgets/drawer/widgets/user_drawer_data.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final String _selectedCategory = 'Chair';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _updateProductStream(_selectedCategory);
  }

  void _updateProductStream(String categoryName) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Image.asset(ImageAssets.menu),
        ),
        actions: [ItemsNumber(userId: FirebaseAuth.instance.currentUser!.uid)],
      ),
      key: _scaffoldKey,
      drawer: DrawerWidget(auth: auth, firestore: firestore),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Browse by categories",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff171717)),
              ),
            ),
            CategoriesBar(firestore: firestore),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(255, 232, 236, 237),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recommands For You",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff171717)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const AllProductsGrid()
          ],
        ),
      ),
    );
  }
}


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.auth,
    required this.firestore,
  });

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
                      const ProfileDrawer(),
                      const OrdersDrawer(),
                      const LogoutDrawer(),
                    ],
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator()),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(child: CircularProgressIndicator())),
            );
          }
        },
      ),
    );
  }
}
