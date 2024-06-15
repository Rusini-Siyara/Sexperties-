import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/AdminQuizList.dart';

class QuizEditPage extends StatefulWidget {
  final String quizNum;
  const QuizEditPage({super.key, required this.quizNum});

  @override
  State<QuizEditPage> createState() => _QuizEditPageState();
}

class _QuizEditPageState extends State<QuizEditPage> {
  bool isClicked = false;
  bool isLoading = false;

  @override
  void initState() {
    getData(widget.quizNum);
    super.initState();
  }

  TextEditingController _questionController = TextEditingController();
  TextEditingController _answer01Controller = TextEditingController();
  TextEditingController _answer02Controller = TextEditingController();
  TextEditingController _answer03Controller = TextEditingController();
  TextEditingController _answer04Controller = TextEditingController();
  TextEditingController _correctAnswerController = TextEditingController();

  void deleteQuiz(String uID) {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection("Questions").doc(uID).delete();

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Question Deleted!'),
        backgroundColor: Colors.redAccent,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminQuizList()),
      );
    });
  }

  void getData(String uId) async {
    setState(() {
      isLoading = true;
    });
    final DocumentSnapshot questionsDoc =
        await FirebaseFirestore.instance.collection("Questions").doc(uId).get();

    setState(() {
      _questionController.text = questionsDoc.get('Question');
      _answer01Controller.text = questionsDoc.get('Answer_01');
      _answer02Controller.text = questionsDoc.get('Answer_02');
      _answer03Controller.text = questionsDoc.get('Answer_03');
      _answer04Controller.text = questionsDoc.get('Answer_04');
      _correctAnswerController.text = questionsDoc.get('Correct_Answer');
    });
    setState(() {
      isLoading = false;
    });
  }

  void _deleteQuizComfirmation() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Alert"),
            content: Text("Do you want to delete this question?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  deleteQuiz(widget.quizNum);
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
            title: Text("Alert"),
            content: Text("Do you want to delete this question?"),
            actions: <Widget>[
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  deleteQuiz(widget.quizNum);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

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

  Future updateQuestion(String mQuestion, String mAnswer_01, String mAnswer_02,
      String mAnswer_03, String mAnswer_04, String mCorrect_Answer) async {
    await FirebaseFirestore.instance
        .collection('Questions')
        .doc(widget.quizNum)
        .update({
      'Question': mQuestion,
      'Answer_01': mAnswer_01,
      'Answer_02': mAnswer_02,
      'Answer_03': mAnswer_03,
      'Answer_04': mAnswer_04,
      'Correct_Answer': mCorrect_Answer,
    });
  }

  Future UpdateQuestionToFirebase() async {
    setState(() {
      isClicked = true;
    });
    try {
      updateQuestion(
          _questionController.text.trim(),
          _answer01Controller.text.trim(),
          _answer02Controller.text.trim(),
          _answer03Controller.text.trim(),
          _answer04Controller.text.trim(),
          _correctAnswerController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question Update Sucesss!')),
      );

      setState(() {
        isClicked = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
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
          'Edit Question',
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                        String correctAnswer =
                            _correctAnswerController.text.trim();

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
                          UpdateQuestionToFirebase();
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
                                  'Update Question',
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
                    GestureDetector(
                      onTap: () {
                        _deleteQuizComfirmation();
                      },
                      child: Container(
                        height: 55,
                        width: screenWidth - 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
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
                                  'Delete Question',
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
