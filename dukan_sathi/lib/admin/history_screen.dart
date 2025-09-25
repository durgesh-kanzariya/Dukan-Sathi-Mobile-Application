import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFBF5),
      body: Center(
        child: Text('History Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
