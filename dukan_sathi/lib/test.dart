import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
          body: Container(
          color: const Color.fromARGB(255, 237, 235, 166),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset("assets/imgs/one.jpg"),
                ),
                Text("Your Grocery Ready With Us"),

                ElevatedButton(
                  onPressed: () {
                    print("");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Get Started  -> "),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
