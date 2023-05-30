
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';

class EditTitleField extends StatelessWidget {
  const EditTitleField({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: CustomBoxDecoration(),
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
    );
  }
}
