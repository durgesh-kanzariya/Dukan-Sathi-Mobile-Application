import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/customer/dashboard.dart';
import 'package:dukan_sathi/shopkeeper/dashboard/shopkeeper_main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
  This widget is shown *after* a user is successfully logged in.
  Its only job is to:
  1. Get the logged-in user's ID (uid).
  2. Look up that user's document in the `users` collection in Firestore.
  3. Read the `role` field.
  4. Show the correct dashboard (Customer or Shopkeeper) based on that role.
*/
class RoleRouter extends StatelessWidget {
  final User user;
  const RoleRouter({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // We use a FutureBuilder because we are making a one-time request
    // to Firestore to get the user's role.
    return FutureBuilder<DocumentSnapshot>(
      // Get the document from Firestore using the user's UID
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // --- Handle Loading State ---
        // If we're still waiting for data, show a loading circle.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF9F3E7), // Match your app theme
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF5F7D5D)),
            ),
          );
        }

        // --- Handle Error State ---
        // If something went wrong (e.g., user deleted, network error)
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          // You could show an error page here. For now, we'll just sign
          // the user out to be safe and they will land back on the login screen.
          print("Error fetching user role: ${snapshot.error}");
          FirebaseAuth.instance.signOut();
          return const Scaffold(
            backgroundColor: Color(0xFFF9F3E7),
            body: Center(child: Text("Error loading user data. Logging out.")),
          );
        }

        // --- Handle Success State ---
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String role =
                data['role'] ?? 'customer'; // Default to 'customer' if no role

            if (role == 'shopkeeper') {
              // It's a shopkeeper! Show their dashboard.
              return const ShopkeeperMainScreen();
            } else {
              // It's a customer. Show their dashboard.
              // We pass the name from the Firestore document
              return Dashboard(
                username: data['name'] ?? 'Customer',
                password: '',
              );
            }
          } catch (e) {
            // Handle case where data is null or not a map
            print("Error reading role data: $e");
            FirebaseAuth.instance.signOut();
            return const Scaffold(
              backgroundColor: Color(0xFFF9F3E7),
              body: Center(child: Text("Invalid user data. Logging out.")),
            );
          }
        }

        // Default fallback (shouldn't be reached)
        return const Scaffold(
          backgroundColor: Color(0xFFF9F3E7),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF5F7D5D)),
          ),
        );
      },
    );
  }
}
