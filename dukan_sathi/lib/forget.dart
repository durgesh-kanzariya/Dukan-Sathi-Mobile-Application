import 'package:dukan_sathi/Login.dart';
// import 'package:dukan_sathi/shopkeeper/dashboard/shopkeeper_main_screen.dart';
import 'package:dukan_sathi/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'customer/dashboard.dart';
// import 'shopkeeper/dashboard/dashboard_page.dart';
// import

class Foregot extends StatefulWidget {
  @override
  _ForegotState createState() => _ForegotState();
}

class _ForegotState extends State<Foregot> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
// Ensure you have: import 'package:get/get.dart';
// Aur aapki Login class imported hai.

ForgetPasswordLogic(String email) async {
  try {
    // 1. Database check
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      _showDialog(
        "Reset Failed",
        "No user found with this email in our database. Please check the address.",
      );
      return;
    }

    // 2. Send Password Reset Email
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    // 3. Success dialog dikhao aur Login page par redirect karo
    _showDialog(
      "Success",
      "A password reset link has been successfully sent to $email. You will now be redirected to the login screen.",
      isSuccess: true, // isSuccess true hone par Login redirect hoga
    );
  } on FirebaseAuthException catch (e) {
    // Authentication Errors
    String customErrorMessage = "Password reset failed.";

    if (e.code == 'invalid-email') {
      customErrorMessage = "The email address is not in a valid format.";
    } else {
      customErrorMessage = "An unexpected error occurred. Please try again.";
    }

    _showDialog("Reset Password Failed", customErrorMessage);
  } catch (e) {
    // General Database Error
    _showDialog("Error", "An error occurred while checking the database.");
  }
}

void _showDialog(String title, String content, {bool isSuccess = false}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            // 1. Dialog band karo
            Navigator.of(context).pop(); 
            
            // 2. Agar success hua hai, toh Login page par redirect karo
            if (isSuccess) {
              // GetX use karke seedha Login screen par jao aur pichli screens hata do
              Get.offAll(Login()); 
            }
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }


  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F3E7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerImage(),
            _formSection(),
            SizedBox(height: 15),
            _ForegotRedirectButton(),

          ],
        ),
      ),
      bottomNavigationBar: Row(
    children: [

      Image.asset("assets/imgs/2.jpg", height: 200),
    ],
  ),
    );
  }

  Widget _headerImage() =>
      Image.asset("assets/imgs/1.png", width: double.infinity, height: 110);

  Widget _formSection() => Form(
    key: _formKey,
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),

          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Foregot Password here",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 50),

          _textField(
            controller: emailController,
            hint: "E-mail",
            icon: Icons.email_outlined,
            validator: (v) => !v!.contains("@") ? "Enter valid email" : null,
          ),
          SizedBox(height: 60),

          _ForegotButton(),
        ],
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
        contentPadding: EdgeInsets.only(
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
        prefixIcon: Icon(Icons.lock_outline),
        hintText: hint,
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        contentPadding: EdgeInsets.only(
          left: 20,
          right: 10,
          top: 15,
          bottom: 15,
        ),
      ),
      validator: validator,
    ),
  );

  Widget _ForegotButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
    ),
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        ForgetPasswordLogic(emailController.text.trim());
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Forget Password",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: Colors.white),
      ],
    ),
  );

  Widget _ForegotRedirectButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFF9F3E7),
      foregroundColor: Colors.black,
      shadowColor: Colors.transparent,
    ),
    child: Text("Return to Login"),
    onPressed: () => Get.off(Login()),
  );



  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );
}
