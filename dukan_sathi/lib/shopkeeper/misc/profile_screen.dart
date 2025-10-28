import 'dart:io';
import 'package:dukan_sathi/Login.dart'; // Import Login for navigation
import 'package:dukan_sathi/shopkeeper/misc/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:image_picker/image_picker.dart';
// Provider not strictly needed here if we fetch data directly
// import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  XFile? _imageFile;
  User? _currentUser;
  bool _isLoadingData = true; // State to manage loading indicator

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingData = true;
    }); // Start loading
    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? 'No Email';
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          _nameController.text = data['name'] ?? 'No Name';
          // TODO: Load image URL if stored:
          // String? imageUrl = data['imageUrl'];
          // if (imageUrl != null && imageUrl.isNotEmpty) {
          //   // You'll need a way to display this NetworkImage or File image based on _imageFile
          // }
        } else {
          _nameController.text = 'Name not found';
        }
      } catch (e) {
        print("Error loading user data: $e");
        _nameController.text = 'Error loading name';
        if (mounted) {
          // Show snackbar on error
          Get.snackbar(
            'Error',
            'Could not load profile data.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
          );
        }
      }
    }
    if (mounted) {
      setState(() {
        _isLoadingData = false;
      }); // Stop loading
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        // TODO: Upload image to Firebase Storage & update Firestore 'imageUrl'
        Get.snackbar(
          'Success',
          'Image selected. Upload logic needed.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar(
        'Error',
        'Could not pick image.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Logout Function using GetX ---
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // By ONLY calling signOut(), the StreamProvider in main.dart
      // will fire, AuthGate will get 'null', and it will
      // automatically return the Login screen.

      // ** THE FIX IS HERE: **
      // Now, we just need to close this profile page
      // to reveal the Login screen underneath.
      if (mounted) {
        Get.back();
      }
    } catch (e) {
      print("Error signing out: $e");
      Get.snackbar(
        // Use GetX snackbar
        'Logout Error',
        'Could not sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body:
          _isLoadingData // Show loading indicator while data loads
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7D60)),
            )
          : Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildProfileImagePicker(),
                        const SizedBox(height: 24),
                        _buildTextField(_nameController, 'Full Name'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _emailController,
                          'Email Address',
                          enabled: false,
                        ),
                        const SizedBox(height: 32),
                        // TODO: Add Update Profile Button
                        _buildActionButton(
                          text: 'Update Profile',
                          onPressed: () {
                            // TODO: Implement logic to update name in Firestore
                            // Optionally re-upload image if _imageFile is not null
                            Get.snackbar(
                              'Info',
                              'Update Profile logic not implemented.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          isPrimary: true, // Use primary style for update
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          text: 'Change Password',
                          onPressed: () {
                            // Use Get.to for navigation that allows going back
                            Get.to(
                              () => ChangePasswordAdmin(),
                            ); // Ensure this page exists
                          },
                          // Make Change Password less prominent? Or use primary style?
                          isPrimary: true, // Example: Using primary style
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          text: 'Logout',
                          onPressed: _signOut, // Call updated sign out
                          isPrimary:
                              false, // Logout is secondary / destructive action
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // --- Builder methods remain largely the same ---
  // (Header, Image Picker, TextField, ActionButton)
  // Make sure asset paths in _buildHeader and font names are correct

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                // Use Get.back() if this screen was pushed using Get.to()
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  'DUKAN SATHI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 4,
                    fontFamily: "Abel", // Ensure this font is in pubspec.yaml
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balances the IconButton
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    // TODO: Load profile image from user data (e.g., Firestore 'imageUrl' field)
    // For now, it uses the picked file or a placeholder
    ImageProvider<Object>? backgroundImage;
    if (_imageFile != null) {
      backgroundImage = FileImage(File(_imageFile!.path));
    } else {
      // You could load a network image URL from user data here
      // Example:
      // if (_currentUser?.photoURL != null) { // From Firebase Auth profile (if updated)
      //   backgroundImage = NetworkImage(_currentUser!.photoURL!);
      // }
      // Or load from your Firestore 'imageUrl' field
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: backgroundImage,
          child: backgroundImage == null
              ? const Icon(Icons.person, size: 70, color: Colors.grey)
              : null,
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF5A7D60),
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 20),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // Style the label text
        labelStyle: TextStyle(
          color: enabled ? Colors.grey.shade600 : Colors.grey.shade500,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ), // Consistent padding
      ),
      // Style the input text
      style: TextStyle(color: enabled ? Colors.black87 : Colors.grey.shade700),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF5A7D60) // Primary green
              : Colors.red.shade400, // Secondary/Destructive red
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 3, // Add subtle elevation
        ),
        child: Text(text),
      ),
    );
  }
}
