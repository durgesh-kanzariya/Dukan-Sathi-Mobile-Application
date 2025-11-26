// import 'package:dukan_sathi/customer/discover_shop.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/bottom_nav.dart';
// import 'product_page.dart';

// class ShopProductpage extends StatefulWidget {
//   const ShopProductpage({super.key});

//   @override
//   State<ShopProductpage> createState() => _ShopProductpageState();
// }

// class _ShopProductpageState extends State<ShopProductpage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             clipBehavior: Clip.none, // allow overflow
//             children: [
//               Container(
//                 height: 180,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF5A7D60),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//                 child: ListTile(
//                   leading: IconButton(
//                     onPressed: () {
//                       Get.to(DiscoverShop());
//                     },
//                     icon: Icon(Icons.arrow_back),
//                     color: Colors.white,
//                   ),
//                   title: Text(
//                     "Dukan Sathi",
//                     style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               Positioned(
//                 top: 70,
//                 left: 40,
//                 right: 40,
//                 child: Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.white.withOpacity(0.6), // 60% opacity
//                         Colors.white.withOpacity(0.1), // 10% opacity
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: Offset(0, 20),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         title: Text(
//                           "Best Bakery",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Image.asset(
//                           "assets/imgs/hart.png",
//                           height: 20,
//                           width: 20,
//                         ),
//                       ),

//                       SizedBox(height: 8),
//                       Text("@best bakery"),
//                       SizedBox(height: 4),
//                       Text("Buiness Our : 9AM - 4PM "),
//                       SizedBox(height: 4),
//                       Text("Address : Rajkot Mavdi Chokdi "),
//                       SizedBox(height: 4),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 100),
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0),
//               child: Container(
//                 height: 350,
//                 width: 320,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color(0xFF5A7D60), // dark green
//                       Color(0xFFF9F3E7), // cream white
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5), // visible shadow
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(
//                     20,
//                   ), // optional rounded corners
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Product List",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       Padding(
//                         padding: EdgeInsetsGeometry.fromLTRB(30, 2, 30, 2),
//                         child: Divider(color: Colors.white, thickness: 2),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // this is for the cards items
//                             InkWell(
//                               onTap: () {
//                                 Get.to(ProductPage());
//                               },
//                               child: Card(
//                                 elevation: 10,
//                                 shadowColor: Colors.white.withOpacity(0.5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                         10,
//                                         0,
//                                         10,
//                                         0,
//                                       ),
//                                       child: Image.asset(
//                                         'assets/imgs/image.png',
//                                         height: 100,
//                                         width: 110,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                         10,
//                                         0,
//                                         0,
//                                         0,
//                                       ),
//                                       child: Text("Chocolate Cake"),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                         10,
//                                         0,
//                                         0,
//                                         0,
//                                       ),
//                                       child: Text("doler50"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             Card(
//                               elevation: 10,
//                               shadowColor: Colors.white,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       10,
//                                       0,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/imgs/image.png',
//                                       height: 100,
//                                       width: 110,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("Chocolate Cake"),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("doler50"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Card(
//                               elevation: 10,
//                               shadowColor: Colors.white,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       10,
//                                       0,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/imgs/image.png',
//                                       height: 100,
//                                       width: 110,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("Chocolate Cake"),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("doler50"),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             Card(
//                               elevation: 10,
//                               shadowColor: Colors.white,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       10,
//                                       0,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/imgs/image.png',
//                                       height: 100,
//                                       width: 110,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("Chocolate Cake"),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                       10,
//                                       0,
//                                       0,
//                                       0,
//                                     ),
//                                     child: Text("doler50"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 2),
//         ],
//       ),

//       bottomNavigationBar: BottomNav(),
//     );
//   }
// }

import 'package:dukan_sathi/customer/discover_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/bottom_nav.dart';
import 'product_page.dart';

class ShopProductpage extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String shopAddress;

  const ShopProductpage({
    super.key,
    required this.shopId,
    required this.shopName,
    this.shopAddress = "",
  });

  @override
  State<ShopProductpage> createState() => _ShopProductpageState();
}

class _ShopProductpageState extends State<ShopProductpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Stack (Unchanged)
          Stack(
            clipBehavior: Clip.none,
            children: [
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
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Dukan Sathi",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 40,
                right: 40,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          widget.shopName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          widget.shopAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.store,
                          color: Color(0xFF5A7D60),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 80),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text(
                      "Product List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.white, thickness: 1),
                  ),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('shops')
                          .doc(widget.shopId)
                          .collection('products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No products available",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            var data = doc.data() as Map<String, dynamic>;
                            return _buildProductCard(doc.id, data);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildProductCard(String productId, Map<String, dynamic> data) {
    String name = data['productName'] ?? 'Unknown Item';
    var variants = data['variants'] is List ? data['variants'] : [];

    double price = 0.0;

    // 1. Try to get price from the main document field
    try {
      if (data.containsKey('price')) {
        var rawPrice = data['price'];
        if (rawPrice is num) price = rawPrice.toDouble();
      }
    } catch (e) {}

    // 2. Fallback: If price is still 0, look inside variants
    if (price == 0.0 && variants.isNotEmpty) {
      for (var v in variants) {
        if (v is Map) {
          // Check for 'sellPrice' explicitly
          if (v.containsKey('sellPrice')) {
            var vPrice = v['sellPrice'];
            if (vPrice is num) {
              price = vPrice.toDouble();
              break;
            }
          }
          // Fallback check for 'price'
          if (v.containsKey('price')) {
            var vPrice = v['price'];
            if (vPrice is num) {
              price = vPrice.toDouble();
              break;
            }
          }
        }
      }
    }

    String imageUrl = data['imageUrl'] ?? '';

    return InkWell(
      onTap: () {
        Get.to(
          () => ProductPage(
            productId: productId,
            name: name,
            price: price, // This passes the correctly found 'sellPrice'
            imageUrl: imageUrl,
            description: data['description'] ?? '',
            shopId: widget.shopId,
            shopName: widget.shopName,
            variants: variants,
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "₹${price.toStringAsFixed(0)}", // Display the fixed price
                    style: const TextStyle(
                      color: Color(0xFF5A7D60),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
