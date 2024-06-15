import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  bool isClicked = false;
  String docID = '';

  @override
  void initState() {
    super.initState();
    docID = generateRandomId();
    print(docID);
  }

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  TextEditingController _questionController = TextEditingController();
  TextEditingController _answer01Controller = TextEditingController();
  TextEditingController _answer02Controller = TextEditingController();
  TextEditingController _answer03Controller = TextEditingController();
  TextEditingController _answer04Controller = TextEditingController();
  TextEditingController _correctAnswerController = TextEditingController();

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

  void _answerError() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Answer Error"),
            content: Text("Please check correct answer!"),
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
            title: Text("Answer Error"),
            content: Text("Please check correct answer!"),
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

  Future addQuestion(String mQuestion, String mAnswer_01, String mAnswer_02,
      String mAnswer_03, String mAnswer_04, String mCorrect_Answer) async {
    await FirebaseFirestore.instance.collection('Questions').doc(docID).set({
      'Question': mQuestion,
      'Answer_01': mAnswer_01,
      'Answer_02': mAnswer_02,
      'Answer_03': mAnswer_03,
      'Answer_04': mAnswer_04,
      'Correct_Answer': mCorrect_Answer,
      'Doc_ID': docID,
    });
  }

  Future AddQuestionToFirebase() async {
    setState(() {
      isClicked = true;
    });
    try {
      addQuestion(
          _questionController.text.trim(),
          _answer01Controller.text.trim(),
          _answer02Controller.text.trim(),
          _answer03Controller.text.trim(),
          _answer04Controller.text.trim(),
          _correctAnswerController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question Added Sucesss!')),
      );

      setState(() {
        isClicked = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddQuestion()),
        );
      });

      // Clear the text fields after successful
      // _questionController.clear();
      // _answer01Controller.clear();
      // _answer02Controller.clear();
      // _answer03Controller.clear();
      // _answer04Controller.clear();
      // _correctAnswerController.clear();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Question',
          style: TextStyle(
            fontSize: 23,
            color: Color.fromRGBO(0, 74, 173, 1),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 244, 246, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 244, 246, 255),
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth - 30,
                height: 120,
                child: TextField(
                  controller: _questionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Please Type Your Question Here',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth - 30,
                height: 100,
                child: TextField(
                  controller: _answer01Controller,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Answer 01 - Type Here',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth - 30,
                height: 100,
                child: TextField(
                  controller: _answer02Controller,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Answer 02 - Type Here',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth - 30,
                height: 100,
                child: TextField(
                  controller: _answer03Controller,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Answer 03 - Type Here',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth - 30,
                height: 100,
                child: TextField(
                  controller: _answer04Controller,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Answer 04 - Type Here',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: screenWidth - 30,
                height: 100,
                child: TextField(
                  controller: _correctAnswerController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'Correct Answer - Type Here',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  String question = _questionController.text.trim();
                  String answer01 = _answer01Controller.text.trim();
                  String answer02 = _answer02Controller.text.trim();
                  String answer03 = _answer03Controller.text.trim();
                  String answer04 = _answer04Controller.text.trim();
                  String correctAnswer = _correctAnswerController.text.trim();

                  if (question.isEmpty ||
                      answer01.isEmpty ||
                      answer02.isEmpty ||
                      answer03.isEmpty ||
                      answer04.isEmpty ||
                      correctAnswer.isEmpty) {
                    _wrongCredentials();
                  } else if (answer01 == correctAnswer ||
                      answer02 == correctAnswer ||
                      answer03 == correctAnswer ||
                      answer04 == correctAnswer) {
                    print('Matching All');
                    AddQuestionToFirebase();
                  } else {
                    _answerError();
                  }
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
                  child: Center(
                    child: isClicked
                        ? CircularProgressIndicator()
                        : Text(
                            'Add as a Question',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
