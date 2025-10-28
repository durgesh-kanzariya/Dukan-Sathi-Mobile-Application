import 'package:dukan_sathi/onboarding_page.dart';
import 'package:dukan_sathi/role_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
  This is the new "home" widget of your app.
  It listens to the Firebase Auth state (using Provider).
  - If the user is logged out (user == null), it shows the OnboardingPage.
  - If the user is logged in (user != null), it shows the RoleRouter.
*/
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's auth state from the provider we set up in main.dart
    final User? user = Provider.of<User?>(context);

    // if user is null (not logged in), show the OnboardingPage.
    if (user == null) {
      return OnboardingPage();
    }

    // if user IS logged in, show the RoleRouter,
    // which will check their 'role' in Firestore.
    return RoleRouter(user: user);
  }
}
