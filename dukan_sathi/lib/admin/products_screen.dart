import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFBF5),
      body: Center(
        child: Text('Products Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
