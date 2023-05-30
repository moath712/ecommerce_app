import 'package:ecommerce_app/screens/admin/edit_product/widgets/edit_description_field.dart';
import 'package:ecommerce_app/screens/admin/edit_product/widgets/edit_price_field.dart';
import 'package:ecommerce_app/screens/admin/edit_product/widgets/edit_quantity_field.dart';
import 'package:ecommerce_app/screens/admin/edit_product/widgets/edit_subtitle_field.dart';
import 'package:ecommerce_app/screens/admin/edit_product/widgets/edit_title_field.dart';
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:ecommerce_app/services/manager/imagepicker/image_picker.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
  final ImagePickerService _imagePickerService = ImagePickerService();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.product['title']);
  late final TextEditingController _priceController =
      TextEditingController(text: widget.product['price'].toString());
  late final TextEditingController _quantityController =
      TextEditingController(text: widget.product['quantity'].toString());

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
      if (kDebugMode) {
        print("object");
      }
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
                  if (_imagePickerService.imageData != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2, color: Colors.grey),
                        ),
                        child: Center(
                          child: SizedBox(
                              width: 200,
                              height: 200,
                              child:
                                  Image.memory(_imagePickerService.imageData!)),
                        ),
                      ),
                    ),
                  if (_imagePickerService.imageData == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2, color: Colors.grey),
                        ),
                        child: Center(
                          child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.network(widget.product['imageURL'])),
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
                          await _imagePickerService.pickImage();
                          setState(() {});
                        },
                        child: const Text(
                          'Change Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  EditTitleField(titleController: _titleController),
                  EditPriceField(priceController: _priceController),
                  EditQuantityField(quantityController: _quantityController),
                  EditSubtitleField(subTitleController: _subTitleController),
                  EditDescriptionField(
                      descriptionController: _descriptionController),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA95EFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            onPressed: () async {
                              if (_imagePickerService.imageData == null) {
                                final url = widget.product['imageURL'];
                                final updatedProduct = {
                                  'title': _titleController.text,
                                  'price': int.parse(_priceController.text),
                                  'quantity':
                                      int.parse(_quantityController.text),
                                  'category': widget.category,
                                  'imageURL': url,
                                  'subTitle': _subTitleController.text,
                                  'description': _descriptionController.text,
                                };
                                await _updateProduct(widget.category,
                                    widget.productId, updatedProduct);
                              } else {
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('categories')
                                    .child(
                                        '${DateTime.now().toIso8601String()}.png');
                                await ref
                                    .putData(_imagePickerService.imageData!);
                                final url = await ref.getDownloadURL();
                                final updatedProduct = {
                                  'title': _titleController.text,
                                  'price': int.parse(_priceController.text),
                                  'quantity':
                                      int.parse(_quantityController.text),
                                  'category': widget.category,
                                  'imageURL': url,
                                  'subTitle': _subTitleController.text,
                                  'description': _descriptionController.text,
                                };

                                await _updateProduct(widget.category,
                                    widget.productId, updatedProduct);
                              }
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
                              backgroundColor: Colors.red,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
