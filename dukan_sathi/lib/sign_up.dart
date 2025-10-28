import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukan_sathi/Login.dart'; // Corrected import path (assuming Login.dart is in lib)
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (renamed username to name for clarity)
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  // States
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole = "customer"; // Changed default to lowercase
  final List<String> _roles = ["customer", "shopkeeper"]; // Simplified roles
  bool _isLoading = false;
  String _errorMessage = "";

  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Sign Up Function ---
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form is not valid
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // 1. Create the user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // 2. Get the new user's UID
      String uid = userCredential.user!.uid;

      // 3. Create a document in the `users` collection in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
        'role': _selectedRole, // 'customer' or 'shopkeeper'
        'createdAt': Timestamp.now(), // Good practice to add a timestamp
      });

      // If successful, the AuthGate will automatically navigate
      // to the RoleRouter, so we don't need to do it here.
      // We'll just pop the sign up page.
      if (mounted) {
        Get.back(); // Go back to the login page
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'An account already exists for that email.';
      } else {
        _errorMessage = 'An error occurred. Please try again.';
      }
      print("Firebase Auth Error: ${e.message}");
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      print("General Error: $e");
    }

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
            _headerImage(),
            _formSection(),
            const SizedBox(height: 15),
            _loginRedirectButton(),
            _bottomImage(),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets Section ----------------

  Widget _headerImage() =>
      Image.asset("assets/imgs/1.png", width: double.infinity, height: 110);

  Widget _formSection() => Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Create account",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),

          _roleDropdown(),
          const SizedBox(height: 20),

          _textField(
            controller: nameController, // Changed from usernameController
            hint: "Full Name", // Changed from "Username"
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? "Enter your full name" : null,
          ),
          const SizedBox(height: 20),

          _passwordField(
            controller: passwordController,
            hint: "Password",
            obscure: _obscurePassword,
            toggle: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
            validator: (v) =>
                v!.length < 6 ? "Min 6 characters required" : null,
          ),
          const SizedBox(height: 20),

          _passwordField(
            controller: confirmPasswordController,
            hint: "Confirm Password",
            obscure: _obscureConfirmPassword,
            toggle: () => setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            }),
            validator: (v) =>
                v != passwordController.text ? "Passwords do not match" : null,
          ),
          const SizedBox(height: 20),

          _textField(
            controller: emailController,
            hint: "E-mail",
            icon: Icons.email_outlined,
            validator: (v) => !v!.contains("@") ? "Enter valid email" : null,
          ),
          const SizedBox(height: 20),

          _textField(
            controller: mobileController,
            hint: "Mobile",
            icon: Icons.phone_android,
            inputType: TextInputType.phone,
            validator: (v) => v!.length != 10 ? "Enter valid number" : null,
          ),
          const SizedBox(height: 30),

          _signUpButton(),

          // Widget to show error messages
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    ),
  );

  Widget _roleDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: _boxDecoration(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedRole,
        isExpanded: true,
        items: _roles
            .map(
              (role) => DropdownMenuItem(
                value: role, // The value is lowercase (e.g., "customer")
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 10),
                    // Capitalize the first letter for display (e.g., "Customer")
                    Text(role[0].toUpperCase() + role.substring(1)),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _selectedRole = value),
      ),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType inputType = TextInputType.text,
  }) => Container(
    decoration: _boxDecoration(),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 10,
          top: 15,
          bottom: 15,
        ),
      ),
      validator: validator,
    ),
  );

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) => Container(
    decoration: _boxDecoration(),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        hintText: hint,
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 10,
          top: 15,
          bottom: 15,
        ),
      ),
      validator: validator,
    ),
  );

  Widget _signUpButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    ),
    onPressed: _isLoading ? null : _signUp, // Call our new _signUp function
    child: _isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
        : const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
  );

  Widget _loginRedirectButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF9F3E7),
      foregroundColor: Colors.black,
      shadowColor: Colors.transparent,
    ),
    child: const Text("Already have an account? Sign In"), // Changed text
    onPressed: () => Get.off(Login()),
  );

  Widget _bottomImage() =>
      Row(children: [Image.asset("assets/imgs/2.jpg", height: 200)]);

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
