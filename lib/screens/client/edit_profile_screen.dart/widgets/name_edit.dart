import 'package:flutter/material.dart';

class NameEdit extends StatelessWidget {
  const NameEdit({
    super.key,
    required TextEditingController firstNameController,
  }) : _firstNameController = firstNameController;

  final TextEditingController _firstNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 75, bottom: 16, right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 236, 237),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 2, color: Colors.deepPurpleAccent),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _firstNameController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
