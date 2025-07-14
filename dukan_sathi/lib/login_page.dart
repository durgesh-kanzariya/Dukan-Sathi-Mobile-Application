// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Vector 1 at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/Vector 1.png", fit: BoxFit.fill),
          ),

          // Vector 2 at the bottom-left
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/Vector 2.png"),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(),
                  const SizedBox(height: 12),
                  TextField(obscureText: true),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () {}, child: Text('Login')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
