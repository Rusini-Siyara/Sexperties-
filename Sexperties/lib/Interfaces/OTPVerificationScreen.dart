import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool isEmailVerified = false;
  bool competed = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      Duration(seconds: 3),
      (_) => checkEmailVerification(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification Success!'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  void checkVerification() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      setState(() {
        competed = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification Failed!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(screenWidth,
                          (screenWidth * 0.6666666666666666).toDouble()),
                      painter: CustomShape(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 250,
                        width: 250,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Verification',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: screenWidth,
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'Email Verification',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Text(
                        '\n Verification Email sent to',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Text(
                        '${widget.email}',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Text(
                        ' Check your email and click on the \n confrmation link to continue.',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    GestureDetector(
                      onTap: () {
                        checkVerification();
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
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a gradient
    final gradient = LinearGradient(
      colors: [
        const Color.fromARGB(255, 76, 126, 255),
        const Color.fromARGB(255, 26, 86, 199),
      ],
      stops: [0.0, 1.0], // Adjust the stops as needed
    );

    // Create a shader from the gradient
    final shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Layer 1

    Paint paint_fill_0 = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1744444, size.height * -0.0005667);
    path_0.quadraticBezierTo(size.width * -0.0058444, size.height * -0.0016667,
        size.width * 0.0000222, size.height * 0.2400000);
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.5732667, size.height * 0.9394667,
        size.width * 0.6428889, size.height * 0.7088000);
    path_0.quadraticBezierTo(size.width * 0.7088222, size.height * 0.4145000,
        size.width * 0.6262889, size.height * -0.0010667);
    path_0.quadraticBezierTo(size.width * 0.5133333, size.height * -0.0022000,
        size.width * 0.1744444, size.height * -0.0005667);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
