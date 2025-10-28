import 'package:dukan_sathi/forget.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sign_up.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  Loginlogic(String email, String pass, String roll) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('role')) {
        await FirebaseAuth.instance.signOut();
        _showErrorDialog(
          "Error",
          "User profile data is incomplete. Role not found.",
        );
        return;
      }

      final role = userDoc['role'];

      if (role != roll) {
        await FirebaseAuth.instance.signOut();
        _showErrorDialog(
          "Login Failed",
          "The selected user type does not match your account type.",
        );
        return;
      }

      if (role == 'Customer') {
        Get.offAll(Dashboard(username: email, password: pass));
      } else if (role == 'Shopkeeper') {
        // Get.offAll(ShopkeeperMainScreen());
      } else {
        _showErrorDialog("Error", "This account has an unrecognized role.");
      }
    } on FirebaseAuthException catch (e) {
      String customErrorMessage =
          "Login failed. Please check your email and password and try again.";

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        customErrorMessage = "The email or password you entered is incorrect.";
      } else if (e.code == 'invalid-email') {
        customErrorMessage = "The email address is not in a valid format.";
      }

      _showErrorDialog1("Login Failed", customErrorMessage);
    }
  }

  void _showErrorDialog1(String title, String content) {
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

  // Helper function to show consistent error dialogs
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
  String? _selectedRole = "Customer";
  final List<String> _roles = ["Customer", "Shopkeeper"];

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
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(100, 10, 50, 10),
            child: Text(
              "Hello",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Sign To Your Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 30),

          _roleDropdown(),
          SizedBox(height: 20),

          _textField(
            controller: emailController,
            hint: "E-mail",
            icon: Icons.email_outlined,
            validator: (v) => !v!.contains("@") ? "Enter valid email" : null,
          ),
          SizedBox(height: 20),

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
          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.only(left: 180, right: 20),
            child: InkWell(
              onTap: () {
                Get.off(Foregot());
              },
              child: Text("Forget Password?", style: TextStyle(fontSize: 14)),
            ),
          ),
          SizedBox(height: 30),

          _LoginButton(),
        ],
      ),
    ),
  );

  Widget _roleDropdown() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
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
                    Icon(Icons.person),
                    SizedBox(width: 10),
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

  Widget _LoginButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    ),
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        Loginlogic(
          emailController.text,
          passwordController.text,
          _selectedRole.toString(),
        );
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: Colors.white),
      ],
    ),
  );

  Widget _loginRedirectButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFF9F3E7),
      foregroundColor: Colors.black,
      shadowColor: Colors.transparent,
    ),
    child: Text("Don’t have an account? Create "),
    onPressed: () => Get.off(SignUp()),
  );

  Widget _bottomImage() =>
      Row(children: [Image.asset("assets/imgs/2.jpg", height: 146)]);

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
