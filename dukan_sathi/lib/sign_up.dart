import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  SignupLogic(String name, String email, String pass, String role) async {
    UserCredential auth;
    try {
      auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.user!.uid)
          .set({'name': name, 'email': email, 'role': role});

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("REGISTER SUCCESSFULLY"),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(Login());
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message ?? "An error occurred"),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(SignUp());
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // States
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole = "Customer";
  final List<String> _roles = ["Customer", "Shopkeeper"];

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
            controller: usernameController,
            hint: "Username",
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? "Enter username" : null,
          ),
          const SizedBox(height: 20),

          _textField(
            controller: emailController,
            hint: "E-mail",
            icon: Icons.email_outlined,
            validator: (v) => !v!.contains("@") ? "Enter valid email" : null,
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
          const SizedBox(height: 30),

          _signUpButton(),
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
                value: role,
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 10),
                    Text(role),
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
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        SignupLogic(
        usernameController.text,
        emailController.text,
        passwordController.text,
        _selectedRole.toString(),
      );
      }

    },
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
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
    child: const Text("have an account? Login "),
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
