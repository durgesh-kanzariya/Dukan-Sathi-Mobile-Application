import 'dart:io'; // Required for using the File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 1. Import the package
import 'products_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // --- STATE VARIABLES ---
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _variantNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final List<ProductVariant> _variants = [];

  // 2. Add a variable to hold the selected image file
  File? _selectedImage;

  @override
  void dispose() {
    _productNameController.dispose();
    _variantNameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  // 3. Create a method to handle picking an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Open the gallery to pick an image
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // If an image is selected, update the state to display it
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addVariant() {
    if (_variantNameController.text.isNotEmpty &&
        _buyPriceController.text.isNotEmpty &&
        _sellPriceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty) {
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
  }

  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
    });
  }

  // --- UI BUILDER METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [_buildImagePicker(), _buildAddForm()]),
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Add New Product',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        // 4. Call the _pickImage method on tap
        onTap: _pickImage,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[300],
            // 5. Conditionally display the selected image or the placeholder
            child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text('Tap to upload image'),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    // ... (The rest of the form remains unchanged)
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
          _buildTextField(
            controller: _variantNameController,
            hint: 'Variant Name (e.g., 1 KG)',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _buyPriceController,
                  hint: 'Buy Price',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _sellPriceController,
                  hint: 'Sell Price',
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
            text: 'Add Variant',
            onPressed: _addVariant,
            isPrimary: true,
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Variant list',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E4431),
            ),
          ),
          _buildVariantList(),
          const SizedBox(height: 16),
          _buildActionButton(
            text: 'Save Product',
            onPressed: () {
              // TODO: Add logic to save the new product
              Navigator.of(context).pop();
            },
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  variant.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Buy: \$${variant.buyPrice.toStringAsFixed(2)} - Sell: \$${variant.sellPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _removeVariant(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFFB3C5B5)
            : const Color(0xFF5A7D60),
        foregroundColor: isPrimary ? const Color(0xFF2E4431) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}
