import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _subTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Chair',
    'Sofa',
  ];

  final Map<String, String> _colorHexValues = {
    'Red': '#FF0000',
    'Blue': '#0000FF',
    'Green': '#008000',
    'Yellow': '#FFFF00',
    'Black': '#000000',
    'White': '#FFFFFF',
  };

  final List<Map<String, String>> _selectedColorsWithHex = [];

  List<Widget> _buildColorCheckboxes() {
    return _colorHexValues.entries.map((entry) {
      return CheckboxListTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Color(int.parse('0xFF${entry.value.substring(1)}')),
              radius: 10,
            ),
            const SizedBox(width: 10),
            Text(entry.key),
          ],
        ),
        value: _selectedColorsWithHex
            .any((element) => element['color'] == entry.key),
        onChanged: (bool? newValue) {
          setState(() {
            if (newValue!) {
              _selectedColorsWithHex.add(
                {'color': entry.key, 'hex': entry.value},
              );
            } else {
              _selectedColorsWithHex
                  .removeWhere((element) => element['color'] == entry.key);
            }
          });
        },
      );
    }).toList();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String categoryName = '';
      if (_selectedCategoryIndex == 0) {
        categoryName = 'Chair';
      } else if (_selectedCategoryIndex == 1) {
        categoryName = 'Sofa';
      }
      final product = {
        'title': _titleController.text,
        'price': int.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'category': categoryName,
        'imageURL': _imageController.text,
        'subTitle': _subTitleController.text,
        'description': _descriptionController.text,
        'colors': _selectedColorsWithHex.toList(),
      };

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryName)
          .collection("products")
          .add(product);

      _titleController.clear();
      _priceController.clear();
      _categoryController.clear();
      _imageController.clear();
      _subTitleController.clear();
      _descriptionController.clear();
      _quantityController.clear();
      _selectedColorsWithHex.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added succefully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                    "Add your new product details :",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: InputBorder.none,
                        ),
                        value: _selectedCategoryIndex,
                        items: _categories
                            .asMap()
                            .entries
                            .map((entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryIndex = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _subTitleController,
                        decoration: const InputDecoration(
                          labelText: 'Subtitle',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a subtitle';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 236, 237),
                      borderRadius: BorderRadius.circular(25),
                      border:
                          Border.all(width: 2, color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "choose the color:",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildColorCheckboxes(),
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
    );
  }
}
