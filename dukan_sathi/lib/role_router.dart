import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/customer/dashboard.dart';
import 'package:dukan_sathi/shopkeeper/dashboard/shopkeeper_main_screen.dart';
import 'package:dukan_sathi/Login.dart'; // Import Login for error fallback
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

class RoleRouter extends StatelessWidget {
  final User user;
  const RoleRouter({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    print("--- RoleRouter Build ---");
    print("RoleRouter: Trying to get role for user ${user.uid}");

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print(
          "RoleRouter FutureBuilder: Snapshot ConnectionState = ${snapshot.connectionState}",
        );

        // --- Handle Loading State ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("RoleRouter FutureBuilder: Waiting for Firestore data...");
          // Show loading UI while fetching data
          return const Scaffold(
            backgroundColor: Color(0xFFF9F3E7),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF5F7D5D)),
            ),
          );
        }

        // --- Handle Error or No Data State ---
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          print("RoleRouter FutureBuilder: ERROR fetching user role!");
          print(
            "   - hasError: ${snapshot.hasError}, Error: ${snapshot.error}",
          );
          print("   - hasData: ${snapshot.hasData}");
          print("   - data exists: ${snapshot.data?.exists}");

          // Use addPostFrameCallback for navigation after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FirebaseAuth.instance.signOut(); // Sign out on error
            // AuthGate will handle navigation back to Login on next rebuild
          });
          // Show an error message briefly before AuthGate takes over
          return const Scaffold(
            backgroundColor: Color(0xFFF9F3E7),
            body: Center(
              child: Text("Error loading user data. Logging out..."),
            ),
          );
        }

        // --- Handle Success State ---
        // No immediate navigation needed here, return the correct dashboard widget
        if (snapshot.connectionState == ConnectionState.done) {
          print(
            "RoleRouter FutureBuilder: ConnectionState is DONE. Determining route...",
          );
          try {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String role = data['role'] ?? 'customer'; // Default to customer
            print("RoleRouter FutureBuilder: Successfully read role = '$role'");

            if (role == 'shopkeeper') {
              print("RoleRouter FutureBuilder: Returning ShopkeeperMainScreen");
              // Directly return the widget, GetX handled the entry navigation
              return const ShopkeeperMainScreen();
            } else {
              print("RoleRouter FutureBuilder: Returning Customer Dashboard");
              // Directly return the widget, GetX handled the entry navigation
              return Dashboard(
                username: data['name'] ?? 'Customer',
                password: '',
              ); // Assuming Dashboard constructor
            }
          } catch (e) {
            print("RoleRouter FutureBuilder: Error reading role data: $e");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FirebaseAuth.instance.signOut();
              // AuthGate will handle navigation back to Login on next rebuild
            });
            return const Scaffold(
              backgroundColor: Color(0xFFF9F3E7),
              body: Center(
                child: Text("Invalid user data format. Logging out..."),
              ),
            );
          }
        }

        // Default fallback (should indicate an issue)
        print(
          "RoleRouter FutureBuilder: Reached default fallback state (unexpected)",
        );
        return const Scaffold(
          backgroundColor: Color(0xFFF9F3E7),
          body: Center(child: Text("Loading...")), // Or an error message
        );
      },
    );
  }
}
