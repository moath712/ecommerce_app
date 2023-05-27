import 'package:flutter/material.dart';

class CategoryNameField extends StatelessWidget {
  const CategoryNameField({
    super.key,
    required TextEditingController categoryController,
  }) : _categoryController = categoryController;

  final TextEditingController _categoryController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Category Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
