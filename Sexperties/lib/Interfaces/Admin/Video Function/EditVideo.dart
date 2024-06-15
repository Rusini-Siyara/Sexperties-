import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/VideoListPage.dart';

class EditVideo extends StatefulWidget {
  final String? id;
  const EditVideo({super.key, required this.id});

  @override
  State<EditVideo> createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  bool isClicked = false;
  String docID = '';

  TextEditingController _topicController = TextEditingController();
  TextEditingController _videoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    docID = widget.id!;
    getData(docID);
  }

  void getData(String uId) async {
    final DocumentSnapshot videoDoc =
        await FirebaseFirestore.instance.collection("Videos").doc(uId).get();

    setState(() {
      _topicController.text = videoDoc.get('Topic');
      _descriptionController.text = videoDoc.get('Description');
      _videoController.text = videoDoc.get('Video_Link');
    });
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

  Future updateVideo(String topic, String video, String description) async {
    await FirebaseFirestore.instance.collection('Videos').doc(docID).update({
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
      updateVideo(_topicController.text, _videoController.text.trim(),
          _descriptionController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video Updated Sucesss!')),
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
          "Edit Video",
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
                            'Save Changes',
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
