import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'bottom_nav.dart';
import 'change_password.dart';
import 'history.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Controllers to manage the text in the TextFields
  final TextEditingController _userNameController = TextEditingController(
    text: '@xyzabcd',
  );
  final TextEditingController _nameController = TextEditingController(
    text: 'Dhokiya Jenil',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'xyz@gmail.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '9054831231',
  );

  XFile? _imageFile;

  // Logic to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  _buildProfileImagePicker(),
                  const SizedBox(height: 24),
                  _buildLabeledTextField(
                    _userNameController,
                    'Username',
                    '@xyzabcd',
                    Icons.person_outline,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    _nameController,
                    'Full Name',
                    'Jenil Dhokiya',
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    _emailController,
                    'Email Address',
                    'xyz@gmail.com',
                    Icons.email_outlined,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    _phoneController,
                    'Phone Number',
                    '9054831231',
                    Icons.phone_outlined,
                  ),
                  const SizedBox(height: 32),
                  _buildSaveChangesButton(),
                  const Divider(height: 40),
                  _buildSettingsTile(
                    'Change Password',
                    Icons.lock_outline,
                    () => Get.to(() => const ChangePassword()),
                  ),
                  _buildSettingsTile(
                    'View Order History',
                    Icons.history_outlined,
                    () => Get.to(() => const History()),
                  ),
                  const Divider(height: 40),
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  // No changes to _buildHeader, _buildProfileImagePicker, buttons, or settings tiles
  Widget _buildHeader() {
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
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
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
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: _imageFile != null
              ? FileImage(File(_imageFile!.path))
              : null,
          child: _imageFile == null
              ? const Icon(Icons.person, size: 70, color: Colors.white)
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

  Widget _buildSaveChangesButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.snackbar('Success', 'Profile updated successfully!');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('Save Changes'),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        onPressed: () {
          Get.offAll(() => const Login());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // UPDATED HELPER WIDGET
  Widget _buildLabeledTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The persistent label
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        // The TextField with the hint
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
