import 'package:flutter/material.dart';
import 'dashboard.dart';   // 🔹 Dashboard import karo
import 'sign_in.dart';
import 'package:get/get.dart';
import 'one.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}



class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String msg = "";

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
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
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
                    const Text("Username"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter username" : null,
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) => value!.length < 6
                            ? "Password must be 6+ chars"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Forget Password?"),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (usernameController.text == "kishan") {
                                  // Get.offAll(Test());
                                  Get.offAll(() => Dashboard(
                                        username: usernameController.text,
                                        password: passwordController.text,
                                      ));
                                } else {
                                  setState(() {
                                    msg = "Invalid Username/Password";

                                  });
                                }
                              }
                            },
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 25,
                            ),
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
                backgroundColor: Color(0xFFF9F3E7),
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
              ),
              child: const Text("Don’t have an account? Create "),
              onPressed: () {
                Get.to(SignIn());
              },
            ),
            Text(msg, style: const TextStyle(color: Colors.red)),


            Image.asset(
              "assets/imgs/2.jpg",
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
