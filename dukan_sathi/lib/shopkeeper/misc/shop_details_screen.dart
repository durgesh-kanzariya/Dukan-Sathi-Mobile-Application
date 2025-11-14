import 'dart:io';
import 'package:dukan_sathi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get
import 'package:image_picker/image_picker.dart';
import 'package:dukan_sathi/shop_service.dart'; // Import ShopService
import 'package:dukan_sathi/shop_model.dart'; // Import Shop Model

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  // --- 1. FIND THE SERVICE ---
  final ShopService shopService = Get.find<ShopService>();

  // --- 2. REMOVE STATIC TEXT ---
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  XFile? _imageFile; // This is for a *new* image to upload
  String _selectedCountryCode = '+91';
  String _fromPeriod = 'AM';
  String _toPeriod = 'PM';

  @override
  void initState() {
    super.initState();
    // --- 3. LOAD DATA & LISTEN FOR CHANGES ---
    // Listen for changes from the service
    shopService.currentShop.listen(_updateControllers);
    // Load initial data if it's already available
    _updateControllers(shopService.currentShop.value);
  }

  // --- 4. NEW METHOD TO POPULATE FIELDS ---
  void _updateControllers(Shop? shop) {
    if (shop != null && mounted) {
      // Set text fields
      _shopNameController.text = shop.shopName;
      _descriptionController.text = shop.description;
      _addressController.text = shop.address;
      _contactController.text = shop.contact;

      // We can't edit username (ownerId), so we'll just display it
      _usernameController.text = shop.ownerId;

      // Parse time strings, e.g., "9:00 AM"
      var openTimeParts = shop.openTime.split(' ');
      if (openTimeParts.length == 2) {
        _fromTimeController.text = openTimeParts[0];
        _fromPeriod = openTimeParts[1];
      }

      var closeTimeParts = shop.closeTime.split(' ');
      if (closeTimeParts.length == 2) {
        _toTimeController.text = closeTimeParts[0];
        _toPeriod = closeTimeParts[1];
      }
      setState(() {}); // Ensure UI updates with new period
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _shopNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    super.dispose();
  }

  // --- 5. UPDATED IMAGE PICKER ---
  Future<void> _pickImage() async {
    print('_pickImage called');

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print('Image selected: ${image.path}');

      try {
        await shopService.updateShopImage(image);
        print('updateShopImage completed');
      } catch (e) {
        print('Error in updateShopImage: $e');
        Get.snackbar('Error', 'Cannot update image: $e');
      }
    } else {
      print('No image selected');
    }
  }

  // --- 6. UPDATED SAVE METHOD ---
  void _saveChanges() {
    // Validation (you can add more)
    if (_shopNameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Shop Name and Address cannot be empty.');
      return;
    }

    // Call the service
    shopService.updateShopDetails(
      shopName: _shopNameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
      contact: _contactController.text.trim(),
      openTime: '${_fromTimeController.text.trim()} $_fromPeriod',
      closeTime: '${_toTimeController.text.trim()} $_toPeriod',
    );
  }

  // (Error dialog method _showErrorDialog removed as Get.snackbar handles it)

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(title: 'Shop Details'),
        Expanded(
          // --- 7. WRAP IN Obx TO SHOW LOADING SPINNER ---
          child: Obx(() {
            if (shopService.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF5A7D60)),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildProfileImagePicker(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    _usernameController,
                    'Shop Owner ID', // Changed label
                    enabled: false, // Cannot edit
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(_shopNameController, 'Shop Name'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _descriptionController,
                    'Shop Description',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _addressController,
                    'Shop Address',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneNumberField(), // This now uses _contactController
                  const SizedBox(height: 24),
                  const Text(
                    'Business Hours',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeField(
                          _fromTimeController,
                          'From',
                          _fromPeriod,
                          (val) {
                            setState(() => _fromPeriod = val!);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeField(
                          _toTimeController,
                          'To',
                          _toPeriod,
                          (val) {
                            setState(() => _toPeriod = val!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                  const SizedBox(height: 95), // For bottom nav
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProfileImagePicker() {
    return Obx(() {
      // --- 8. GET IMAGE URL FROM SERVICE ---
      final imageUrl = shopService.currentShop.value?.imageUrl;
      final isUploading = shopService.isUploadingImage.value;

      ImageProvider? backgroundImage;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        backgroundImage = NetworkImage(imageUrl);
      }

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: backgroundImage,
            child: (backgroundImage == null && !isUploading)
                ? Icon(Icons.storefront, size: 70, color: Colors.grey.shade500)
                : null,
          ),
          if (isUploading)
            const Positioned.fill(
              child: CircularProgressIndicator(
                color: Color(0xFF5A7D60),
                strokeWidth: 3,
              ),
            ),
          if (!isUploading)
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
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
        maxLines: maxLines,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFF5A7D60)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF5A7D60), width: 2),
          ),
        ),
      ),
    );
  }

  // --- 9. UPDATED TO USE _contactController ---
  Widget _buildPhoneNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12.0),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                underline: Container(),
                items: <String>['+91', '+1', '+44', '+61']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue!;
                  });
                },
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            Expanded(
              child: TextField(
                controller: _contactController, // Use the correct controller
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Contact Number',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
    TextEditingController controller,
    String label,
    String period,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: period,
              underline: Container(),
              items: <String>['AM', 'PM'].map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB3C5B5),
          foregroundColor: const Color(0xFF2E4431),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Save changes'),
      ),
    );
  }
}
