import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //using a SafeArea To Remove the debug banner
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,//this is portion to remove a banner
        home: Scaffold(
          // body: ConstomContainer(),
          body:  Home() ,
          )
      ),
    );
  }
}

