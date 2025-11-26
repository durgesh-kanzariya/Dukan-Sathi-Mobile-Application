import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_app_bar.dart';
import 'shopkeeper_order_details.dart';
import 'order_controller.dart'; // Import controller
import 'order_model.dart'; // Import model

// --- ALL STATIC DATA MODELS & MOCK DATA ARE DELETED ---

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- FIND THE CONTROLLER ---
    final OrderController controller = Get.find<OrderController>();

    return Column(
      children: [
        const CustomAppBar(title: 'History'),
        Expanded(
          // --- WRAP IN Obx TO LISTEN FOR CHANGES ---
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.historyOrders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF5A7D60)),
              );
            }

            if (controller.historyOrders.isEmpty) {
              return const Center(
                child: Text(
                  "No completed or cancelled orders found.",
                  style: TextStyle(color: Colors.black54),
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 90),
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                itemCount: controller.historyOrders.length, // Use dynamic list
                itemBuilder: (context, index) {
                  final order = controller.historyOrders[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShopkeeperOrderDetailsScreen(order: order),
                        ),
                      );
                    },
                    child: HistoryCard(
                      order: order,
                    ), // Pass the new Order object
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class HistoryCard extends StatelessWidget {
  final Order order; // Use the REAL Order model

  const HistoryCard({Key? key, required this.order}) : super(key: key);

  Color _getStatusColor(String status) {
    if (status == 'cancelled') {
      return Colors.red.shade400;
    }
    return const Color(0xFF5F7D5D); // Green shade for other statuses
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 15,
      fontFamily: 'Abel',
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );

    final valueStyle = const TextStyle(
      fontSize: 15,
      fontFamily: 'Abel',
      fontWeight: FontWeight.w400,
      color: Color(0xFF5F7D5D),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Order Id:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(child: Text(order.id, style: valueStyle)),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.white),
                Row(
                  children: [
                    const Text("Customer id:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(child: Text(order.customerId, style: valueStyle)),
                  ],
                ),
                Row(
                  children: [
                    const Text("Order status:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        order.status.capitalizeFirst ?? order.status,
                        style: valueStyle.copyWith(
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Total price:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "\$${order.totalPrice.toStringAsFixed(2)}", // Show cents
                        style: valueStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Date:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        DateFormat('dd/MM/yy').format(order.createdAt.toDate()),
                        style: valueStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
