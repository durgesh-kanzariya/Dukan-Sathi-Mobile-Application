import 'package:dukan_sathi/bottom_nav.dart';
import 'package:dukan_sathi/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController old = TextEditingController();
  final TextEditingController np = TextEditingController();
  final TextEditingController cp = TextEditingController();

  bool _oldVisible = false;
  bool _newVisible = false;
  bool _confirmVisible = false;

  String msg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF567751),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () {
                            Get.to(Profile());
                          },
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                        title: const Text(
                          "Dukan Sathi",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 80,
                  left: 90,
                  child: Center(
                    child: Text(
                      "Change Password",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter Old Password"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: old,
                        obscureText: !_oldVisible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _oldVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _oldVisible = !_oldVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? "Password must be 6+ chars"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Enter New Password"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: np,
                        obscureText: !_newVisible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _newVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _newVisible = !_newVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? "Password must be 6+ chars"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Confirm Password"),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        controller: cp,
                        obscureText: !_confirmVisible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmVisible = !_confirmVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm your password";
                          } else if (value != np.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       const Text(
                    //         "Sign In",
                    //         style: TextStyle(fontSize: 20),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.green,
                    //           foregroundColor: Colors.white,
                    //         ),
                    //         onPressed: () {
                    //           if (_formKey.currentState!.validate()) {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text(
                    //                   "Password changed successfully!",
                    //                 ),
                    //                 backgroundColor: Colors.green,
                    //               ),
                    //             );
                    //             Get.offAll(Profile());
                    //           }
                    //         },
                    //         child: const Icon(
                    //           Icons.arrow_forward,
                    //           size: 25,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),


                    Padding(
                      padding:EdgeInsetsGeometry.symmetric(vertical: 20),
                      child: ListTile(
                      trailing: ElevatedButton(
                          onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Get.offAll(Profile());
                                }
                              }, child: Text("Save Changes → "),
                       style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF567751),
                            foregroundColor: Colors.white,
                          ),
                      ),
                                        ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
