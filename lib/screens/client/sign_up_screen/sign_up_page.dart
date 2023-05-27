import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/client/client_home/client_home_screen.dart';
import 'package:ecommerce_app/screens/client/sign_up_screen/widgets/address_field.dart';
import 'package:ecommerce_app/screens/client/sign_up_screen/widgets/email_field.dart';
import 'package:ecommerce_app/screens/client/sign_up_screen/widgets/name_field.dart';
import 'package:ecommerce_app/screens/client/sign_up_screen/widgets/number_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

File? _image;
final picker = ImagePicker();

class _SignUpScreenState extends State<SignUpScreen> {
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  bool _isHidden = true;
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final email = _emailController.text;
      final password = _passwordController.text;
      final address = _addressController.text;
      final firstName = _firstNameController.text;
      final phoneNumber = _phonenumbercontroller.text;
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('${result.user!.uid}.jpg');

        await ref.putFile(_image!);

        final url = await ref.getDownloadURL();

        await firestore.collection('users').doc(result.user!.uid).set({
          'firstName': firstName,
          'uid': result.user!.uid,
          'address': address,
          'Phone Number': phoneNumber,
          'imageUrl': url,
        });
      } else {
        await firestore.collection('users').doc(result.user!.uid).set({
          'firstName': firstName,
          'uid': result.user!.uid,
          'Phone Number': phoneNumber,
        });
      }
      if (context.mounted) {}
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClientHome()),
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'StyleMySpace',
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 80.0,
                  child: ClipOval(
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.account_circle, size: 160.0),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueGrey.shade900,
                  backgroundColor: const Color(0xFFA95EFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                onPressed: pickImage,
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            EmailField(emailController: _emailController),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isHidden,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _isHidden = !_isHidden),
                    icon: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            NameWidget(firstNameController: _firstNameController),
            NumberWidget(phonenumbercontroller: _phonenumbercontroller),
            AddressField(
              addressController: _addressController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blueGrey.shade900,
                backgroundColor: const Color(0xFFA95EFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: _signUp,
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
