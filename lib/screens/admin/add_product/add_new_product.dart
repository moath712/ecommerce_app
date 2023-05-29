import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/build_color_check_boxes.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/title_field.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/description_field.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/price_field.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/quantity_field.dart';
import 'package:ecommerce_app/screens/admin/add_product/widgets/subtitle_field.dart';
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:ecommerce_app/services/manager/color_list/color_list.dart';
import 'package:ecommerce_app/services/manager/imagepicker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

final Map<String, String> _colorHexValues = ColorUtils.generateColorHexValues();

final ImagePickerService _imagePickerService = ImagePickerService();

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _subTitleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<Map<String, String>> _selectedColorsWithHex = [];

  String _selectedCategory = "";
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('categories')
          .child('${DateTime.now().toIso8601String()}.png');

      await ref.putData(_imagePickerService.imageData!);

      final url = await ref.getDownloadURL();
      final product = {
        'title': _titleController.text,
        'price': int.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'category': _selectedCategory,
        'imageURL': url,
        'subTitle': _subTitleController.text,
        'description': _descriptionController.text,
        'colors': _selectedColorsWithHex.toList(),
      };

      // Create a new document and get reference
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('categories')
          .doc(_selectedCategory)
          .collection("products")
          .add(product);

      // Update the product with its ID
      await docRef.update({'productId': docRef.id});

      _titleController.clear();

      _priceController.clear();
      _categoryController.clear();
      _imageController.clear();
      _subTitleController.clear();
      _descriptionController.clear();
      _quantityController.clear();
      _selectedColorsWithHex.clear();
    }
    if (context.mounted) {}
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 236, 237),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "Add your new product details :",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              if (_imagePickerService.imageData != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Container(
                                    decoration: CustomBoxDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Center(
                                        child: SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Image.memory(
                                                _imagePickerService
                                                    .imageData!)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (_imagePickerService.imageData == null)
                                GestureDetector(
                                  onTap: () async {
                                    await _imagePickerService.pickImage();
                                    setState(() {});
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2, color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Center(
                                            child: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.camera),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Click here to add a picture")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              TitleField(titleController: _titleController),
                              PriceField(priceController: _priceController),
                              QuantityField(
                                  quantityController: _quantityController),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Container(
                                  decoration: CustomBoxDecoration(),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('categories')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Text("Loading...");
                                          }

                                          List<String> items = snapshot
                                              .data!.docs
                                              .map((doc) =>
                                                  doc['name'] as String)
                                              .toList();

                                          if (_selectedCategory.isEmpty &&
                                              items.isNotEmpty) {
                                            _selectedCategory = items.first;
                                          }

                                          return DropdownButtonFormField<
                                              String>(
                                            value: _selectedCategory,
                                            items: items.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedCategory = newValue!;
                                              });
                                            },
                                          );
                                        },
                                      )),
                                ),
                              ),
                              SubtitleField(
                                  subTitleController: _subTitleController),
                              DescriptionField(
                                  descriptionController:
                                      _descriptionController),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "choose the color:",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _colorHexValues.entries
                                      .map((entry) => ColorCheckbox(
                                            entry: entry,
                                            selectedColorsWithHex:
                                                _selectedColorsWithHex,
                                          ))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Center(
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
                                  onPressed: _submitForm,
                                  child: const Text(
                                    'Add Product',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
