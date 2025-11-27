// import 'dart:ui'; // For ImageFilter.blur
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../bottom_nav.dart';
// import 'monthly_spending_lage.dart';
// import 'history.dart';
// import 'cart_page.dart';
// import 'profile.dart';

// class Dashboard extends StatefulWidget {
//   final String username;
//   final String password;

//   const Dashboard({super.key, required this.username, required this.password});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ===== Header Section =====
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 180,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF5A7D60),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//                 child: ListTile(
//                   title: const Text(
//                     "Dukan Sathi",
//                     style: TextStyle(
//                       fontSize: 35,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   trailing: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.green,
//                       shape: const CircleBorder(),
//                       padding: const EdgeInsets.all(10),
//                     ),
//                     onPressed: () => Get.to(Profile()),
//                     child: const Icon(Icons.person),
//                   ),
//                 ),
//               ),
//               _buildPerformanceCard(context),
//             ],
//           ),

//           SizedBox(height: 35),
//           // ===== Order & Status Section =====
//           const Padding(
//             padding: EdgeInsets.fromLTRB(20, 0, 10, 5),
//             child: Text(
//               "Order & Status",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ),

//           Center(
//             child: Column(
//               children: [
//                 const Divider(
//                   color: Colors.black,
//                   thickness: 1,
//                   indent: 20,
//                   endIndent: 20,
//                 ),
//                 const Text("Best Bakery :  • Ready for Pickup"),
//                 const Text("Raj General Store :  • Preparing"),
//                 ElevatedButton(
//                   onPressed: () => Get.to(History()),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: const Color(0xFF5A7D60),
//                   ),
//                   child: const Text("View All in history →"),
//                 ),
//                 const Divider(
//                   color: Colors.black,
//                   thickness: 1,
//                   indent: 20,
//                   endIndent: 20,
//                 ),
//               ],
//             ),
//           ),

//           // ===== Quick Order List Section =====
//           Padding(
//             padding: EdgeInsetsGeometry.fromLTRB(25, 2, 24, 0),
//             child: Container(
//               height: 240,
//               width: 300,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                       child: Text(
//                         "QUICK ORDER LIST",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.5,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),

//                     SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           for (int i = 0; i < 3; i++)
//                             Center(
//                               child: Container(
//                                 width: 270,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Card(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(10.0),
//                                     child: Text(
//                                       "Cookie - 250g",
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     ListTile(
//                       trailing: ElevatedButton(
//                         onPressed: () => Get.to(CardPage()),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF5A7D60),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: const Text("Add To All Card →"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: const BottomNav(),
//     );
//   }
// }

// Widget _buildPerformanceCard(BuildContext context) {
//   final screenWidth = MediaQuery.of(context).size.width;

//   return Transform.translate(
//     offset: const Offset(0, 50),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(40),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   const Color(0xFFFFFFFF).withOpacity(0.18),
//                   const Color(0xFFFFFFFF).withOpacity(0.8),
//                 ],
//               ),
//               border: Border.all(
//                 width: 1,
//                 color: Colors.white.withOpacity(0.2),
//               ),
//               borderRadius: BorderRadius.circular(40),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 25,
//                   spreadRadius: 1,
//                   offset: const Offset(0, 8),
//                 ),
//                 BoxShadow(
//                   color: Colors.white.withOpacity(0.4),
//                   blurRadius: 10,
//                   spreadRadius: -5,
//                   offset: const Offset(0, -3),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Hi, Kishan',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenWidth * 0.06,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     'Last Month - \$50,000,000.00',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 17,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     'Current Month Sells',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 17,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                   const FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       '\$100,000,000.00',
//                       style: TextStyle(
//                         color: Color(0xFF5A7D60),
//                         fontSize: 36,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Abel',
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Get.to(MonthlySpendingLage());
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF4C6A52),
//                         shape: const StadiumBorder(),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('More', style: TextStyle(color: Colors.white)),
//                           Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottom_nav.dart';
import 'monthly_spending_lage.dart';
import 'history.dart';
import 'cart_page.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(body: Center(child: Text("Please Login First")));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header Section & Performance Card =====
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeaderBackground(),

                // FIX: The Positioned widget is now explicitly here, inside the Stack
                Positioned(
                  top: 130,
                  left: 0,
                  right: 0,
                  child: _buildPerformanceCard(context),
                ),
              ],
            ),

            const SizedBox(height: 100), // Spacing for the overlapping card
            // ===== Order & Status Section =====
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 5),
              child: Text(
                "Order & Status",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            Center(
              child: Column(
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),

                  _buildActiveOrdersList(),

                  ElevatedButton(
                    onPressed: () => Get.to(History()),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF5A7D60),
                    ),
                    child: const Text("View All in history →"),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),

            // ===== Quick Order List Section =====
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(25, 10, 24, 20),
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Text(
                        "QUICK ORDER LIST",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Expanded(child: _buildQuickPurchaseList()),

                    ListTile(
                      trailing: ElevatedButton(
                        onPressed: () => Get.to(CardPage()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A7D60),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Go To Cart →"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
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
            onPressed: () => Get.to(Profile()),
            child: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }

  // FIX: This now returns a Container/ClipRRect, NOT a Positioned widget
  Widget _buildPerformanceCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFFFFFFF).withOpacity(0.18),
                  const Color(0xFFFFFFFF).withOpacity(0.95),
                ],
              ),
              border: Border.all(
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text("Hi, User");
                      var userData =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      return Text(
                        'Hi, ${userData?['name'] ?? 'User'}',
                        style: TextStyle(
                          color: const Color(0xFF2E4F33),
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),

                  // Spending StreamBuilder
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('customerId', isEqualTo: uid)
                        .where('status', isEqualTo: 'completed')
                        .snapshots(),
                    builder: (context, snapshot) {
                      double currentMonthTotal = 0;
                      double lastMonthTotal = 0;

                      if (snapshot.hasData) {
                        final now = DateTime.now();
                        for (var doc in snapshot.data!.docs) {
                          var data = doc.data() as Map<String, dynamic>;
                          Timestamp? t = data['createdAt'] as Timestamp?;
                          DateTime date = t?.toDate() ?? DateTime.now();
                          double amount =
                              double.tryParse(data['totalPrice'].toString()) ??
                              0.0;

                          if (date.month == now.month &&
                              date.year == now.year) {
                            currentMonthTotal += amount;
                          } else if (date.month == now.month - 1) {
                            lastMonthTotal += amount;
                          }
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Month - ₹${lastMonthTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Current Month Spending',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '₹${currentMonthTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF5A7D60),
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Abel',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrdersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('customerId', isEqualTo: uid)
          // FIX: Added 'ready' and 'ready_for_pickup' to this list so they show up!
          .where(
            'status',
            whereIn: [
              'pending',
              'accepted',
              'preparing',
              'ready',
              'ready_for_pickup',
            ],
          )
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: LinearProgressIndicator(color: Color(0xFF5A7D60)),
          );
        }

        // If the query returns nothing, THEN show "No active orders"
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("No active orders"),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var order =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            String shopId = order['shopId'] ?? '';
            String status = order['status'] ?? 'pending';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(shopId)
                  .get(),
              builder: (context, shopSnapshot) {
                String shopName = "Shop";
                if (shopSnapshot.hasData && shopSnapshot.data!.exists) {
                  shopName = shopSnapshot.data!.get('shopName');
                }

                // --- Status Display Logic ---
                Color statusColor = Colors.orange;
                String displayStatus = "Preparing";

                if (status == 'pending') {
                  displayStatus = "Waiting for approval";
                  statusColor = Colors.grey;
                } else if (status == 'accepted') {
                  displayStatus = "Accepted";
                  statusColor = Colors.blue;
                } else if (status == 'preparing') {
                  displayStatus = "Preparing";
                  statusColor = Colors.orange;
                } else if (status == 'ready' || status == 'ready_for_pickup') {
                  // FIX: Handle the ready status specifically
                  displayStatus = "Ready for Pickup";
                  statusColor = Colors.green;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "$shopName : ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "• $displayStatus",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickPurchaseList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('quickPurchaseList')
          .snapshots(),
      builder: (context, snapshot) {
        // --- Added Error Handling to stop infinite spinner ---
        if (snapshot.hasError) {
          print("Error fetching quick list: ${snapshot.error}");
          return const Center(
            child: Text(
              "Permission Error",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "List is empty",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: snapshot.data!.docs.map((doc) {
              var item = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['productName'] ?? 'Item',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text("Qty: ${item['quantity'] ?? 1}"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
