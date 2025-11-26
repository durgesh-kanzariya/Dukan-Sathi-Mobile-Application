import 'dart:ui';
import 'package:dukan_sathi/shopkeeper/misc/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // No longer needed here, handled in model

import 'order_details.dart';
import '/bottom_nav.dart';
import 'profile.dart';
import '../models/order_model.dart'; // Import the shared model

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

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
                  colors: [Color(0xFF5A7D60), Color(0xFFDADBCF)],
                ),
              ),
              child: uid == null
                  ? const Center(child: Text("Please login to view history"))
                  : _buildOrderList(uid),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildOrderList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('customerId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No order history found.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // Get the order document
            var orderDoc =
                snapshot.data!.docs[index]
                    as DocumentSnapshot<Map<String, dynamic>>;

            // Create initial OrderModel from Firestore data
            OrderModel order = OrderModel.fromSnapshot(orderDoc);

            // Fetch Shop Details (Address)
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(order.shopId)
                  .get(),
              builder: (context, shopSnapshot) {
                if (shopSnapshot.hasData && shopSnapshot.data!.exists) {
                  var shopData =
                      shopSnapshot.data!.data() as Map<String, dynamic>;
                  // Inject the address into the model
                  order.shopAddress = shopData['address'] ?? "Unknown Address";
                } else {
                  order.shopAddress = "Loading...";
                }

                return InkWell(
                  onTap: () {
                    Get.to(() => OrderDetails(order: order));
                  },
                  child: _HistoryCard(order: order),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
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
                  onPressed: () => Get.to(() => Profile()),
                  child: const Icon(Icons.person),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "History",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final OrderModel order; // Use OrderModel
  const _HistoryCard({required this.order});

  Color _getStatusColor(String status) {
    String s = status.toLowerCase();
    if (s == 'cancelled') return Colors.red.shade400;
    if (s == 'picked up' || s == 'completed') return const Color(0xFF5F7D5D);
    if (s == 'ready' || s == 'ready for pickup') return Colors.green;
    return Colors.orange;
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
                _buildInfoRow(
                  "Order Id:",
                  "#${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}",
                  labelStyle,
                  valueStyle,
                ),
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
                _buildInfoRow(
                  "Total Price:",
                  "₹${order.totalPrice.toStringAsFixed(0)}",
                  labelStyle,
                  valueStyle,
                ),
                _buildInfoRow(
                  "Date:",
                  order.formattedDate,
                  labelStyle,
                  valueStyle,
                ),
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
