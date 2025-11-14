import 'dart:io';
import 'package:dukan_sathi/Login.dart';
import 'package:dukan_sathi/shopkeeper/misc/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  XFile? _imageFile;
  User? _currentUser;
  bool _isLoadingData = true;
  bool _isUpdating = false;
  bool _isUploadingImage = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingData = true;
    });

    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? 'No Email';
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          _nameController.text = data['name'] ?? 'No Name';
          _currentImageUrl = data['imageUrl'];
        } else {
          _nameController.text = 'Name not found';
        }
      } catch (e) {
        print("Error loading user data: $e");
        _nameController.text = 'Error loading name';
        Get.snackbar(
          'Error',
          'Could not load profile data.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        // Auto-upload when image is selected
        await _uploadProfileImage();
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

  // Add this method to delete old images
  Future<void> _deleteOldImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;

    try {
      // Create a reference from the download URL
      Reference storageRef = _storage.refFromURL(imageUrl);

      // Delete the file
      await storageRef.delete();

      print('Old profile image deleted successfully');
    } catch (e) {
      print('Error deleting old image: $e');
      // Don't throw error - we don't want image deletion failure to stop the update
    }
  }

  // Update the _uploadProfileImage method
  Future<void> _uploadProfileImage() async {
    if (_currentUser == null || _imageFile == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    String? oldImageUrl =
        _currentImageUrl; // Store the old image URL before updating

    try {
      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(_imageFile!);

      // Update Firestore with new image URL
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Delete the old image after successful update
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await _deleteOldImage(oldImageUrl);
      }

      // Update local state
      setState(() {
        _currentImageUrl = imageUrl;
        _isUploadingImage = false;
      });

      Get.snackbar(
        'Success',
        'Profile image updated!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error uploading image: $e");
      setState(() {
        _isUploadingImage = false;
      });
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  Future<String> _uploadImageToStorage(XFile imageFile) async {
    try {
      String fileExtension = p.extension(imageFile.path);
      String fileName =
          'profile_${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      Reference storageRef = _storage
          .ref()
          .child('profile_images')
          .child(_currentUser!.uid)
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Profile image upload error: $e");
      throw Exception('Profile image upload failed');
    }
  }

  // Also update the _updateProfile method to handle image cleanup
  Future<void> _updateProfile() async {
    if (_currentUser == null) return;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    String? oldImageUrl = _currentImageUrl; // Store old image URL

    try {
      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // If there's a new image, upload it first
      if (_imageFile != null) {
        String imageUrl = await _uploadImageToStorage(_imageFile!);
        updateData['imageUrl'] = imageUrl;

        // Update Firestore
        await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .update(updateData);

        // Delete the old image after successful update
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          await _deleteOldImage(oldImageUrl);
        }

        setState(() {
          _currentImageUrl = imageUrl;
        });
      } else {
        // Just update the name without changing image
        await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .update(updateData);
      }

      setState(() {
        _isUpdating = false;
        _imageFile = null; // Reset after successful update
      });

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error updating profile: $e");
      setState(() {
        _isUpdating = false;
      });
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _signOut() async {
    // Confirmation dialog before logout
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
          TextButton(
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Get.back();
              try {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Get.back();
                }
              } catch (e) {
                print("Error signing out: $e");
                Get.snackbar(
                  'Logout Error',
                  'Could not sign out. Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                );
              }
            },
          ),
        ],
      ),
    );
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
      body: _isLoadingData
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
                        _buildActionButton(
                          text: 'Update Profile',
                          onPressed: _isUpdating ? null : _updateProfile,
                          isPrimary: true,
                          isLoading: _isUpdating,
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          text: 'Change Password',
                          onPressed: () {
                            Get.to(() => ChangePasswordAdmin());
                          },
                          isPrimary: true,
                        ),
                        const SizedBox(height: 16),
                        _buildActionButton(
                          text: 'Logout',
                          onPressed: _signOut,
                          isPrimary: false,
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
                    fontFamily: "Abel",
                  ),
                ),
              ),
              const SizedBox(width: 48),
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
    ImageProvider? backgroundImage;

    // Priority: New selected image > Current stored image > Placeholder
    if (_imageFile != null) {
      backgroundImage = FileImage(File(_imageFile!.path));
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(_currentImageUrl!);
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: backgroundImage,
          child: _isUploadingImage
              ? const CircularProgressIndicator(color: Color(0xFF5A7D60))
              : (backgroundImage == null
                    ? const Icon(Icons.person, size: 70, color: Colors.grey)
                    : null),
        ),
        if (!_isUploadingImage)
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5A7D60), width: 2),
          ),
          labelStyle: TextStyle(
            color: enabled ? Colors.grey.shade600 : Colors.grey.shade500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF5A7D60)
              : Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}
