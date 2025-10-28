
import 'package:get/get.dart';
import 'package:flutter/material.dart';


import 'home_page.dart';



void main() {
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //using a SafeArea To Remov e the debug banner
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false, //this is portion to remove a banner
        home: Home(),
        // home : MonthlySpendingPage(),
        // home : Login(),
        // home : DiscoverShop(),
      ),
    );
  }
}










