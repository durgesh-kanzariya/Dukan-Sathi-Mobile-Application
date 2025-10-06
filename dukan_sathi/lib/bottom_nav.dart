import 'package:dukan_sathi/discover_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';
import 'history.dart';
import 'quick_order.dart';
import 'cart_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 65,
          decoration: const BoxDecoration(color: Color(0xFF567751)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home Icon Button
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.off(
                        Dashboard(username: "kishan", password: "1234567"),
                      );
                    },
                    icon: const Icon(Icons.home_outlined, color: Colors.white),
                    iconSize: 28,
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),

              // Shops Icon Button
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.off(DiscoverShop());
                    },
                    icon: const Icon(Icons.store_outlined, color: Colors.white),
                    iconSize: 28,
                  ),
                  const Text(
                    'Shops',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),

              // Spacer for the floating cart button
              const SizedBox(width: 60),

              // History Icon Button
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.off(History());
                    },
                    icon: const Icon(
                      Icons.history_outlined,
                      color: Colors.white,
                    ),
                    iconSize: 28,
                  ),
                  const Text(
                    'History',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),

              // Quick list Icon Button
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.off(QuickOrder());
                    },
                    icon: const Icon(
                      Icons.format_list_bulleted,
                      color: Colors.white,
                    ),
                    iconSize: 28,
                  ),
                  const Text(
                    'Quick list',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating Action Button
        Positioned(
          top: -40,
          child: InkWell(
            child: Container(
              height: 100,
              width: 80,
              decoration: BoxDecoration(
                color: Color(0xFF567751),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(300),
                  topRight: Radius.circular(300),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 2),
                  IconButton(
                    onPressed: () {
                      Get.to(CardPage());
                    },
                    icon: Icon(Icons.add, color: Colors.white, size: 50),
                  ),
                  SizedBox(height: 10),
                  Text("Cart", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
