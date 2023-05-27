import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/widgets/cart_icon.dart';
import 'package:ecommerce_app/screens/client/edit_profile_screen.dart/widgets/name_edit.dart';
import 'package:ecommerce_app/screens/client/edit_profile_screen.dart/widgets/number_edit.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  File? _image;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.userData['firstName'];
    _phoneNumberController.text = widget.userData['Phone Number'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(ImageAssets.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [ItemsNumber(userId: FirebaseAuth.instance.currentUser!.uid)],
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 200,
                        child: Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 232, 236, 237),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              NameField(
                                  firstNameController: _firstNameController),
                              PhoneNumber(
                                  phoneNumberController:
                                      _phoneNumberController),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                  onPressed: _updateProfile,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 95,
                        left: 0,
                        right: 0,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                radius: 80.0,
                                child: ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: widget.userData['imageUrl'] != null
                                        ? Image.network(
                                            widget.userData['imageUrl'],
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.account_circle,
                                            size: 160.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: getImage,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future getImage() async {
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

    if (_image != null) {
      uploadFile();
    }
  }

  Future<void> uploadFile() async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('userProfilePictures/${_auth.currentUser!.uid}');

      UploadTask uploadTask = ref.putFile(_image!);

      final TaskSnapshot downloadUrl =
          (await uploadTask.whenComplete(() => null));

      final String url = (await downloadUrl.ref.getDownloadURL());

      DocumentReference docRef =
          _firestore.collection('users').doc(_auth.currentUser!.uid);

      docRef.update({'imageUrl': url});

      if (kDebugMode) {
        print('URL Is: $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _updateProfile() async {
    DocumentReference docRef =
        _firestore.collection('users').doc(_auth.currentUser!.uid);

    await docRef.update({
      'firstName': _firstNameController.text,
      'Phone Number': _phoneNumberController.text,
    });
    if (context.mounted) {}
    Navigator.pop(context);
  }
}
