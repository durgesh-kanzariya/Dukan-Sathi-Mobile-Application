import 'package:flutter/material.dart';
import 'products_screen.dart'; // We need the data models from here

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Controllers for the text fields
  late TextEditingController _productNameController;
  final TextEditingController _variantNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();

  // A mutable list to hold the variants for this editing session
  late List<ProductVariant> _variants;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.product.name);
    // Create a mutable copy of the product's variants
    _variants = List<ProductVariant>.from(widget.product.variants);
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed
    _productNameController.dispose();
    _variantNameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  void _addVariant() {
    // Basic validation to ensure fields are not empty
    if (_variantNameController.text.isNotEmpty &&
        _buyPriceController.text.isNotEmpty &&
        _sellPriceController.text.isNotEmpty) {
      final newVariant = ProductVariant(
        name: _variantNameController.text,
        buyPrice: double.tryParse(_buyPriceController.text) ?? 0.0,
        sellPrice: double.tryParse(_sellPriceController.text) ?? 0.0,
        stock: 0, // Default stock for a new variant
      );

      setState(() {
        _variants.add(newVariant);
      });

      // Clear the text fields after adding
      _variantNameController.clear();
      _buyPriceController.clear();
      _sellPriceController.clear();
      // Hide the keyboard
      FocusScope.of(context).unfocus();
    }
  }

  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
    });
  }

  // --- UI BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      // CHANGE: The main layout is now a Column.
      // This allows the header to be fixed at the top.
      body: Column(
        children: [
          _buildHeader(context),
          // The rest of the content is wrapped in an Expanded SingleChildScrollView.
          // This makes the content below the header scrollable.
          SizedBox(height: 16),
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
    // This header is consistent with other detail pages
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
          const SizedBox(width: 48), // Balances the IconButton
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              widget.product.imageUrl,
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
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  // TODO: Add image picker logic
                },
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
            hint: 'Chocolate Cake',
          ),
          const SizedBox(height: 16),
          _buildTextField(controller: _variantNameController, hint: 'Variant'),
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
          const SizedBox(height: 4),
          _buildVariantList(),
          const SizedBox(height: 16),
          _buildActionButton(
            text: 'Update details',
            onPressed: () {
              // TODO: Add logic to save all changes
              Navigator.of(context).pop(); // Go back after updating
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
    // If the list is empty, show a message.
    if (_variants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('No variants added yet.', textAlign: TextAlign.center),
      );
    }
    // Otherwise, build the list of variants.
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
                  '\$${variant.buyPrice.toStringAsFixed(2)} - \$${variant.sellPrice.toStringAsFixed(2)}',
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
