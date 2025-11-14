// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Import GetX
// import 'package:dukan_sathi/Login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers - Renamed usernameController to nameController for clarity
//   final nameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final emailController = TextEditingController();
//   // final mobileController = TextEditingController(); // Removed, not used in signup logic

//   // States
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _selectedRole = "customer"; // Default to customer, use lowercase
//   final List<String> _roles = [
//     "customer",
//     "shopkeeper",
//   ]; // Simplified roles for Firestore

//   bool _isLoading = false; // Loading state for button
//   String _errorMessage = ""; // Error message state

//   // Firebase Instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void dispose() {
//     nameController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     emailController.dispose();
//     // mobileController.dispose();
//     super.dispose();
//   }

//   // --- Sign Up Function ---
//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return; // Validation failed

//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//     });

//     try {
//       // 1. Create user in Firebase Authentication
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       User? user = userCredential.user;

//       if (user != null) {
//         // 2. Create user document in Firestore
//         await _firestore.collection('users').doc(user.uid).set({
//           'name': nameController.text.trim(),
//           'email': emailController.text
//               .trim()
//               .toLowerCase(), // Store email consistently
//           'role': _selectedRole, // Use the selected role (customer/shopkeeper)
//           'createdAt': Timestamp.now(), // Good practice to add a timestamp
//           // Add other fields like mobile number if needed after collecting them
//         });

//         // If successful, DO NOTHING here for navigation.
//         // AuthGate will detect the new user state and navigate.

//         // Pop this screen to return to the Login screen.
//         // AuthGate will then handle the navigation to the dashboard.
//         if (mounted) {
//           Get.back(); // <-- This is correct.
//         }
//       } else {
//         // Handle case where user creation returned null (shouldn't happen often)
//         throw Exception("User creation failed, user is null.");
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       if (e.code == 'weak-password') {
//         message = 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'An account already exists for that email.';
//       } else if (e.code == 'invalid-email') {
//         message = 'The email address is not valid.';
//       } else {
//         message = 'An error occurred during sign up.';
//         print("Firebase Auth Error (${e.code}): ${e.message}");
//       }
//       if (mounted) {
//         setState(() {
//           _errorMessage = message;
//         });
//       }
//     } catch (e) {
//       print("General Sign Up Error: $e");
//       if (mounted) {
//         setState(() {
//           _errorMessage = "An unexpected error occurred.";
//         });
//       }
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false; // Stop loading spinner regardless of outcome
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F3E7),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _headerImage(),
//             _formSection(),
//             const SizedBox(height: 15),
//             _loginRedirectButton(),
//             _bottomImage(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------- Widgets Section ----------------

//   Widget _headerImage() => Image.asset(
//     "assets/imgs/1.png", // Ensure path is correct
//     width: double.infinity,
//     height: 110,
//     fit: BoxFit.cover, // Added fit
//   );

//   Widget _formSection() => Form(
//     key: _formKey,
//     child: Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Removed SizedBox to reduce top space
//           const Text(
//             "Create account",
//             style: TextStyle(
//               fontSize: 28, // Slightly larger
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center, // Center title
//           ),
//           const SizedBox(height: 30),

//           _roleDropdown(),
//           const SizedBox(height: 20),

//           // Changed Username to Name
//           _textField(
//             controller: nameController,
//             hint: "Full Name",
//             icon: Icons.person_outline,
//             validator: (v) => v!.isEmpty ? "Enter your full name" : null,
//           ),
//           const SizedBox(height: 20),

//           _textField(
//             // Added Email Field
//             controller: emailController,
//             hint: "E-mail",
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//             validator: (v) {
//               if (v == null || v.isEmpty) return "Enter email";
//               if (!GetUtils.isEmail(v))
//                 return "Enter valid email"; // Use GetUtils
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),

//           _passwordField(
//             controller: passwordController,
//             hint: "Password",
//             obscure: _obscurePassword,
//             toggle: () => setState(() {
//               _obscurePassword = !_obscurePassword;
//             }),
//             validator: (v) => (v == null || v.length < 6)
//                 ? "Min 6 characters required"
//                 : null,
//           ),
//           const SizedBox(height: 20),

//           _passwordField(
//             controller: confirmPasswordController,
//             hint: "Confirm Password",
//             obscure: _obscureConfirmPassword,
//             toggle: () => setState(() {
//               _obscureConfirmPassword = !_obscureConfirmPassword;
//             }),
//             validator: (v) =>
//                 v != passwordController.text ? "Passwords do not match" : null,
//           ),
//           const SizedBox(height: 20),

//           // Removed Mobile field - add back if needed for profile later
//           // _textField(
//           //   controller: mobileController,
//           //   hint: "Mobile",
//           //   icon: Icons.phone_android,
//           //   inputType: TextInputType.phone,
//           //   validator: (v) => v!.length != 10 ? "Enter valid number" : null,
//           // ),
//           // const SizedBox(height: 30),
//           if (_errorMessage.isNotEmpty) // Display error message
//             Padding(
//               padding: const EdgeInsets.only(bottom: 15.0),
//               child: Text(
//                 _errorMessage,
//                 style: const TextStyle(color: Colors.red, fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ),

//           _signUpButton(),
//         ],
//       ),
//     ),
//   );

//   Widget _roleDropdown() => Container(
//     padding: const EdgeInsets.symmetric(
//       horizontal: 16,
//       vertical: 5,
//     ), // Added vertical padding
//     decoration: _boxDecoration(),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton<String>(
//         value: _selectedRole,
//         isExpanded: true,
//         icon: const Icon(
//           Icons.arrow_drop_down,
//           color: Colors.grey,
//         ), // Style icon
//         style: TextStyle(color: Colors.black87, fontSize: 16), // Style text
//         items: _roles
//             .map(
//               (role) => DropdownMenuItem(
//                 value: role,
//                 child: Row(
//                   // Keep icon if desired
//                   children: [
//                     Icon(
//                       role == 'shopkeeper' ? Icons.storefront : Icons.person,
//                       color: Colors.grey.shade600,
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       role.capitalizeFirst ?? role,
//                     ), // Capitalize for display
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//         onChanged: (value) => setState(() => _selectedRole = value),
//       ),
//     ),
//   );

//   Widget _textField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required String? Function(String?) validator,
//     TextInputType keyboardType = TextInputType.text, // Corrected parameter name
//   }) => Container(
//     decoration: _boxDecoration(),
//     child: TextFormField(
//       controller: controller,
//       keyboardType: keyboardType, // Use corrected parameter
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.grey.shade600), // Style icon
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade500), // Style hint
//         border: InputBorder.none,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 15,
//         ), // Adjusted padding
//       ),
//       validator: validator,
//     ),
//   );

//   Widget _passwordField({
//     required TextEditingController controller,
//     required String hint,
//     required bool obscure,
//     required VoidCallback toggle,
//     required String? Function(String?) validator,
//   }) => Container(
//     decoration: _boxDecoration(),
//     child: TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           Icons.lock_outline,
//           color: Colors.grey.shade600,
//         ), // Style icon
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade500), // Style hint
//         border: InputBorder.none,
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscure ? Icons.visibility_off : Icons.visibility,
//             color: Colors.grey.shade600, // Style icon
//           ),
//           onPressed: toggle,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 15,
//         ), // Adjusted padding
//       ),
//       validator: validator,
//     ),
//   );

//   Widget _signUpButton() => ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFF5F7D5D), // Use primary color
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       padding: const EdgeInsets.symmetric(vertical: 15), // Consistent padding
//       minimumSize: const Size(double.infinity, 50), // Make button wide
//     ),
//     onPressed: _isLoading ? null : _signUp, // Disable when loading
//     child: _isLoading
//         ? const SizedBox(
//             // Show spinner inside button
//             height: 24,
//             width: 24,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             ),
//           )
//         : const Row(
//             // Keep icon and text layout
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Sign Up",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//               SizedBox(width: 8),
//               Icon(Icons.arrow_forward, color: Colors.white, size: 20),
//             ],
//           ),
//   );

//   Widget _loginRedirectButton() => TextButton(
//     // Changed to TextButton for subtlety
//     style: TextButton.styleFrom(
//       foregroundColor: Colors.black54, // Less prominent color
//     ),
//     child: const Text(
//       "Already have an account? Sign In",
//       style: TextStyle(decoration: TextDecoration.underline), // Keep underline
//     ),
//     // Use Get.back() to simply pop this screen and return to Login
//     onPressed: () => Get.back(), // <-- THIS LINE WAS THE PROBLEM
//   );

//   Widget _bottomImage() => Align(
//     // Align image to bottom left
//     alignment: Alignment.bottomLeft,
//     child: Image.asset(
//       "assets/imgs/2.jpg", // Ensure path is correct
//       height: 180, // Slightly smaller
//       // width: MediaQuery.of(context).size.width * 0.5, // Example width
//       fit: BoxFit.contain, // Use contain or cover as needed
//     ),
//   );

//   BoxDecoration _boxDecoration() => BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(12), // Less rounded
//     boxShadow: [
//       BoxShadow(
//         color: Colors.grey.withOpacity(0.15), // Softer shadow
//         spreadRadius: 1,
//         blurRadius: 5,
//         offset: const Offset(0, 2),
//       ),
//     ],
//     border: Border.all(
//       color: Colors.grey.shade200,
//       width: 0.8,
//     ), // Subtle border
//   );
// }

import 'package:dukan_sathi/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:dukan_sathi/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Renamed usernameController to nameController for clarity
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  // States
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole = "customer"; // Default to customer, use lowercase
  final List<String> _roles = [
    "customer",
    "shopkeeper",
  ]; // Simplified roles for Firestore

  bool _isLoading = false; // Loading state for button
  String _errorMessage = ""; // Error message state

  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // --- Sign Up Function ---
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return; // Validation failed

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // 1. Create user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        // 2. Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text
              .trim()
              .toLowerCase(), // Store email consistently
          'role': _selectedRole, // Use the selected role (customer/shopkeeper)
          'createdAt': Timestamp.now(), // Good practice to add a timestamp
        });

        // Success - show success message and let AuthGate handle navigation
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          Get.snackbar(
            'Success!',
            'Account created successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );

          // Navigate to AuthGate which will automatically redirect based on auth state
          Get.offAll(() => AuthGate());
        }
        return; // Important: return here
      } else {
        throw Exception("User creation failed, user is null.");
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'An error occurred during sign up.';
        print("Firebase Auth Error (${e.code}): ${e.message}");
      }
      if (mounted) {
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("General Sign Up Error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "An unexpected error occurred.";
          _isLoading = false;
        });
      }
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

  Widget _headerImage() => Image.asset(
    "assets/imgs/1.png", // Ensure path is correct
    width: double.infinity,
    height: 110,
    fit: BoxFit.cover, // Added fit
  );

  Widget _formSection() => Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Removed SizedBox to reduce top space
          const Text(
            "Create account",
            style: TextStyle(
              fontSize: 28, // Slightly larger
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center, // Center title
          ),
          const SizedBox(height: 30),

          _roleDropdown(),
          const SizedBox(height: 20),

          // Changed Username to Name
          _textField(
            controller: nameController,
            hint: "Full Name",
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? "Enter your full name" : null,
          ),
          const SizedBox(height: 20),

          _textField(
            // Added Email Field
            controller: emailController,
            hint: "E-mail",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return "Enter email";
              if (!GetUtils.isEmail(v))
                return "Enter valid email"; // Use GetUtils
              return null;
            },
          ),
          const SizedBox(height: 20),

          _passwordField(
            controller: passwordController,
            hint: "Password",
            obscure: _obscurePassword,
            toggle: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
            validator: (v) => (v == null || v.length < 6)
                ? "Min 6 characters required"
                : null,
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

          if (_errorMessage.isNotEmpty) // Display error message
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

          _signUpButton(),
        ],
      ),
    ),
  );

  Widget _roleDropdown() => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 5,
    ), // Added vertical padding
    decoration: _boxDecoration(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedRole,
        isExpanded: true,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ), // Style icon
        style: TextStyle(color: Colors.black87, fontSize: 16), // Style text
        items: _roles
            .map(
              (role) => DropdownMenuItem(
                value: role,
                child: Row(
                  // Keep icon if desired
                  children: [
                    Icon(
                      role == 'shopkeeper' ? Icons.storefront : Icons.person,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      role.capitalizeFirst ?? role,
                    ), // Capitalize for display
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
    TextInputType keyboardType = TextInputType.text, // Corrected parameter name
  }) => Container(
    decoration: _boxDecoration(),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType, // Use corrected parameter
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade600), // Style icon
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500), // Style hint
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ), // Adjusted padding
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
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.grey.shade600,
        ), // Style icon
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500), // Style hint
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600, // Style icon
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ), // Adjusted padding
      ),
      validator: validator,
    ),
  );

  Widget _signUpButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5F7D5D), // Use primary color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 15), // Consistent padding
      minimumSize: const Size(double.infinity, 50), // Make button wide
    ),
    onPressed: _isLoading ? null : _signUp, // Disable when loading
    child: _isLoading
        ? const SizedBox(
            // Show spinner inside button
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : const Row(
            // Keep icon and text layout
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
  );

  Widget _loginRedirectButton() => TextButton(
    // Changed to TextButton for subtlety
    style: TextButton.styleFrom(
      foregroundColor: Colors.black54, // Less prominent color
    ),
    child: const Text(
      "Already have an account? Sign In",
      style: TextStyle(decoration: TextDecoration.underline), // Keep underline
    ),
    // Use Get.back() to simply pop this screen and return to Login
    onPressed: () => Get.back(), // <-- THIS LINE WAS THE PROBLEM
  );

  Widget _bottomImage() => Align(
    // Align image to bottom left
    alignment: Alignment.bottomLeft,
    child: Image.asset(
      "assets/imgs/2.jpg", // Ensure path is correct
      height: 180, // Slightly smaller
      // width: MediaQuery.of(context).size.width * 0.5, // Example width
      fit: BoxFit.contain, // Use contain or cover as needed
    ),
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12), // Less rounded
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15), // Softer shadow
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
    border: Border.all(
      color: Colors.grey.shade200,
      width: 0.8,
    ), // Subtle border
  );
}
