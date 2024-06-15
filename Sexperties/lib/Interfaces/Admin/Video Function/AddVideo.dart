import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/VideoListPage.dart';
import 'package:uuid/uuid.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  String docID = '';
  bool isClicked = false;

  //Generate ID
  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  @override
  void initState() {
    super.initState();
    docID = generateRandomId();
  }

  TextEditingController _topicController = TextEditingController();
  TextEditingController _videoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  //Check Credentials
  void _wrongCredentials() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Credential Error"),
            content: Text("Please fill all the required fields."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
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
  }

  //Create Firebase Collection
  Future addVideo(String topic, String video, String description) async {
    await FirebaseFirestore.instance.collection('Videos').doc(docID).set({
      'Video_ID': docID,
      'Video_Link': video,
      'Topic': topic,
      'Description': description,
    });
  }

  //Add Video to Firebase
  Future AddVideoToFirebase() async {
    setState(() {
      isClicked = true;
    });
    try {
      addVideo(_topicController.text, _videoController.text.trim(),
          _descriptionController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video Added Sucesss!')),
      );

      setState(() {
        isClicked = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VideoListPage()),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Video",
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
              SizedBox(
                height: 65,
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
                    labelText: 'Add Video Topic',
                    labelStyle: const TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                child: TextField(
                  controller: _videoController,
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
                    labelText: 'Add Video Link',
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
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  String topic = _topicController.text;
                  String video = _videoController.text;
                  String description = _descriptionController.text;

                  if (topic.isEmpty || video.isEmpty || description.isEmpty) {
                    _wrongCredentials();
                  } else {
                    AddVideoToFirebase();
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
                  child: isClicked
                      ? CircularProgressIndicator()
                      : Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
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
