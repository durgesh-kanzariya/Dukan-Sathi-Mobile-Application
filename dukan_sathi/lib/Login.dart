import 'package:dukan_sathi/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController =
      TextEditingController(); // Changed from username
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String msg = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return; // Validation failed

    setState(() {
      _isLoading = true;
      msg = ""; // Clear previous messages
    });

    try {
      // Use Firebase Auth to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), // Use email controller
        password: passwordController.text.trim(),
      );

      // If login succeeds, DO NOTHING here.
      // AuthGate will detect the change and navigate via Get.offAll.
    } on FirebaseAuthException catch (e) {
      // Handle different login errors
      String errorMessage;
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = "Invalid Email or Password";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      } else {
        errorMessage = "An error occurred. Please try again.";
        print("Firebase Auth Error (${e.code}): ${e.message}");
      }
      if (mounted) {
        // Check if widget is still mounted before calling setState
        setState(() {
          msg = errorMessage;
          _isLoading = false; // Turn off spinner ONLY on error
        });
      }
    } catch (e) {
      // Handle other errors
      print("General Error: $e");
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          msg = "An unexpected error occurred. Please try again.";
          _isLoading = false; // Turn off spinner ONLY on error
        });
      }
    }
    // Don't set isLoading to false here if successful,
    // as the widget might be disposed before this runs.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/imgs/1.png", // Ensure this path is correct
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Text("Hello", style: TextStyle(fontSize: 70)),
            const Text(
              "Sign In To Your Account ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email"), // Changed label to Email
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ), // Rounded corners
                      child: TextFormField(
                        controller: emailController, // Use email controller
                        keyboardType:
                            TextInputType.emailAddress, // Set keyboard type
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                        validator: (value) {
                          // Basic email validation
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          if (!GetUtils.isEmail(value)) {
                            // Use GetUtils for validation
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text("Password"),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ), // Rounded corners
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.length < 6)
                            ? "Password must be 6+ characters"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Sign In", style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5F7D5D),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(), // Make button circular
                              padding: EdgeInsets.all(15), // Adjust padding
                            ),
                            onPressed: _isLoading
                                ? null
                                : _signIn, // Disable button when loading
                            child: _isLoading
                                ? const SizedBox(
                                    // Show spinner inside button
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward, size: 25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Make transparent
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent, // No shadow
                elevation: 0, // No elevation
              ),
              child: const Text(
                "Don’t have an account? Create",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ), // Underline text
              ),
              onPressed: () {
                // Use Get.to to navigate TO SignUp (allows back)
                Get.to(() => SignUp());
              },
            ),
            if (msg.isNotEmpty) // Show error message if it exists
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(msg, style: const TextStyle(color: Colors.red)),
              ),

            // Use Expanded and Align for bottom image if needed, or adjust layout
            Align(
              // Align image to bottom left
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                "assets/imgs/2.jpg", // Ensure this path is correct
                height: 200,
                // width: MediaQuery.of(context).size.width * 0.6, // Example width
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
