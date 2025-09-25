import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFBF5),
      body: Center(child: Text('Shop Screen', style: TextStyle(fontSize: 24))),
    );
  }
}
