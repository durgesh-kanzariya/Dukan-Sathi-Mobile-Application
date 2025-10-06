import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

// --- DATA MODEL ---
class HistoricalOrder {
  final String orderId;
  final String customerName;
  final String status;
  final double totalPrice;
  final String date;

  const HistoricalOrder({
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.totalPrice,
    required this.date,
  });
}

// --- MOCK DATA ---
final List<HistoricalOrder> orderHistory = [
  const HistoricalOrder(
    orderId: '812463187642',
    customerName: 'Parvez B.',
    status: 'Ready for pickup',
    totalPrice: 100.00,
    date: '31/08/2025',
  ),
  const HistoricalOrder(
    orderId: '987654321012',
    customerName: 'Sarah M.',
    status: 'Picked Up',
    totalPrice: 76.00,
    date: '30/08/2025',
  ),
  const HistoricalOrder(
    orderId: '543210987654',
    customerName: 'John D.',
    status: 'Cancelled',
    totalPrice: 25.00,
    date: '29/08/2025',
  ),
];

// --- MAIN SCREEN ---
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(title: 'History'),
        Expanded(
          child: Container(
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
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                return HistoryCard(order: orderHistory[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// --- CARD DESIGN ---
class HistoryCard extends StatelessWidget {
  final HistoricalOrder order;

  const HistoryCard({Key? key, required this.order}) : super(key: key);

  Color _getStatusColor(String status) {
    if (status == 'Cancelled') {
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

    final valueStyle = TextStyle(
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
                // Order ID Row
                Row(
                  children: [
                    const Text("Order Id:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(child: Text(order.orderId, style: valueStyle)),
                  ],
                ),

                const Divider(thickness: 1, color: Colors.white),
                // Customer Name
                Row(
                  children: [
                    const Text("Customer name:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(order.customerName, style: valueStyle),
                    ),
                  ],
                ),

                // Order Status
                Row(
                  children: [
                    const Text("Order status:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        order.status,
                        style: valueStyle.copyWith(
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),

                // Total Price
                Row(
                  children: [
                    const Text("Total price:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "\$${order.totalPrice.toStringAsFixed(0)}",
                        style: valueStyle,
                      ),
                    ),
                  ],
                ),

                // Date
                Row(
                  children: [
                    const Text("Date:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(child: Text(order.date, style: valueStyle)),
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
