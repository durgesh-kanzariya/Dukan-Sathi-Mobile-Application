import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/bottom_nav.dart';
import 'change_password.dart';
import 'history.dart';
// --- NEW IMPORTS ---
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // --- STATE & CONTROLLERS ---
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  XFile? _imageFile;
  String? _networkImageUrl; // To store the existing image URL
  bool _isLoadingData = true;
  bool _isSaving = false;
  User? _currentUser;

  // --- FIREBASE INSTANCES ---
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserData();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- 1. LOAD USER DATA ---
  Future<void> _loadUserData() async {
    if (_currentUser == null) {
      setState(() => _isLoadingData = false);
      return;
    }

    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _emailController.text = _currentUser!.email ?? data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _networkImageUrl = data['imageUrl'];

        // Assuming username is part of email or a separate field
        _userNameController.text =
            data['username'] ??
            _emailController.text.split('@').firstOrNull ??
            '';
      }
    } catch (e) {
      print("Error loading user data: $e");
      Get.snackbar('Error', 'Could not load your profile data.');
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  // --- 2. PICK IMAGE ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  // --- 3. UPLOAD IMAGE (Helper) ---
  Future<String> _uploadImage(XFile imageFile) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          '${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      Reference storageRef = _storage
          .ref()
          .child('profile_images') // A different folder for customers
          .child(_currentUser!.uid)
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      throw Exception('Image upload failed');
    }
  }

  // --- 4. SAVE CHANGES ---
  Future<void> _saveChanges() async {
    if (_currentUser == null) return;

    setState(() => _isSaving = true);
    try {
      String? imageUrl = _networkImageUrl;

      // If user picked a new image, upload it
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      // Update Firestore
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'imageUrl': imageUrl, // Save the new or existing URL
      });

      setState(() {
        _networkImageUrl = imageUrl;
        _imageFile = null; // Clear picked file
      });
      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      print("Error saving changes: $e");
      Get.snackbar('Error', 'Could not save profile. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // --- 5. SIGN OUT (THE FIX) ---
  Future<void> _signOut() async {
    try {
      // THIS IS THE ONLY LINE NEEDED FOR LOGOUT.
      // AuthGate will see this and automatically show the Login screen.
      await _auth.signOut();

      // --- THIS IS THE FIX ---
      // After signing out, just close the current profile page.
      // AuthGate has already put the Login screen underneath.
      Get.back();
    } catch (e) {
      print("Error signing out: $e");
      Get.snackbar('Error', 'Could not sign out.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7D60)),
            )
          : Column(
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
                          'Your username',
                          Icons.person_outline,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          _nameController,
                          'Full Name',
                          'Your full name',
                          Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          _emailController,
                          'Email Address',
                          'Your email',
                          Icons.email_outlined,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        _buildLabeledTextField(
                          _phoneController,
                          'Phone Number',
                          'Your phone number',
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
    ImageProvider? backgroundImage;
    if (_imageFile != null) {
      backgroundImage = FileImage(File(_imageFile!.path));
    } else if (_networkImageUrl != null) {
      backgroundImage = NetworkImage(_networkImageUrl!);
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: backgroundImage,
          child: backgroundImage == null
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
        onPressed: _isSaving ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Save Changes'),
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
        // --- THIS IS THE FIX ---
        onPressed: _signOut,
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
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
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
