import 'package:ecommerce_app/widgets/cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/screens/client/edit_profile_screen.dart/edit_profile.dart';
import 'dart:io';

import '../../../style/assets_manager.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Makes the AppBar transparent
        elevation: 0, // Removes the shadow beneath the AppBar
        leading: IconButton(
          icon: Image.asset(ImageAssets.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [ItemsNumber(userId: FirebaseAuth.instance.currentUser!.uid)],
      ),
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
                                        // TODO: Why is the icon button here?
                                        icon: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        '${data['firstName']}',
                                        style: const TextStyle(fontSize: 18),
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
                                      Text(
                                        '${data['Phone Number']}',
                                        style: const TextStyle(fontSize: 18),
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
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        '${_auth.currentUser!.email}',
                                        style: const TextStyle(fontSize: 18),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePage(userData: data),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Edit Profile ',
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
                                    child: data['imageUrl'] != null
                                        ? Image.network(
                                            data['imageUrl'],
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.account_circle,
                                            size:
                                                160.0), // Adjust the icon size as needed
                                  ),
                                ),
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

      docRef.update({'photoUrl': url});

      if (kDebugMode) {
        print('URL Is: $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
