
import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';

class EditSubtitleField extends StatelessWidget {
  const EditSubtitleField({
    super.key,
    required TextEditingController subTitleController,
  }) : _subTitleController = subTitleController;

  final TextEditingController _subTitleController;

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
            controller: _subTitleController,
            decoration: const InputDecoration(
              labelText: 'Sub Title',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}