import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin/admin_home_screen/widgets/itemwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = StreamProvider.family
    .autoDispose<QuerySnapshot, String>((ref, categoryName) {
  return FirebaseFirestore.instance
      .collection('categories')
      .doc(categoryName)
      .collection('products')
      .snapshots();
});

final categoryProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('categories').snapshots();
});

class ProductsAdmin extends StatefulWidget {
  const ProductsAdmin({super.key});

  @override
  State<ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends State<ProductsAdmin> {
  String _selectedCategory = 'Sofa';

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
                                child: Consumer(
                                  builder: (context, WidgetRef ref, child) {
                                    final snapshot =
                                        ref.watch(categoryProvider);
                                    return snapshot.when(
                                      data: (QuerySnapshot data) {
                                        List<String> categories = data.docs
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
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_double_arrow_down,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20),
                                            underline: const SizedBox(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedCategory = newValue!;
                                              });
                                            },
                                            items: categories
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                      loading: () => const Center(),
                                      error: (error, stack) =>
                                          const Text('Something went wrong'),
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
                            child: Consumer(
                              builder: (context, WidgetRef ref, child) {
                                final snapshot = ref
                                    .watch(productProvider(_selectedCategory));
                                return snapshot.when(
                                  data: (QuerySnapshot data) {
                                    return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 0.7,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 4,
                                      ),
                                      itemCount: data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final product = data.docs[index].data()
                                            as Map<String, dynamic>;

                                        return Itemwidget(
                                            product: product,
                                            selectedCategory:
                                                _selectedCategory);
                                      },
                                    );
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (error, stack) => const Center(
                                      child: Text('Something went wrong')),
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
