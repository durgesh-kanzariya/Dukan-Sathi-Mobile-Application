import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/customer/discover_shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/bottom_nav.dart';
import 'profile.dart';
import '../controllers/quick_list_controller.dart'; // Import the new controller

class QuickOrder extends StatefulWidget {
  const QuickOrder({super.key});

  @override
  State<QuickOrder> createState() => _QuickOrderState();
}

class _QuickOrderState extends State<QuickOrder> {
  // Initialize the controller
  final QuickListController controller = Get.put(QuickListController());
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(body: Center(child: Text("Please Login First")));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A7D60),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Dukan Sathi",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () => Get.to(const Profile()),
                      child: const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Positioned(
                  top: 80,
                  left: 110,
                  child: Text(
                    "Quick Order List",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- DISCOVER BUTTON ---
            ElevatedButton(
              onPressed: () => Get.to(const DiscoverShop()),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFACBF92),
              ),
              child: const Text("Discover More Items"),
            ),

            const SizedBox(height: 20),

            // --- MAIN LIST CONTAINER ---
            Container(
              height: 400,
              width: 340,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),

                  // --- DYNAMIC LIST ---
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('quickPurchaseList')
                          .orderBy('addedAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "Your list is empty.\nAdd items from product pages.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            var data = doc.data() as Map<String, dynamic>;

                            return _buildQuickListItem(doc.id, data);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- ADD ALL TO CART BUTTON ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => controller.addAllToCart(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A7D60),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Add All to Cart →",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildQuickListItem(String docId, Map<String, dynamic> data) {
    String name = data['productName'] ?? 'Unknown';
    String variant = data['variant'] ?? '';
    int qty = data['quantity'] ?? 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 6,
        color: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Name & Variant
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (variant.isNotEmpty)
                      Text(
                        variant,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),

              // 2. Qty Controls & Delete
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Quantity Control Card
                    Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _iconBtn(Icons.remove_circle_rounded, () {
                            controller.updateQuantity(docId, qty, false);
                          }),
                          Text(
                            "$qty",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _iconBtn(Icons.add_circle_rounded, () {
                            controller.updateQuantity(docId, qty, true);
                          }),
                        ],
                      ),
                    ),

                    // Delete Button
                    IconButton(
                      onPressed: () => controller.deleteItem(docId),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black87),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
      iconSize: 22,
    );
  }
}
