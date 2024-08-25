import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:see_with_me/frontend/Home_Page.dart';
import 'package:see_with_me/frontend/Login_Page.dart';

class SigninPage extends StatefulWidget {
  final VoidCallback loginpage;
  const SigninPage({Key? key, required this.loginpage}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  var _emailnewController = TextEditingController();
  var _passwordnewController = TextEditingController();
  var _firstnameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _ageController = TextEditingController();
  var _emergencyPhoneNumberController = TextEditingController();

  Future SignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailnewController.text.trim(),
        password: _passwordnewController.text.trim(),
      );

      SaveInfo(
        _firstnameController.text.trim(),
        _lastnameController.text.trim(),
        _emailnewController.text.trim(),
        int.parse(_ageController.text.trim()),
        _emergencyPhoneNumberController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  Future SaveInfo(String firstName, String lastName, String email, int age,
      String emergencyPhoneNumber) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email id': email,
      'age': age,
      'emergency phone Number': emergencyPhoneNumber,
    });
  }

  @override
  void dispose() {
    _emailnewController.dispose();
    _passwordnewController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _emergencyPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _firstnameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.cake,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailnewController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordnewController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: screenSize.width * 0.85,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    controller: _emergencyPhoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Emergency Phone Number',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: screenSize.width * 0.85,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      SignUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: widget.loginpage,
                    child: Center(
                      child: const Text(
                        "Already have an account? Log In",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
