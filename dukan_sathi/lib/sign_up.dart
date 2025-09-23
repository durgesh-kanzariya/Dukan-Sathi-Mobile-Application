import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Login.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole = "Customer";
  final List<String> _roles = ["Customer", "Admin", "Vendor"];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F3E7),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/imgs/1.png",
              width: double.infinity,
              height: 110,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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

                    // Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: _boxDecoration(),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          items: _roles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 10),
                                  Text(role),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Username
                    Container(
                      decoration: _boxDecoration(),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: "Username",
                          border: InputBorder.none,
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter username" : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Container(
                      decoration: _boxDecoration(),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: "Password",
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            value!.length < 6 ? "Min 6 characters" : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    Container(
                      decoration: _boxDecoration(),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: "Confirm Password",
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) => value != passwordController.text
                            ? "Passwords do not match"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    Container(
                      decoration: _boxDecoration(),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "E-mail",
                          border: InputBorder.none,
                        ),
                        validator: (value) =>
                            !value!.contains("@") ? "Enter valid email" : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mobile
                    Container(
                      decoration: _boxDecoration(),
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_android),
                          hintText: "Mobile",
                          border: InputBorder.none,
                        ),
                        validator: (value) =>
                            value!.length != 10 ? "Enter valid number" : null,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Create button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.off(Login());
                        }
                      },
                      child: const Row(
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF9F3E7),
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
              ),
              child: const Text("Don’t have an account? Create "),
              onPressed: () {
                Get.off(Login());
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Image.asset("assets/imgs/2.jpg", height: 200)],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
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
}
