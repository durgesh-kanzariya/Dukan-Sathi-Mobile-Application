import 'package:dukan_sathi/bottom_nav.dart';
import 'package:dukan_sathi/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'shop_productpage.dart';

class DiscoverShop extends StatefulWidget {
  const DiscoverShop({super.key});

  @override
  State<DiscoverShop> createState() => _DiscoverShopState();
}

class _DiscoverShopState extends State<DiscoverShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, // allow overflow
            children: [
              // Top green container
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF5A7D60),
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
                    onPressed: () {
                      Get.to(Profile());
                    },
                    child: const Icon(Icons.person),
                  ),
                ),
              ),

              // Search box aligned at bottom center
              Positioned(
                left: 20,
                right: 20,
                top: 100, // pull it down below the container
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for shop',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Positioned(
            top: 180,
            left: 90,
            child: Center(
              child: Text(
                "Your favorite shops",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),

          Positioned(
            top: 240, // just below the text
            left: 80,
            right: 80,
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(30, 1, 30, 0),
              child: Divider(
                color: Colors.black.withOpacity(0.5),
                thickness: 2,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ShopProductpage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: const ListTile(
                              leading: Icon(Icons.person_2_rounded),
                              title: Text('Bakry Shop'),
                              subtitle: Text('Best Bakry'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
