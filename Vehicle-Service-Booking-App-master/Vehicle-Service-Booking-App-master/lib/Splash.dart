// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:async'; // Import the async package for Timer
import 'package:flutter/material.dart';
import 'Login.dart'; // Adjust the import path as needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Login page after a delay with animation
    Timer(
      const Duration(seconds: 5), // Adjust the delay as needed
      () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Login(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(
                milliseconds: 500), // Adjust the duration as needed
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image taking the full screen
          Image.asset(
            "assets/IMG_2454.JPG",
            fit: BoxFit.cover, // Scale the image to cover the entire area
            height: screenHeight, // Full screen height
            width: screenWidth, // Full screen width
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight *
                          0.16), // Adjust top padding as a percentage of screen height
                  child: Image.asset(
                    "assets/IMG_2458.png",
                    width: screenWidth *
                        0.20, // Dynamic width (percentage of screen width)
                    height: screenWidth *
                        0.20, // Dynamic height (percentage of screen width)
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.6), // Adjust based on screen height
                  child: const Text(
                    'Drive In, We Take Care',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight *
                          0.01), // Adjust spacing based on height
                  child: const Text(
                    'Hassle-Free Vehicle Service at Your Fingertips!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
