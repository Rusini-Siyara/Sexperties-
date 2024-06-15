import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/SingleLayouts/SingleQuestionTitle.dart';

class UserQuizList extends StatefulWidget {
  const UserQuizList({super.key});

  @override
  State<UserQuizList> createState() => _UserQuizListState();
}

class _UserQuizListState extends State<UserQuizList> {
  int documentCount = 0;
  bool emptyQuestions = false;

  final _quizStrem =
      FirebaseFirestore.instance.collection('Questions').snapshots();

  @override
  void initState() {
    getDocumentCount();
    super.initState();
  }

  void getDocumentCount() {
    FirebaseFirestore.instance
        .collection('Questions')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        documentCount = snapshot.docs.length;
        print(documentCount);
      });
      if (documentCount == 0) {
        setState(() {
          emptyQuestions = true;
        });
      } else {
        setState(() {
          emptyQuestions = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quizzes',
          style: TextStyle(
            fontSize: 23,
            color: Color.fromRGBO(0, 74, 173, 1),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 244, 246, 255),
      ),
      body: emptyQuestions
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              color: const Color.fromARGB(255, 244, 246, 255),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text('No Quizzes yet!'),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              color: const Color.fromARGB(255, 244, 246, 255),
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                  stream: _quizStrem,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          // Get the document ID.
                          String documentId = documents[index].id;

                          return SingleQuestionTitleCard(
                            quizNum: documentId,
                            number: (index + 1).toString(),
                          );
                          // ListTile(
                          //   title: Text('Document ID: $documentId'),
                          // );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
              // SingleChildScrollView(
              //   child:
              //   Column(
              //     children: [
              //       for (var i = 1; i <= documentCount; i++)
              //         SingleQuestionTitleCard(quizNum: i.toString())
              //     ],
              //   ),
              // ),
              ),
    );
  }
}
