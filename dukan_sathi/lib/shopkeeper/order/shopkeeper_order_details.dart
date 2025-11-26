import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';
import 'package:dukan_sathi/shopkeeper/order/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShopkeeperOrderDetailsScreen extends StatelessWidget {
  final Order order;
  const ShopkeeperOrderDetailsScreen({Key? key, required this.order})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E7), // Matches your app background
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: const Color(0xFF5A7D60),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- 1. Order Info Header ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF5A7D60),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id.substring(0, 8).toUpperCase()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(order.createdAt.toDate()),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                _buildStatusChip(order.status),
              ],
            ),
          ),

          // --- 2. Items List ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Product Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            image: item.imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(item.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: item.imageUrl.isEmpty
                              ? const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        const SizedBox(width: 15),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Variant: ${item.variant}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                "Qty: ${item.quantity}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Price
                        Text(
                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF5A7D60),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- 3. Bottom Section (Total + Buttons) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${order.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A7D60),
                        fontFamily: 'Abel',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildActionButtons(context, controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case 'preparing':
        bgColor = Colors.white.withOpacity(0.2);
        textColor = Colors.white;
        text = "Preparing";
        break;
      case 'ready_for_pickup':
        bgColor = Colors.white;
        textColor = const Color(0xFF5A7D60); // Green text
        text = "Ready";
        break;
      case 'completed':
        bgColor = Colors.white.withOpacity(0.2);
        textColor = Colors.white70;
        text = "Completed";
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.2);
        textColor = Colors.white;
        text = "Cancelled";
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.white;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderController controller) {
    // 1. PREPARING STATE
    if (order.status == 'preparing') {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.markAsReady(order.id);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A7D60),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Mark Ready for Pickup"),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => _confirmCancel(context, controller),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Cancel Order"),
            ),
          ),
        ],
      );
    }

    // 2. READY FOR PICKUP STATE (No Pickup Code Shown!)
    if (order.status == 'ready_for_pickup') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Waiting for customer to arrive.\nScan their QR code on Dashboard.",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _confirmCancel(context, controller),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Customer didn't show? Cancel Order"),
            ),
          ),
        ],
      );
    }

    // 3. OTHER STATES
    return const SizedBox.shrink();
  }

  void _confirmCancel(BuildContext context, OrderController controller) {
    Get.defaultDialog(
      title: "Cancel Order?",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to cancel this order?",
      textConfirm: "Yes, Cancel",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
      onConfirm: () {
        controller.declineOrder(order.id);
        Get.back(); // Close dialog
        Get.back(); // Close screen
      },
    );
  }
}
