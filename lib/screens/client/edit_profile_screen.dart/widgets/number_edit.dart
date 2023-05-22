import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({
    super.key,
    required TextEditingController phoneNumberController,
  }) : _phoneNumberController = phoneNumberController;

  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
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
                Icons.phone_android,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _phoneNumberController,
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
