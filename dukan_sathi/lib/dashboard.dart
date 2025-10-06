import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottom_nav.dart';
import 'monthly_spending_lage.dart';
import 'product_page.dart';
import 'history.dart';
import 'cart_page.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String password;

  const Dashboard({super.key, required this.username, required this.password});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header Section =====
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF567751),
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
                    onPressed: () => Get.to(Profile()),
                    child: const Icon(Icons.person),
                  ),
                ),
              ),
              _buildPerformanceCard(context),
            ],
          ),

          SizedBox(height: 35),
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
                const Text("Best Bakery :  • Ready for Pickup"),
                const Text("Raj General Store :  • Preparing"),
                ElevatedButton(
                  onPressed: () => Get.to(History()),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF567751),
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
            padding: EdgeInsetsGeometry.fromLTRB(25, 2, 24, 0),
            child: Container(
              height: 240,
              width: 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF567751), Color(0xFFF9F3E7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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

                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Center(
                              child: Container(
                                width: 270,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Cookie - 250g",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ListTile(
                      trailing: ElevatedButton(
                        onPressed: () => Get.to(CardPage()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF567751),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Add To All Card →"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

Widget _buildPerformanceCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Transform.translate(
    offset: const Offset(0, 50),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  const Color(0xFFFFFFFF).withOpacity(0.8),
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
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: -5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hi, Durgesh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Last Month - \$50,000,000.00',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Current Month Sells',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      letterSpacing: 1,
                    ),
                  ),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$100,000,000.00',
                      style: TextStyle(
                        color: Color(0xFF5A7D60),
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Abel',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(MonthlySpendingLage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C6A52),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('More', style: TextStyle(color: Colors.white)),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
