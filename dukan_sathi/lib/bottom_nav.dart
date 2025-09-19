import 'package:dukan_sathi/discover_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'monthly_spending_lage.dart';
import 'dashboard.dart';
import 'shop_productpage.dart';
import 'product_page.dart';
import 'history.dart';
import 'quick_order.dart';

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
          height: 80,
          decoration: const BoxDecoration(color: Color(0xFF5D7B6C)),
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
                      Get.to(
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
                      Get.to(DiscoverShop());
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
                      Get.to(History());
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
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.to(QuickOrder());
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
          top: -30,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF5D7B6C),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
