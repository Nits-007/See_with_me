import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:see_with_me/frontend/Login_Page.dart';
import 'package:see_with_me/frontend/Main_Page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/Lottie/Animation - 1724350922256.json",
                width: deviceWidth * 0.5,
                height: deviceHeight * 0.3,
                fit: BoxFit.cover,
              ),
              SizedBox(height: deviceHeight * 0.05),
              Text(
                "See With Me!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
