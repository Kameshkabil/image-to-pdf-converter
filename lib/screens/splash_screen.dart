import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_to_pdf_converter/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 10),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context){
            return HomeScreen();
          }
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/pdfLottie.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              repeat: true,
            ),

            SizedBox(height: 50,),

            Text(
              'Image to PDF Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
