
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin/edit_product/edit_product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Itemwidget extends StatelessWidget {
  const Itemwidget({
    super.key,
    required this.product,
    required String selectedCategory,
  }) : _selectedCategory = selectedCategory;

  final Map<String, dynamic> product;
  final String _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height:
            MediaQuery.of(context).size.height /
                2.0,
        width:
            MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 140,
              width: 180,
              child: Image.network(
                product['imageURL'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(
                            2.0),
                    child: Text(
                      product['title'],
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(
                            2.0),
                    child: Text(
                      '\$ ${product['price']}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w800),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors.white,
                          shape:
                              const RoundedRectangleBorder(
                            side: BorderSide(
                                color:
                                    Colors.grey,
                                width: 1),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EditProductScreen(
                                          productId:
                                              product['productId'],
                                          product:
                                              product,
                                          category:
                                              _selectedCategory,
                                        )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: const [
                            Icon(
                              Icons.edit,
                              color:
                                  Colors.grey,
                              size: 18.0,
                            ),
                            Text(
                              "Edit",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors.white,
                          shape:
                              const RoundedRectangleBorder(
                            side: BorderSide(
                                color:
                                    Colors.grey,
                                width: 1),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext
                                    context) {
                              return AlertDialog(
                                title: const Text(
                                    'Confirm deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this product?'),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                        'Cancel'),
                                    onPressed:
                                        () {
                                      Navigator.of(
                                              context)
                                          .pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                        'Delete'),
                                    onPressed:
                                        () {
                                      _deleteProduct(
                                        _selectedCategory,
                                        product[
                                            'productId'],
                                      );
                                      Navigator.of(
                                              context)
                                          .pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 18.0,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .red),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _deleteProduct(String categoryName, String productId) async {
  try {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryName)
        .collection('products')
        .doc(productId)
        .delete();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
