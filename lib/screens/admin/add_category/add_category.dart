import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/manager/imagepicker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce_app/screens/admin/add_category/widgets/cateory_name.dart';

import 'package:flutter/material.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({super.key});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create a reference
      final ref = FirebaseStorage.instance
          .ref()
          .child('categories')
          .child('${DateTime.now().toIso8601String()}.png');

      await ref.putData(_imagePickerService.imageData!);

      final url = await ref.getDownloadURL();

      final category = {
        'name': _categoryController.text,
        'imageUrl': url,
      };

      await FirebaseFirestore.instance.collection('categories').add(category);

      _categoryController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 236, 237),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Add a new category :",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
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
                                width: MediaQuery.of(context).size.width / 2,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                          Text("Click here to add a picture")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      if (_imagePickerService.imageData != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2, color: Colors.grey),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image.memory(
                                        _imagePickerService.imageData!)),
                              ),
                            ),
                          ),
                        ),
                      CategoryNameField(
                          categoryController: _categoryController),
                      const SizedBox(height: 16.0),
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
                            onPressed: _submitForm,
                            child: const Text(
                              'Add Category',
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
        ),
      ),
    );
  }
}
