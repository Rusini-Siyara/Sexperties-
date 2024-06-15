import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/QuizEditPage.dart';

class AdminSingleQuestionTitleCard extends StatefulWidget {
  final String quizNum;
  final String number;
  const AdminSingleQuestionTitleCard(
      {super.key, required this.quizNum, required this.number});

  @override
  State<AdminSingleQuestionTitleCard> createState() =>
      _AdminSingleQuestionTitleCardState();
}

class _AdminSingleQuestionTitleCardState
    extends State<AdminSingleQuestionTitleCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.number);
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => QuizDoingPage(
      //         quizID: widget.quizNum,
      //       ),
      //     ),
      //   );
      // },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color.fromRGBO(0, 74, 173, 1),
            width: 2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                'Question ${widget.number}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.quizNum}',
                style: TextStyle(
                  fontSize: 5,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 244, 246, 255),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizEditPage(
                        quizNum: widget.quizNum,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Color.fromRGBO(0, 74, 173, 1),
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
