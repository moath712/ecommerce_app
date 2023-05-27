import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required TextEditingController descriptionController,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(width: 2, color: Colors.grey),
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
    );
  }
}