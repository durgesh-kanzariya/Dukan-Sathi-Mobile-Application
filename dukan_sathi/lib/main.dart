import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: Color.fromARGB(255, 250, 244, 232),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/logo.png"),
              Text(
                """Your grocery ready
with us.""",
                style: TextStyle(
                  color: Color.fromARGB(255, 57, 66, 61),
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // ✅ Button background color
                  foregroundColor: Colors.white, // ✅ Text/Icon color
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Get Started"),
                    SizedBox(width: 10),
                    Image.asset("assets/images/Arrow 4.png"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
