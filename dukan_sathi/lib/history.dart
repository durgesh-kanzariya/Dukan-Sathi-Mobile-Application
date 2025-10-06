import 'dart:ui'; // Required for ImageFilter.blur
import 'package:dukan_sathi/admin/misc/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the OrderDetails screen and its data models
import 'order_details.dart';
import 'bottom_nav.dart';
import 'profile.dart';

// --- MOCK DATA ---
// We now use the full 'Order' model, consistent with the details page.
// This list holds all the orders that will appear in the history.
final List<Order> orderHistory = [
  // Using the same mockOrder from OrderDetails for consistency
  mockOrder,

  // A second, different order for the history list
  Order(
    id: '5432109876',
    status: 'Picked Up',
    shopName: 'Daily Needs Grocer',
    date: '18/09/2025',
    address: '123 Kalawad Road, Rajkot',
    items: [
      const OrderItem(
        imageUrl: "assets/imgs/image.png",
        name: "Milk",
        variant: "1 Litre",
        price: 60.0,
        quantity: 2,
      ),
      const OrderItem(
        imageUrl: "assets/imgs/image.png",
        name: "Bread",
        variant: "Brown Bread",
        price: 45.0,
        quantity: 1,
      ),
    ],
  ),

  // A third, cancelled order
  Order(
    id: '9876543210',
    status: 'Cancelled',
    shopName: 'Fresh Veggies',
    date: '17/09/2025',
    address: 'Amina Marg, Rajkot',
    items: [
      const OrderItem(
        imageUrl: "assets/imgs/image.png",
        name: "Tomatoes",
        variant: "500g",
        price: 40.0,
        quantity: 1,
      ),
    ],
  ),
];

// --- MAIN HISTORY SCREEN ---
class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5F7D5D), // Dark green top
                    Color(0xFFDADBCF), // Creamy white bottom
                  ],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  // Get the specific order for this list item
                  final order = orderHistory[index];
                  return InkWell(
                    onTap: () {
                      // **THIS IS THE FIX**: Pass the 'order' object to the OrderDetails screen.
                      Get.to(() => OrderDetails(order: order));
                    },
                    // Pass the full order object to the card
                    child: _HistoryCard(order: order),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  /// Your original header widget for "Dukan Sathi"
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      //... (header code remains the same)
      decoration: const BoxDecoration(
        color: Color(0xFF567751),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dukan Sathi",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    Get.to(
                      () => Profile(),
                    ); // Assuming your profile screen is ProfileScreen
                  },

                  child: const Icon(Icons.person),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "HISTORY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

// --- HISTORY CARD WIDGET ---
// Now accepts a full 'Order' object instead of 'OrderHistoryItem'
class _HistoryCard extends StatelessWidget {
  final Order order;

  const _HistoryCard({required this.order});

  Color _getStatusColor(String status) {
    if (status == 'Cancelled') {
      return Colors.red.shade400;
    }
    return const Color(0xFF5F7D5D);
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
    final valueStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFF5F7D5D),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildInfoRow("Order Id:", order.id, labelStyle, valueStyle),
                const Divider(thickness: 1, color: Colors.white),
                _buildInfoRow(
                  "Shop Name:",
                  order.shopName,
                  labelStyle,
                  valueStyle,
                ),
                _buildInfoRow(
                  "Order Status:",
                  order.status,
                  labelStyle,
                  valueStyle.copyWith(color: _getStatusColor(order.status)),
                ),
                // Use the calculated total price from the Order object
                _buildInfoRow(
                  "Total Price:",
                  "₹${order.totalPrice.toStringAsFixed(0)}",
                  labelStyle,
                  valueStyle,
                ),
                _buildInfoRow("Date:", order.date, labelStyle, valueStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    // ... (this helper widget remains the same)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Text(label, style: labelStyle),
          const SizedBox(width: 15),
          Expanded(
            child: Text(value, style: valueStyle, textAlign: TextAlign.start),
          ),
        ],
      ),
    );
  }
}
