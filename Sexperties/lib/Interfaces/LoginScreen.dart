import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/AdminHomeScreen.dart';
import 'package:sexpertise/Interfaces/ForgotPasswordScreen.dart';
import 'package:sexpertise/Interfaces/SignUPScreen.dart';
import 'package:sexpertise/Interfaces/UserHomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<NavigatorState>? navigatorKey;

  bool isSecurePassword = true;
  bool isClicked = false;

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

  Future signIn() async {
    setState(() {
      isClicked = true;
    });
    try {
      final newUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = newUser.user;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid)
          .get();

      // Check the user's role
      String userRole = userDoc['Role'];

      // Based on the user's role, navigate to appropriate screens
      if (userRole == 'Admin') {
        // Navigate to admin screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeScreen(),
          ),
        );
      } else if (userRole == 'User') {
        // Navigate to user screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomeScreen(),
          ),
        );
      }
      // Clear the text fields after successful registration
      _emailController.clear();
      _passwordController.clear();

      setState(() {
        isClicked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successfully!')),
      );
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
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Logo Section
              Container(
                height: screenHeight / 3 + AppBar().preferredSize.height,
                width: screenWidth,
                child: Image.asset('lib/Assets/Logo.jpeg'),
              ),

              //Input Section and Button
              Container(
                width: screenWidth,
                height: screenHeight / 3,
                child: Column(
                  children: [
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
                      height: 10,
                    ),

                    //Forget Password
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth,
                        child: Center(
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 74, 173),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    //Login Button
                    GestureDetector(
                      onTap: () {
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        if (email.isEmpty || password.isEmpty) {
                          _wrongCredentials();
                        } else if (password.length < 8) {
                          _passwordCharactorsCheck();
                        } else {
                          signIn();
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
                                  'Login',
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

              //Bottom Section
              Container(
                width: screenWidth,
                height: screenHeight / 3 - AppBar().preferredSize.height,
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      child: Center(
                        child: Text(
                          'Or',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Center(
                        child: Text(
                          'Continue with',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      child: Center(
                        child: Image.asset('lib/Assets/google.png'),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Row(
                        children: [
                          Spacer(),
                          Text("Don't you have an account?"),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              "Sign Up",
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
                    Spacer(),
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
