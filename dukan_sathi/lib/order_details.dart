import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_nav.dart';
import 'pickup_code.dart';

// --- DATA MODELS ---
// These models are structured to provide the data needed for the new design.
class OrderItem {
  final String imageUrl;
  final String name;
  final String variant;
  final double price;
  final int quantity;

  const OrderItem({
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
  });
}

class Order {
  final String id;
  final String status;
  final String shopName;
  final String date;
  final String address;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.status,
    required this.shopName,
    required this.date,
    required this.address,
    required this.items,
  });

  // Helper to calculate total price
  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}

// --- MOCK DATA ---
final mockOrder = Order(
  id: '812463187642',
  status: 'Ready To PickUp',
  shopName: 'Best Bakery',
  date: '31/08/2025',
  address: 'Mavdi chowk, nana mauva main road, Rajkot',
  items: [
    const OrderItem(
      imageUrl: "assets/imgs/image.png", // Make sure this path is correct
      name: "Chocolate Cake",
      variant: "1.5 KG",
      price: 50.0,
      quantity: 2,
    ),
    const OrderItem(
      imageUrl: "assets/imgs/image.png",
      name: "Butter Croissant",
      variant: "Pack of 4",
      price: 80.0,
      quantity: 1,
    ),
  ],
);

// --- MAIN WIDGET ---
class OrderDetails extends StatelessWidget {
  final Order order;
  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      // The body is a SingleChildScrollView, exactly like the shopkeeper screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderSummary(),
            const Divider(indent: 20, endIndent: 20),
            _buildItemList(),
            _buildTotalPrice(),
            _buildActionButton(), // Customer-specific button
            const SizedBox(height: 20),
          ],
        ),
      ),
      // RESTORED: The BottomNavigationBar is included.
      bottomNavigationBar: const BottomNav(),
    );
  }

  /// Header design taken directly from the Shopkeeper screen
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
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balances the IconButton
            ],
          ),
          const Text(
            'Order Details',
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

  /// Order summary section, matching the shopkeeper design
  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          _buildSummaryRow('Order id:', order.id),
          _buildSummaryRow('Order status:', order.status),
          _buildSummaryRow('Shop name:', order.shopName),
          _buildSummaryRow('Date:', order.date),
          _buildSummaryRow('Address:', order.address, isAddress: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isAddress = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: isAddress
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A7D60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Item list using Cards, matching the shopkeeper design
  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final item = order.items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item.variant,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        Text(
                          '₹${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF5A7D60),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Qty: ${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Total price section, aligned to the right like the shopkeeper screen
  Widget _buildTotalPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 8, 30, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Price:',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₹${order.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Customer-specific action button
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Get.to(() => const PickupCode()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A7D60),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Show Pick Up Code'),
        ),
      ),
    );
  }
}
