import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sexpertise/Interfaces/Admin/AdminSettings.dart';

class EditAdminAccount extends StatefulWidget {
  final String userIDE;
  const EditAdminAccount({super.key, required this.userIDE});

  @override
  State<EditAdminAccount> createState() => _EditAdminAccountState();
}

class _EditAdminAccountState extends State<EditAdminAccount> {
  String? userID;
  File? _selectedImage;
  bool isClicked = false;
  //
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    userID = widget.userIDE;
    getData(userID!);
  }

  //Image
  Future _getImageFromGallery() async {
    setState(() {
      isClicked = true;
    });
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 60);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }

    //String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(userID!);

    try {
      await referenceImageToUpload.putFile(File(pickedImage!.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        isClicked = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void getData(String uId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(uId).get();

    setState(() {
      _userNameController.text = userDoc.get('Name');
      _emailController.text = userDoc.get('Email');
      _birthdayController.text = userDoc.get('Birth_Day');
      _phoneNoController.text = userDoc.get('Phone_Number');
      _addressController.text = userDoc.get('Address');
      imageUrl = userDoc.get('Profile_Image');
    });
  }

  //Update
  Future updateUserDetails(String name, String address, String phone,
      String birthdat, String image) async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'Name': name,
      'Phone_Number': phone,
      'Birth_Day': birthdat,
      'Address': address,
      'Profile_Image': image,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Update Completed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Details",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              //Profile Image
              GestureDetector(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      width: 2,
                    ),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage('$imageUrl'),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Center(
                    child: Text(
                      "Tap to edit image",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 0, 74, 173),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 74, 173),
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(),
                  ),
                ),
              ),

              ///B
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 55,
                child: TextField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 0, 74, 173),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 74, 173),
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Birthday',
                    labelStyle: TextStyle(),
                  ),
                ),
              ),

              //M
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 55,
                child: TextField(
                  controller: _phoneNoController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 0, 74, 173),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 74, 173),
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Mobile No',
                    labelStyle: TextStyle(),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                height: 55,
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 0, 74, 173),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 74, 173),
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Address',
                    labelStyle: TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Save Button
              GestureDetector(
                onTap: () {
                  updateUserDetails(
                      _userNameController.text,
                      _addressController.text,
                      _phoneNoController.text,
                      _birthdayController.text,
                      imageUrl);

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminSettings(
                                uID: userID!,
                              )),
                    );
                  });
                },
                child: Container(
                  height: 55,
                  width: screenWidth - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 35, 60, 135),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(63, 0, 0, 0),
                      ),
                    ],
                  ),
                  child: isClicked
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
