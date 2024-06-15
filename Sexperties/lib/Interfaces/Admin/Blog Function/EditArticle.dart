import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sexpertise/Interfaces/Admin/Blog%20Function/ArticleListPage.dart';

class EditArticle extends StatefulWidget {
  final String? id;
  const EditArticle({super.key, required this.id});

  @override
  State<EditArticle> createState() => _EditArticleState();
}

class _EditArticleState extends State<EditArticle> {
  bool tapOnImage = false;
  bool isClicked = false;
  bool uploaded = false;
  String docID = '';
  String imageUrl = '';

  List<String> _myList = [];

  //String? id;

  @override
  void initState() {
    super.initState();

    docID = widget.id!;
    getData(docID);
  }

  TextEditingController _topicController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void getData(String uId) async {
    final DocumentSnapshot articleDoc =
        await FirebaseFirestore.instance.collection("Articles").doc(uId).get();

    setState(() {
      _topicController.text = articleDoc.get('Topic');
      _descriptionController.text = articleDoc.get('Description');
      imageUrl = articleDoc.get('Image');
      _myList = List<String>.from(articleDoc.get('Tags') ?? []);
    });
  }

  //Image
  File? _selectedImage;

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

    Reference referenceImageToUpload = referenceDirImages.child(docID);

    try {
      await referenceImageToUpload.putFile(File(pickedImage!.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        uploaded == true;
        isClicked = false;
      });
    } catch (e) {
      print(e);
    }
  }

  //Check Credentials
  void _wrongCredentials() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Credential Error"),
          content: Text("Please fill all the required fields."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Check Length
  void chechTagsLength() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Tags Error"),
          content: Text("Please add only 5 Tags."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Enter Tags
  void enterTags() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Empty Tags"),
          content: Text("Please Enter 5 Tags."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Enter Image
  void addImage() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Empty Image"),
          content: Text("Please Add a Image."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void checkTagsLimit() {
    if (_myList.length == 5) {
      print('The list has exactly 5 elements.');
    } else {
      print('The list does not have 5 elements.');
    }
  }

//update Firebase Collection
  Future updateAdminArticle(String topic, String description,
      List<String> myList, String imageUrl) async {
    await FirebaseFirestore.instance.collection('Articles').doc(docID).update({
      'Article_ID': docID,
      'Topic': topic,
      'Description': description,
      'Tags': myList,
      'Image': imageUrl,
    });
  }

  //Add Article to Firebase
  Future updateArticelToFirebase() async {
    setState(() {
      isClicked = true;
    });
    try {
      updateAdminArticle(
        _topicController.text.trim(),
        _descriptionController.text.trim(),
        _myList,
        imageUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article Update Sucesss!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ArticleListAdmin()),
        );
      });

      setState(() {
        isClicked = false;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        isClicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isClicked = false;
    });
  }

  //Delete Image
  Future<void> deleteImage() async {
    try {
      final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      await imageRef.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Update Article",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    tapOnImage = true;
                  });
                  deleteImage().then((_) {
                    print('Deleted Sucess!');
                    setState(() {
                      tapOnImage = false;
                    });
                    _getImageFromGallery();
                  });
                },
                child: tapOnImage
                    ? Text('Please Wait....')
                    : Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 0, 74, 173),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
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
                        child: const Center(
                          child: Text(
                            "Add Image Here\n(Tap to add a Image)",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: _topicController,
                  decoration: InputDecoration(
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
                    labelText: 'Add Article Topic',
                    labelStyle: const TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 10,
                  decoration: InputDecoration(
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
                    labelText: 'Add Description',
                    labelStyle: const TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ChipTags(
                list: _myList,
                createTagOnSubmit: true,
                decoration: InputDecoration(
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
                  labelText: 'Enter Tags (5 tags)',
                  labelStyle: const TextStyle(),
                ),
                chipColor: const Color.fromARGB(255, 0, 74, 173),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  checkTagsLimit();
                },
                child: GestureDetector(
                  onTap: () {
                    String topic = _topicController.text;
                    String description = _descriptionController.text;

                    if (topic.isEmpty || description.isEmpty) {
                      _wrongCredentials();
                    } else if (_myList.isEmpty) {
                      enterTags();
                    } else if (_myList.length > 5 || _myList.length < 5) {
                      chechTagsLength();
                      //}
                      // else if (_selectedImage != null) {
                      //   addImage();
                    } else {
                      updateArticelToFirebase();
                    }
                  },
                  child: Container(
                    height: 55,
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
                    child: Center(
                      child: isClicked
                          ? CircularProgressIndicator()
                          : Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
