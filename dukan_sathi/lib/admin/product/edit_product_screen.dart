import 'dart:io'; // Required for using the File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Required for image picking
import 'products_screen.dart'; // We need the data models from here

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // --- STATE & CONTROLLERS ---
  late TextEditingController _productNameController;
  final TextEditingController _variantNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  late List<ProductVariant> _variants;
  XFile? _imageFile; // State variable to hold the new image file

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.product.name);
    _variants = List<ProductVariant>.from(widget.product.variants);
  }

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

  // CHANGE 1: Added a new method to handle validation and submission.
  void _validateAndSubmit() {
    final List<String> errors = [];

    // Check for common errors
    if (_productNameController.text.isEmpty) {
      errors.add('- Product name cannot be empty.');
    }
    // Note: We don't check for an image here since one already exists.
    if (_variants.isEmpty) {
      errors.add('- A product must have at least one variant.');
    }

    // If there are errors, show a dialog
    if (errors.isNotEmpty) {
      _showErrorDialog(errors);
    } else {
      // If everything is valid, proceed to save (and then navigate back)
      // TODO: Add actual logic to save the updated product data
      Navigator.of(context).pop();
    }
  }

  // CHANGE 2: Created a helper widget to show the validation errors.
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

  // --- UI BUILD METHODS (Mostly unchanged) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [_buildProductImage(), _buildEditForm()]),
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
                onPressed: () => Navigator.of(context).pop(),
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
            'Edit product',
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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: _imageFile == null
                ? Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  )
                : Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
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
          const SizedBox(height: 8),
          _buildVariantListHeader(),
          _buildVariantList(),
          const SizedBox(height: 24),
          // CHANGE 3: The "Update details" button now calls the validation method.
          _buildActionButton(
            text: 'Update details',
            onPressed: _validateAndSubmit,
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
