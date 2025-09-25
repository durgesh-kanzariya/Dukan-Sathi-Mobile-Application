import 'dart:ffi';

import 'package:dukan_sathi/profile.dart';
import 'package:flutter/material.dart';
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

  Dashboard({super.key, required this.username, required this.password});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF567751),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
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
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        Get.to(Profile());
                      },
                      child: Icon(Icons.person),
                    ),
                  ),
                ),

                Positioned(
                  top: 80,
                  left: 40,
                  right: 40,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     blurRadius: 8,
                      //     offset: Offset(0, 10),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Kishan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Last Month - ₹50,000"),
                        SizedBox(height: 4),
                        Text("Current Month Spending"),
                        SizedBox(height: 4),
                        Text(
                          "₹1,00,00,000.00",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Positioned(
                  top: 190,
                  left: 40,
                  right: 40,
                  child: ListTile(
                    trailing: ElevatedButton(
                      onPressed: () {
                        print("hello");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF567751),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "More →",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 130), // space below stack
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Order & Status",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    color: Colors.black, // Line color
                    thickness: 1, // Line thickness
                    indent: 20, // Empty space before line
                    endIndent: 20,
                  ),
                  Text("Best Bakery :  • Ready for Pickup"),
                  Text("Raj General Store :  • Preparing"),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(History());
                    },
                    child: Text("View All in history →"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF567751),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Container(
                height: 260,
                width: 300,
                // color: Colors.green.withOpacity(0.5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment
                        .topLeft, // Corresponds to the top-left direction
                    end: Alignment
                        .bottomRight, // Corresponds to the bottom-right direction
                    colors: [
                      Color(0xFF567751), // The top, dark green color
                      Color(0xFFF9F3E7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
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

                    Center(
                      child: Card(
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

                    Center(
                      child: Card(
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

                    Center(
                      child: Card(
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
                    ListTile(
                      trailing: ElevatedButton(
                        onPressed: () {
                          Get.to(CardPage());
                        },
                        child: Text("Add To All Card →"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF567751),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 60),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }
}
