import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'role_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);

    if (user == null) {
      return const CleanLoginScreen(key: ValueKey('clean_login_screen'));
    } else {
      return RoleRouter(key: ValueKey(user.uid), user: user);
    }
  }
}
