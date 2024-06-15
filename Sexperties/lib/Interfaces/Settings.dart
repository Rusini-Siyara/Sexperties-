import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/EditUserAccount.dart';

class SettingsPage extends StatefulWidget {
  final String? uID;
  const SettingsPage({super.key, required this.uID});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //
  String? userName;
  String? email;
  String? birthday;
  String? phoneNo;
  String? image;
  String? address;

  //
  String? userID;

  @override
  void initState() {
    super.initState();
    userID = widget.uID;
    print(userID);
    getUserData();
  }

  void getUserData() async {
    User? user = _auth.currentUser;
    //_uid = user?.uid;
    print('${user!.email}');

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    setState(() {
      userName = userDoc.get('Name');
      email = userDoc.get('Email');
      birthday = userDoc.get('Birth_Day');
      phoneNo = userDoc.get('Phone_Number');
      address = userDoc.get('Address');
      image = userDoc.get('Profile_Image');

      if (birthday!.isEmpty) {
        birthday = 'Please Fill Details';
      }
      if (phoneNo!.isEmpty) {
        phoneNo = 'Please Fill Details';
      }
      if (address!.isEmpty) {
        address = 'Please Fill Details';
      }
      if (image!.isEmpty) {
        image =
            'https://firebasestorage.googleapis.com/v0/b/sexpertise-24866.appspot.com/o/images%2Fpngegg.png?alt=media&token=2f04d319-126c-4f10-a577-30238f33dc06';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              //Profile Image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 74, 173),
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage('$image'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$userName',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Text(
                '$email',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              //Name
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 0, 74, 173),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Name :",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '$userName',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              // //Password
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.key,
              //       color: Color.fromARGB(255, 0, 74, 173),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       "Password :",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 20,
              //       ),
              //     ),
              //   ],
              // ),
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.person,
              //       color: Colors.white,
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       "*******",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w400,
              //         fontSize: 20,
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(
              //   height: 15,
              // ),

              // //Re-type Password
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.key,
              //       color: Color.fromARGB(255, 0, 74, 173),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       "Re-Type Password :",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 20,
              //       ),
              //     ),
              //   ],
              // ),
              // const Row(
              //   children: [
              //     Icon(
              //       Icons.person,
              //       color: Colors.white,
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       "*******",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w400,
              //         fontSize: 20,
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(
              //   height: 15,
              // ),

              //Birthday
              const Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Color.fromARGB(255, 0, 74, 173),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Birthday",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$birthday",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              //Mobile No
              const Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Color.fromARGB(255, 0, 74, 173),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Mobile No",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$phoneNo",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              //Address
              const Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 0, 74, 173),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$address",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              //Save Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUserAccount(
                                userIDE: userID!,
                              )));
                },
                child: Container(
                  height: 55,
                  // width: screenWidth - 30,
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
                  child: const Center(
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
