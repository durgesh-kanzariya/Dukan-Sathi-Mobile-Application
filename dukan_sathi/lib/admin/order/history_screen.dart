import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'shopkeeper_order_details.dart';
import '../dashboard/dashboard_page.dart';

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
                final historicalOrder = orderHistory[index];
                return InkWell(
                  onTap: () {
                    final detailedOrder = Order(
                      orderId: historicalOrder.orderId,
                      customerName: historicalOrder.customerName,
                      timeAgo: 'from history',
                      status: OrderStatus.Preparing,
                      date: historicalOrder.date,
                      address: '123 Dukan Sathi Lane, Rajkot',
                      items: const [
                        OrderItem(
                          imageUrl:
                              'https://placehold.co/100x100/AF8F6D/FFFFFF/png?text=Item',
                          name: 'Placeholder Item 1',
                          variant: 'Variant A',
                          price: 50.00,
                          quantity: 2,
                        ),
                      ],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // UPDATED: Pass 'showActions: false' to hide the buttons.
                        builder: (context) => ShopkeeperOrderDetailsScreen(
                          order: detailedOrder,
                          showActions: false,
                        ),
                      ),
                    );
                  },
                  child: HistoryCard(order: historicalOrder),
                );
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
                    Expanded(child: Text(order.orderId, style: valueStyle)),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.white),
                Row(
                  children: [
                    const Text("Customer name:", style: labelStyle),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(order.customerName, style: valueStyle),
                    ),
                  ],
                ),
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
