import 'dart:io';
import 'package:dukan_sathi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  // --- STATE & CONTROLLERS ---
  final TextEditingController _usernameController = TextEditingController(
    text: 'the_cake_shop',
  );
  final TextEditingController _shopNameController = TextEditingController(
    text: 'The Cake Shop',
  );
  final TextEditingController _descriptionController = TextEditingController(
    text:
        'Your one-stop destination for delicious, freshly baked cakes, pastries, and bread.',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '123 Kalawad Road, Near Crystal Mall, Rajkot, Gujarat',
  );
  final TextEditingController _contactController = TextEditingController(
    text: '98765 43210',
  );
  final TextEditingController _fromTimeController = TextEditingController(
    text: '9:00',
  );
  final TextEditingController _toTimeController = TextEditingController(
    text: '8:00',
  );

  XFile? _imageFile;

  String _selectedCountryCode = '+91';
  String _fromPeriod = 'AM';
  String _toPeriod = 'PM';

  @override
  void dispose() {
    // Clean up all controllers
    _usernameController.dispose();
    _shopNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _saveChanges() {
    final List<String> errorMessages = [];

    if (_shopNameController.text.trim().isEmpty) {
      errorMessages.add('• Shop Name cannot be empty.');
    }
    if (_descriptionController.text.trim().isEmpty) {
      errorMessages.add('• Shop Description cannot be empty.');
    }
    if (_addressController.text.trim().isEmpty) {
      errorMessages.add('• Shop Address cannot be empty.');
    }
    if (_contactController.text.trim().isEmpty) {
      errorMessages.add('• Contact number cannot be empty.');
    }
    if (_fromTimeController.text.trim().isEmpty) {
      errorMessages.add('• "From time" cannot be empty.');
    }
    if (_toTimeController.text.trim().isEmpty) {
      errorMessages.add('• "To time" cannot be empty.');
    }
    if (_fromTimeController.text.trim() == _toTimeController.text.trim() &&
        _fromPeriod == _toPeriod) {
      errorMessages.add(
        '• Business opening and closing times cannot be the same.',
      );
    }

    if (errorMessages.isNotEmpty) {
      _showErrorDialog(errorMessages);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF5A7D60),
          content: Text('Changes saved successfully!'),
        ),
      );
    }
  }

  void _showErrorDialog(List<String> messages) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: messages
              .map(
                (msg) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(msg),
                ),
              )
              .toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF5A7D60))),
          ),
        ],
      ),
    );
  }

  // --- UI BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(title: 'Shop Details'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildProfileImagePicker(),
                const SizedBox(height: 24),
                _buildTextField(
                  _usernameController,
                  'Shop Username',
                  enabled: false,
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
                _buildPhoneNumberField(),
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
                const SizedBox(height: 95),
              ],
            ),
          ),
        ),
      ],
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
              ? Icon(Icons.person, size: 70, color: Colors.grey.shade500)
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
                controller: _contactController,
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
