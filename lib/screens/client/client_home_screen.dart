import 'package:ecommerce_app/screens/client/all_products.dart';
import 'package:ecommerce_app/screens/client/cart/cart_page.dart';
import 'package:ecommerce_app/screens/client/orders/user_orders_screen.dart';
import 'package:ecommerce_app/screens/client/products_screen.dart';
import 'package:ecommerce_app/screens/client/profile_screen/profile_page.dart';
import 'package:ecommerce_app/screens/client/sign_in_page.dart';
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
      key: _scaffoldKey,
      drawer: Drawer(
        child: FutureBuilder<User?>(
          future: Future.value(auth.currentUser),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(snapshot.data!.uid)
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                child: ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: userData['photoUrl'] != null
                                        ? Image.network(
                                            userData['photoUrl'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return const Icon(
                                                  Icons.account_circle,
                                                  size: 80.0);
                                            },
                                          )
                                        : const Icon(Icons.account_circle,
                                            size: 80.0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                userData['firstName'],
                                style: const TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text(
                            'profile',
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserProfilePage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.list),
                          title: const Text(
                            'Orders',
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserOrdersPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Image.asset(ImageAssets.menu),
                ),
                IconButton(
                  icon: Image.asset(ImageAssets.bag),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
              ],
            ),
          ),
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
          SizedBox(
            height: 200,
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('categories').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var doc = snapshot.data!.docs[index];
                    String title = doc['name'];
                    String image = doc['imageUrl'];
                    int numOfProducts = doc['productCount'];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryProducts(categoryName: title),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 232, 236, 237),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      ' $numOfProducts+ Products',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
          const Expanded(child: AllProductsGrid())
        ],
      ),
    );
  }
}
