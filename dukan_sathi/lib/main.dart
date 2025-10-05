import 'package:dukan_sathi/admin/dashboard/shopkeeper_main_screen.dart';
import 'package:flutter/material.dart';

import 'package:dukan_sathi/onboarding_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 250, 244, 232),
      ),
      home: OnboardingPage(),
    );
  }
}
