import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;
  final String category;

  const EditProductScreen(
      {super.key,
      required this.product,
      required this.productId,
      required this.category});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.product['title']);
  late final TextEditingController _priceController =
      TextEditingController(text: widget.product['price'].toString());
  late final TextEditingController _quantityController =
      TextEditingController(text: widget.product['quantity'].toString());
  late final TextEditingController _imageController =
      TextEditingController(text: widget.product['imageURL']);
  late final TextEditingController _subTitleController =
      TextEditingController(text: widget.product['subTitle']);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.product['description']);

  Future<void> _updateProduct(
      String category, String productId, Map<String, dynamic> product) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category)
        .collection("products")
        .doc(productId)
        .update(product);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(ImageAssets.back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Edit your product details :",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _imageController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _subTitleController,
                          decoration: const InputDecoration(
                            labelText: 'Sub Title',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 236, 237),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: InputBorder.none,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueGrey.shade900,
                          backgroundColor: const Color(0xFFA95EFA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                        ),
                        onPressed: () async {
                          final updatedProduct = {
                            'title': _titleController.text,
                            'price': int.parse(_priceController.text),
                            'quantity': int.parse(_quantityController.text),
                            'category': widget.category,
                            'imageURL': _imageController.text,
                            'subTitle': _subTitleController.text,
                            'description': _descriptionController.text,
                          };

                          await _updateProduct(widget.category,
                              widget.productId, updatedProduct);
                          if (context.mounted) {}
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Update Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueGrey.shade900,
                          backgroundColor: const Color(0xFFA95EFA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this product?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      _deleteProduct(
                                        widget.category,
                                        widget.productId,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Delete Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
