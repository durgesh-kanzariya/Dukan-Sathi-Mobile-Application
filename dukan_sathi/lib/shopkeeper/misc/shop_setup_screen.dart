// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dukan_sathi/shop_service.dart';

// class ShopSetupScreen extends StatefulWidget {
//   const ShopSetupScreen({Key? key}) : super(key: key);

//   @override
//   _ShopSetupScreenState createState() => _ShopSetupScreenState();
// }

// class _ShopSetupScreenState extends State<ShopSetupScreen> {
//   final ShopService shopService = Get.find<ShopService>();

//   final TextEditingController _shopNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _fromTimeController = TextEditingController();
//   final TextEditingController _toTimeController = TextEditingController();

//   XFile? _imageFile;
//   String _selectedCountryCode = '+91';
//   String _fromPeriod = 'AM';
//   String _toPeriod = 'PM';
//   bool _isCreating = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F3E7),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Color(0xFF5A7D60),
//                     ),
//                     onPressed: () {
//                       // Don't allow going back - they must complete setup
//                       Get.snackbar(
//                         'Required',
//                         'Please complete shop setup to continue',
//                       );
//                     },
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     'Setup Your Shop',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF5A7D60),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Welcome! Please set up your shop details to get started.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),

//               // Form
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildProfileImagePicker(),
//                       const SizedBox(height: 24),
//                       _buildTextField(_shopNameController, 'Shop Name *'),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         _descriptionController,
//                         'Shop Description',
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         _addressController,
//                         'Shop Address *',
//                         maxLines: 2,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildPhoneNumberField(),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Business Hours',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTimeField(
//                               _fromTimeController,
//                               'Opening Time',
//                               _fromPeriod,
//                               (val) => setState(() => _fromPeriod = val!),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: _buildTimeField(
//                               _toTimeController,
//                               'Closing Time',
//                               _toPeriod,
//                               (val) => setState(() => _toPeriod = val!),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 40),
//                       _buildCreateButton(),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImagePicker() {
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundColor: Colors.grey.shade300,
//               backgroundImage: _imageFile != null
//                   ? FileImage(File(_imageFile!.path)) as ImageProvider
//                   : null,
//               child: _imageFile == null
//                   ? const Icon(Icons.storefront, size: 50, color: Colors.grey)
//                   : null,
//             ),
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: const Color(0xFF5A7D60),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 onPressed: _pickImage,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Shop Logo (Optional)',
//           style: TextStyle(color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _imageFile = image;
//       });
//     }
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String labelText, {
//     int maxLines = 1,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: labelText,
//           fillColor: Colors.white,
//           filled: true,
//           labelStyle: const TextStyle(color: Colors.grey),
//           floatingLabelStyle: const TextStyle(color: Color(0xFF5A7D60)),
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 16,
//             horizontal: 20,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(color: Color(0xFF5A7D60), width: 2),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPhoneNumberField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(left: 12.0),
//               child: DropdownButton<String>(
//                 value: _selectedCountryCode,
//                 underline: Container(),
//                 items: <String>['+91', '+1', '+44', '+61']
//                     .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     })
//                     .toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCountryCode = newValue!;
//                   });
//                 },
//               ),
//             ),
//             const VerticalDivider(color: Colors.grey, thickness: 1),
//             Expanded(
//               child: TextField(
//                 controller: _contactController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   hintText: 'Contact Number *',
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 16,
//                     horizontal: 10,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeField(
//     TextEditingController controller,
//     String label,
//     String period,
//     Function(String?) onChanged,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.datetime,
//               decoration: InputDecoration(
//                 hintText: label,
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                   horizontal: 20,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: DropdownButton<String>(
//               value: period,
//               underline: Container(),
//               items: <String>['AM', 'PM'].map<DropdownMenuItem<String>>((
//                 String value,
//               ) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreateButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _isCreating ? null : _createShop,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF5A7D60),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         child: _isCreating
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : const Text('Create Shop & Get Started'),
//       ),
//     );
//   }

//   Future<void> _createShop() async {
//     // Validation
//     if (_shopNameController.text.trim().isEmpty) {
//       Get.snackbar('Required', 'Please enter shop name');
//       return;
//     }
//     if (_addressController.text.trim().isEmpty) {
//       Get.snackbar('Required', 'Please enter shop address');
//       return;
//     }

//     setState(() {
//       _isCreating = true;
//     });

//     try {
//       // First create the shop
//       await shopService.createNewShop(
//         shopName: _shopNameController.text.trim(),
//         address: _addressController.text.trim(),
//         description: _descriptionController.text.trim(),
//         contact: '$_selectedCountryCode ${_contactController.text.trim()}',
//         openTime: '${_fromTimeController.text.trim()} $_fromPeriod',
//         closeTime: '${_toTimeController.text.trim()} $_toPeriod',
//       );

//       // Then upload image if selected
//       if (_imageFile != null) {
//         await shopService.updateShopImage(_imageFile!);
//       }

//       // Success - the ShopkeeperMainScreen will automatically rebuild and show the dashboard
//       Get.snackbar('Success', 'Shop setup completed!');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to create shop: $e');
//     } finally {
//       setState(() {
//         _isCreating = false;
//       });
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukan_sathi/shop_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import this

class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({Key? key}) : super(key: key);

  @override
  _ShopSetupScreenState createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  final ShopService shopService = Get.find<ShopService>();

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  XFile? _imageFile;
  String _selectedCountryCode = '+91';
  String _fromPeriod = 'AM';
  String _toPeriod = 'PM';
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER WITH LOGOUT BUTTON ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Setup Your Shop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A7D60),
                    ),
                  ),
                  // LOGOUT BUTTON (Escape Hatch)
                  TextButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // AuthGate will handle the redirect to login
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome! Please set up your shop details to get started.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileImagePicker(),
                      const SizedBox(height: 24),
                      _buildTextField(_shopNameController, 'Shop Name *'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _descriptionController,
                        'Shop Description',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _addressController,
                        'Shop Address *',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildPhoneNumberField(),
                      const SizedBox(height: 24),
                      const Text(
                        'Business Hours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeField(
                              _fromTimeController,
                              'Opening Time',
                              _fromPeriod,
                              (val) => setState(() => _fromPeriod = val!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimeField(
                              _toTimeController,
                              'Closing Time',
                              _toPeriod,
                              (val) => setState(() => _toPeriod = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildCreateButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _imageFile != null
                  ? FileImage(File(_imageFile!.path)) as ImageProvider
                  : null,
              child: _imageFile == null
                  ? const Icon(Icons.storefront, size: 50, color: Colors.grey)
                  : null,
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF5A7D60),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _pickImage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Shop Logo (Optional)',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
        decoration: InputDecoration(
          labelText: labelText,
          fillColor: Colors.white,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFF5A7D60)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
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
        borderRadius: BorderRadius.circular(15),
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
                  hintText: 'Contact Number *',
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
        borderRadius: BorderRadius.circular(15),
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

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCreating ? null : _createShop,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: _isCreating
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Create Shop & Get Started'),
      ),
    );
  }

  Future<void> _createShop() async {
    // Validation
    if (_shopNameController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter shop name');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter shop address');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // First create the shop
      await shopService.createNewShop(
        shopName: _shopNameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        contact: '$_selectedCountryCode ${_contactController.text.trim()}',
        openTime: '${_fromTimeController.text.trim()} $_fromPeriod',
        closeTime: '${_toTimeController.text.trim()} $_toPeriod',
      );

      // Then upload image if selected
      if (_imageFile != null) {
        await shopService.updateShopImage(_imageFile!);
      }

      // Success - the ShopkeeperMainScreen will automatically rebuild and show the dashboard
      Get.snackbar('Success', 'Shop setup completed!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create shop: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}
