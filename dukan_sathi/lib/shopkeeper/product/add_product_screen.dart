import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'product_model.dart';
import 'product_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController controller = Get.find<ProductController>();

  final TextEditingController _productNameController = TextEditingController();
  // --- 1. ADD DESCRIPTION CONTROLLER ---
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _variantNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final List<ProductVariant> _variants = [];
  XFile? _imageFile;

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose(); // --- 2. DISPOSE IT ---
    _variantNameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    super.dispose();
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

  void _addVariant() {
    if (_variantNameController.text.isEmpty ||
        _buyPriceController.text.isEmpty ||
        _sellPriceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all variant fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newVariant = ProductVariant(
      name: _variantNameController.text,
      buyPrice: double.tryParse(_buyPriceController.text) ?? 0.0,
      sellPrice: double.tryParse(_sellPriceController.text) ?? 0.0,
      stock: int.tryParse(_stockController.text) ?? 0,
    );
    setState(() {
      _variants.add(newVariant);
    });
    _variantNameController.clear();
    _buyPriceController.clear();
    _sellPriceController.clear();
    _stockController.clear();
    FocusScope.of(context).unfocus();
  }

  // --- ADD THIS METHOD ---
  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
    });
  }
  // --- END OF ADDITION ---

  void _validateAndSubmit() async {
    // Prevent multiple submissions
    if (controller.isUploading.value) {
      return;
    }

    final List<String> errors = [];

    if (_productNameController.text.isEmpty) {
      errors.add('- Product name cannot be empty.');
    }
    if (_descriptionController.text.isEmpty) {
      errors.add('- Product description cannot be empty.');
    }
    if (_imageFile == null) {
      errors.add('- Please select a product image.');
    }
    if (_variants.isEmpty) {
      errors.add('- Please add at least one variant.');
    }

    if (errors.isNotEmpty) {
      _showErrorDialog(errors);
    } else {
      bool success = await controller.addProduct(
        name: _productNameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageFile: _imageFile!,
        variants: _variants,
      );

      if (success) {
        Get.snackbar('Success', 'Product added successfully!');
        // Clear the form and reset state
        _resetForm();
        // Navigate back after success
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.back();
        });
      }
    }
  }

  // Add this method to reset the form
  void _resetForm() {
    _productNameController.clear();
    _descriptionController.clear();
    _variantNameController.clear();
    _buyPriceController.clear();
    _sellPriceController.clear();
    _stockController.clear();
    setState(() {
      _variants.clear();
      _imageFile = null;
    });
  }

  void _showErrorDialog(List<String> errors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Incomplete Information',
          style: TextStyle(fontSize: 25),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors
              .map((error) => Text(error, style: TextStyle(fontSize: 16)))
              .toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [_buildProductImage(), _buildAddForm()]),
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
            'Add product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: 250,
              width: double.infinity,
              color: _imageFile == null
                  ? Colors.grey.shade200
                  : Colors.transparent,
              child: _imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 50,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFD3E0D4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _productNameController,
            hint: 'Product Name',
          ),
          const SizedBox(height: 16),
          // --- 5. ADD DESCRIPTION TEXT FIELD ---
          _buildTextField(
            controller: _descriptionController,
            hint: 'Product Description',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _variantNameController,
            hint: 'Variant Name',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _buyPriceController,
                  hint: 'Buy price',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _sellPriceController,
                  hint: 'Sell price',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _stockController,
            hint: 'Stock Quantity',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            text: 'Add variant',
            onPressed: _addVariant,
            isPrimary: true,
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white, thickness: 2),
          const SizedBox(height: 3),
          const Center(
            child: Text(
              'Variant list',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4431),
              ),
            ),
          ),
          const SizedBox(height: 3),
          const Divider(color: Colors.white, thickness: 2),
          _buildVariantListHeader(),
          _buildVariantList(),
          const SizedBox(height: 24),
          Obx(
            () => _buildActionButton(
              text: 'Create Product',
              onPressed: controller.isUploading.value
                  ? null
                  : _validateAndSubmit, // Use null to disable
              isPrimary: false,
              isLoading: controller.isUploading.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1, // Add maxLines
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines, // Use maxLines
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  Widget _buildVariantListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 3, child: SizedBox()),
          _buildHeaderCell('Buy'),
          _buildHeaderCell('Sell'),
          _buildHeaderCell('Stock'),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Expanded(
      flex: 2,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildVariantList() {
    if (_variants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('No variants added yet.', textAlign: TextAlign.center),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _variants.length,
      itemBuilder: (context, index) {
        final variant = _variants[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    variant.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '\$${variant.buyPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '\$${variant.sellPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${variant.stock}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeVariant(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed, // Make it nullable
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed, // Will be null when disabled
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFFB3C5B5)
            : const Color(0xFF5A7D60),
        foregroundColor: isPrimary ? const Color(0xFF2E4431) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
