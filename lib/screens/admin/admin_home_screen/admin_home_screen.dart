import 'package:ecommerce_app/screens/admin/admin_home_screen/widgets/itemwidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsAdmin extends StatefulWidget {
  const ProductsAdmin({super.key});

  @override
  State<ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends State<ProductsAdmin> {
  String _selectedCategory = 'Sofa';
  late Stream<QuerySnapshot> _productStream;

  @override
  void initState() {
    super.initState();
    _updateProductStream(_selectedCategory);
  }

  void _updateProductStream(String categoryName) {
    _productStream = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryName)
        .collection('products')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth ~/ 250;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          body: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        //categories dropdown
                        Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('categories')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center();
                                    }

                                    List<String> categories = snapshot
                                        .data!.docs
                                        .map((doc) => doc['name'] as String)
                                        .toList();

                                    return Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        value: _selectedCategory,
                                        hint: const Text('Choose Category'),
                                        icon: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.keyboard_double_arrow_down,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                        underline: const SizedBox(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCategory = newValue!;
                                            _updateProductStream(newValue);
                                          });
                                        },
                                        items: categories
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  letterSpacing: 0.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //items Gridview
                        SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height - 200,
                            width: MediaQuery.of(context).size.width,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _productStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Something went wrong'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 4,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final product = snapshot.data!.docs[index]
                                        .data() as Map<String, dynamic>;

                                    return Itemwidget(product: product, selectedCategory: _selectedCategory);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
