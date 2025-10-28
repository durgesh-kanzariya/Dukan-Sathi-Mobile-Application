import 'package:dukan_sathi/Login.dart';
import 'package:dukan_sathi/role_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// GetX is no longer needed here for navigation
// import 'package:get/get.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the user state via Provider
    final User? user = Provider.of<User?>(context);
    print("--- AuthGate Build ---");
    print("AuthGate: Current User from Provider: ${user?.uid ?? 'NULL'}");

    // Directly return the appropriate widget based on the user state
    if (user == null) {
      print("AuthGate: User is NULL. Returning Login screen.");
      // If user is not logged in, show the Login screen
      // Add a unique key here too, although less critical
      return const Login(key: ValueKey('login_screen'));
    } else {
      print("AuthGate: User is LOGGED IN (${user.uid}). Returning RoleRouter.");
      // If user is logged in, show the RoleRouter to determine the dashboard
      // *** ADD A ValueKey based on the user's UID ***
      return RoleRouter(key: ValueKey(user.uid), user: user);
    }
  }
}
