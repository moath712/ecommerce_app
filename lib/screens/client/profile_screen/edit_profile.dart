import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({required this.userData});

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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 70, bottom: 0, right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(ImageAssets.back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(ImageAssets.bag),
                      ),
                    ],
                  ),
                ),
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 75, bottom: 16, right: 8, left: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 232, 236, 237),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.deepPurpleAccent),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, bottom: 16, right: 8, left: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 232, 236, 237),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.deepPurpleAccent),
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
                                    child: Image.network(
                                      data['photoUrl'],
                                      fit: BoxFit.cover,
                                    ),
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
        print('No image selected.');
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

      docRef.update({'photoUrl': url});

      print('URL Is: $url');
    } catch (e) {
      print(e);
    }
  }

  void _updateProfile() async {
    DocumentReference docRef =
        _firestore.collection('users').doc(_auth.currentUser!.uid);

    await docRef.update({
      'firstName': _firstNameController.text,
      'Phone Number': _phoneNumberController.text,
    });

    Navigator.pop(context);
  }
}
