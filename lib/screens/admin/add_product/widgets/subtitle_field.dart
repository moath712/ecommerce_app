import 'package:ecommerce_app/style/add_edit_field/add_edit_field.dart';
import 'package:flutter/material.dart';

class SubtitleField extends StatelessWidget {
  const SubtitleField({
    super.key,
    required TextEditingController subTitleController,
  }) : _subTitleController = subTitleController;

  final TextEditingController _subTitleController;

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
    );
  }
}