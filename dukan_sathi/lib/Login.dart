import 'package:dukan_sathi/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  // Renamed controllers to be more accurate
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String msg = "";
  bool _isLoading = false; // To show a loading indicator

  // Firebase Auth Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is invalid, don't do anything
    }

    setState(() {
      _isLoading = true; // Show loading spinner
      msg = ""; // Clear previous error messages
    });

    try {
      // Use Firebase Auth to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      // If login is successful, we don't need to do anything here.
      // The StreamProvider in main.dart will detect the new user
      // and the AuthGate will automatically navigate to the RoleRouter.
      // We also don't need to use Get.offAll() anymore.

    } on FirebaseAuthException catch (e) {
      // Handle different login errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        setState(() {
          msg = "Invalid Email or Password";
        });
      } else {
        setState(() {
          msg = "An error occurred. Please try again.";
        });
        print("Firebase Auth Error: ${e.message}");
      }
    } catch (e) {
      // Handle other errors
      setState(() {
        msg = "An error occurred. Please try again.";
      });
      print("General Error: $e");
    }

    // Stop loading whether it succeeded or failed
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/imgs/1.png",
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

            // 🔹 Form
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Changed from "Username" to "Email"
                    const Text("Email"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        // Use emailController
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "customer1@example.com",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) =>
                            value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Password"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "******",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) => value!.length < 6
                            ? "Password must be 6+ chars"
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
                            ),
                            // Show loading indicator or run _signIn function
                            onPressed: _isLoading ? null : _signIn,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
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
                backgroundColor: const Color(0xFFF9F3E7),
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
              ),
              child: const Text("Don’t have an account? Create "),
              onPressed: () {
                // Use Get.to so the user can go back from the sign up page
                Get.to(() => SignUp());
              },
            ),
            // Show error message from Firebase
            Text(msg, style: const TextStyle(color: Colors.red)),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/imgs/2.jpg",
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

