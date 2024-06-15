import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/LoginScreen.dart';
import 'package:sexpertise/Interfaces/OTPVerificationScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final GlobalKey<NavigatorState>? navigatorKey;

  bool isSecurePassword = true;
  bool isClicked = false;

  // bool competed = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

  void _passwordCharactorsCheck() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: Text("Password Error"),
            content: Text("Password require minimum 8 charactors."),
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
            title: Text("Password Error"),
            content: Text("Password require minimum 8 charactors."),
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

  Future addUserDetails(String name, String uID, String email) async {
    await FirebaseFirestore.instance.collection('Users').doc(uID).set({
      'User_ID': uID,
      'Name': name,
      'Role': 'User',
      'Email': email,
      'Phone_Number': '',
      'Birth_Day': '',
      'Address': '',
      'Profile_Image': '',
    });
  }

  Future signUp() async {
    setState(() {
      isClicked = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      addUserDetails(
        _nameController.text.trim(),
        user!.uid,
        _emailController.text.trim(),
      );

      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Email Sent!')),
      );

      setState(() {
        isClicked = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: '${user.email}',
          ),
        ),
      );

      // Clear the text fields after successful registration
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
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
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              //Input Section and Button
              Container(
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 250,
                            width: 250,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'SignUp',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    Container(
                      width: screenWidth - 30,
                      height: 55,
                      child: TextField(
                        controller: _nameController,
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
                    SizedBox(
                      height: 15,
                    ),

                    //TextField Email
                    Container(
                      width: screenWidth - 30,
                      height: 55,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
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
                          labelText: 'Email',
                          labelStyle: TextStyle(),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    //TextField Password
                    Container(
                      width: screenWidth - 30,
                      height: 55,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: isSecurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
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
                          labelText: 'Password',
                          suffixIcon: togglePassword(),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),

                    //Forget Password

                    //SignUp Button
                    GestureDetector(
                      onTap: () {
                        String name = _nameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        if (email.isEmpty || password.isEmpty || name.isEmpty) {
                          _wrongCredentials();
                        } else if (password.length < 8) {
                          _passwordCharactorsCheck();
                        } else {
                          signUp();
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
                                  'SignUp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //Bottom Section
                    Container(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Spacer(),
                                Text("Already have an account?"),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 74, 173),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
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

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            isSecurePassword = !isSecurePassword;
          });
        },
        icon: isSecurePassword
            ? Icon(
                Icons.visibility_off,
                color: Color.fromARGB(255, 0, 74, 173),
              )
            : Icon(
                Icons.visibility,
                color: Color.fromARGB(255, 0, 74, 173),
              ));
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
