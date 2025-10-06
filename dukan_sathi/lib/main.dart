import 'package:flutter/material.dart';
import 'package:dukan_sathi/onboarding_page.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //using a SafeArea To Remov e the debug banner
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}
