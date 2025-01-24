import 'package:flutter/material.dart';
import 'dart:async';
import 'screens/home_page.dart'; // Import the HomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashToHome(), // Start with the splash + welcome + home logic
    );
  }
}

class SplashToHome extends StatefulWidget {
  @override
  _SplashToHomeState createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  int currentScreen = 0; // 0: Splash, 1: Welcome, 2: Home

  @override
  void initState() {
    super.initState();
    // Timer for Splash Screen (3 seconds)
    Timer(Duration(seconds: 3), () {
      setState(() {
        currentScreen = 1; // Move to Welcome Screen
      });
      // Timer for Welcome Screen (3 seconds)
      Timer(Duration(seconds: 3), () {
        setState(() {
          currentScreen = 2; // Move to Home Screen
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentScreen == 0) {
      return SplashScreen(); // Show Splash Screenx²
    } else if (currentScreen == 1) {
      return WelcomeScreen(); // Show Welcome Screen
    } else {
      return HomePage(); // Show Home Screen
    }
  }
}

// Splash Screen Widget
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "Your Productivity Partner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Welcome Screen Widget
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "\"The secret of getting ahead is getting started.\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
