import 'package:dukan_sathi/dashboard.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'home_page.dart';
import 'discover_shop.dart';
import 'package:dukan_sathi/onboarding_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //using a SafeArea To Remov e the debug banner
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}
