import 'package:dukan_sathi/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_nav.dart';
import 'pickup_code.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;
  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderSummary(),
            const Divider(indent: 20, endIndent: 20),
            _buildItemList(),
            _buildTotalPrice(),
            _buildActionButton(), // <--- Logic is inside here
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  // ... (Header, Summary, and ItemList widgets remain exactly the same as previous code) ...
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
              const SizedBox(width: 48),
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

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          _buildSummaryRow('Order id:', order.id),
          _buildSummaryRow('Order status:', order.status),
          _buildSummaryRow('Shop name:', order.shopName),
          _buildSummaryRow('Date:', order.formattedDate),
          _buildSummaryRow(
            'Address:',
            order.shopAddress ?? 'Address unavailable',
            isAddress: true,
          ),
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

  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final item = order.items[index];
        bool isNetworkImage = item.imageUrl.startsWith('http');
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
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: isNetworkImage
                          ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            )
                          : Image.asset(
                              "assets/imgs/image.png",
                              fit: BoxFit.cover,
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

  // --- LOGIC CHANGE HERE ---
  Widget _buildActionButton() {
    // 1. Check if the status allows pickup
    // We check lower case to be safe against "Ready for Pickup" vs "ready for pickup"
    bool isReadyForPickup = order.status.toLowerCase().contains('ready');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          // 2. Logic: If ready, Navigate. If not, OnPressed is NULL (disables button)
          onPressed: isReadyForPickup
              ? () {
                  Get.to(() => PickupCode(code: order.pickupCode));
                }
              : null, // Setting null disables the button automatically

          style: ElevatedButton.styleFrom(
            // 3. Logic: Green if ready, Grey if disabled
            backgroundColor: isReadyForPickup
                ? const Color(0xFF5A7D60)
                : Colors.grey.shade400,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                Colors.grey.shade300, // Visual style when disabled
            disabledForegroundColor: Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 4. Logic: Change Text based on status
          child: Text(
            isReadyForPickup ? 'Show Pick Up Code' : 'Waiting for Shopkeeper',
          ),
        ),
      ),
    );
  }
}
