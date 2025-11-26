import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukan_sathi/bottom_nav.dart';
import 'package:dukan_sathi/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shop_productpage.dart';

class DiscoverShop extends StatefulWidget {
  const DiscoverShop({super.key});

  @override
  State<DiscoverShop> createState() => _DiscoverShopState();
}

class _DiscoverShopState extends State<DiscoverShop> {
  // Controller for search text
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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
                      Get.to(() => const Profile());
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
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
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

          // "Your favorite shops" Text - Fixed layout (was Positioned in Column)
          const Padding(
            padding: EdgeInsets.only(top: 40.0), 
            child: Center(
              child: Text(
                "Your favorite shops",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
            child: Divider(
              color: Colors.black.withOpacity(0.5),
              thickness: 2,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('shops').snapshots(),
                builder: (context, snapshot) {
                  // 1. Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF5A7D60)));
                  }
                  
                  // 2. Error or Empty State
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No shops found."));
                  }

                  // 3. Client-side Filter for Search
                  var shops = snapshot.data!.docs.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String shopName = (data['shopName'] ?? "").toString().toLowerCase();
                    return shopName.contains(_searchQuery);
                  }).toList();

                  if (shops.isEmpty) {
                     return const Center(child: Text("No shops match your search."));
                  }

                  return ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      var shopDoc = shops[index];
                      var shopData = shopDoc.data() as Map<String, dynamic>;
                      
                      String shopName = shopData['shopName'] ?? "Unknown Shop";
                      String address = shopData['address'] ?? "No Address";

                      return InkWell(
                        onTap: () {
                          // NAVIGATE to ShopProductpage with correct ID and Name
                          Get.to(() => ShopProductpage(
                            shopId: shopDoc.id,
                            shopName: shopName,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.store, color: Color(0xFF5A7D60)),
                                ),
                                title: Text(
                                  shopName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                subtitle: Text(
                                  address,
                                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }
}