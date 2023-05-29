

import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Container(
       decoration: CustomBoxDecoration(),
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
    );
  }
}