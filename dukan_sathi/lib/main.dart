// import 'package:dukan_sathi/auth_gate.dart';
// import 'package:dukan_sathi/shop_service.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'package:get/get.dart';

// // App Check package
// import 'package:firebase_app_check/firebase_app_check.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 1. Initialize Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // 2. Activate Firebase App Check (DEBUG MODE FOR DEVELOPMENT)
//   try {
//     await FirebaseAppCheck.instance.activate(
//       androidProvider: AndroidProvider.debug, // ✔ FIX — use debug provider
//     );
//     print("Firebase App Check activated with DEBUG provider.");
//   } catch (e) {
//     print("Error activating Firebase App Check: $e");
//   }

//   // 3. REMOVED ShopService initialization from here - let ShopkeeperMainScreen handle it

//   // 4. Run the app
//   runApp(
//     MultiProvider(
//       providers: [
//         StreamProvider<User?>(
//           create: (_) => FirebaseAuth.instance.authStateChanges(),
//           initialData: null,
//         ),
//       ],
//       child: const MainApp(),
//     ),
//   );
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF5F7D5D),
//         scaffoldBackgroundColor: const Color(0xFFF9F3E7),
//       ),
//       home: AuthGate(),
//     );
//   }
// }

import 'package:dukan_sathi/auth_gate.dart';
import 'package:dukan_sathi/shop_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// --- IMPORT YOUR CONTROLLER ---
import 'controllers/cart_controller.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Activate Firebase App Check (DEBUG MODE FOR DEVELOPMENT)
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    print("Firebase App Check activated with DEBUG provider.");
  } catch (e) {
    print("Error activating Firebase App Check: $e");
  }

  // 4. Run the app
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5F7D5D),
        scaffoldBackgroundColor: const Color(0xFFF9F3E7),
      ),

      // --- CRITICAL FIX START ---
      // This initializes the CartController globally so it lives
      // as long as the app is running.
      initialBinding: BindingsBuilder(() {
        Get.put(CartController(), permanent: true);
      }),

      // --- CRITICAL FIX END ---
      home: AuthGate(),
    );
  }
}
