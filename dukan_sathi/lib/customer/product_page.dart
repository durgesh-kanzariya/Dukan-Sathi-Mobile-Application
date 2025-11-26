// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/bottom_nav.dart';
// import 'shop_productpage.dart';
// import 'quick_order.dart';
// import 'cart_page.dart';

// class ProductPage extends StatefulWidget {
//   const ProductPage({super.key});

//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 1;
//   final int maxQuantity = 99;

//   @override
//   Widget build(BuildContext context) {
//     final cardWidth = MediaQuery.of(context).size.width - 80; // adaptive width

//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF5A7D60),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//                 child: ListTile(
//                   leading: IconButton(
//                     onPressed: () {
//                       Get.to(ShopProductpage());
//                     },
//                     icon: const Icon(Icons.arrow_back),
//                     color: Colors.white,
//                   ),
//                   title: const Text(
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
//                 top: 100,
//                 left: 40,
//                 right: 40,
//                 child: Container(
//                   width: cardWidth,
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade100,
//                     borderRadius: BorderRadius.circular(32),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x33000000),
//                         blurRadius: 12,
//                         spreadRadius: 1,
//                         offset: Offset(0, 6),
//                       ),
//                       BoxShadow(
//                         color: Color(0x1A000000),
//                         blurRadius: 30,
//                         offset: Offset(0, 15),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                         child: Image.asset(
//                           "assets/imgs/image1.png",
//                           height: 160,
//                           fit: BoxFit.cover,
//                         ),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Text(
//                                   "Chocolate Cake",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     letterSpacing: 1,
//                                   ),
//                                 ),
//                                 Text(
//                                   "\$50",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Text("1.5 KG"),
//                                 Text("1 KG"),
//                                 Text("500 GM"),
//                               ],
//                             ),

//                             const SizedBox(height: 16),

//                             Row(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Colors.black12,
//                                         blurRadius: 4,
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       IconButton(
//                                         onPressed: quantity > 1
//                                             ? () {
//                                                 setState(() {
//                                                   quantity--;
//                                                 });
//                                               }
//                                             : null,
//                                         icon: Icon(
//                                           Icons.remove_circle_rounded,
//                                           color: quantity > 1
//                                               ? null
//                                               : Colors.grey.shade400,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8.0,
//                                         ),
//                                         child: Text(
//                                           "$quantity",
//                                           style: const TextStyle(fontSize: 16),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed: quantity < maxQuantity
//                                             ? () {
//                                                 setState(() {
//                                                   quantity++;
//                                                 });
//                                               }
//                                             : null,
//                                         icon: Icon(
//                                           Icons.add_circle_rounded,
//                                           color: quantity < maxQuantity
//                                               ? null
//                                               : Colors.grey.shade400,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),

//                                 Expanded(
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFFACBF92),
//                                       foregroundColor: Colors.black,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       // pass to quick order screen if needed
//                                       Get.to(() => QuickOrder());
//                                     },
//                                     child: const Text(
//                                       "Add to quick order list",
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 16),

//                            Container(
//                               width: 250,
//                               height: 55,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   Get.to(
//                                     () => CardPage(),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFFACBF92),
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "Add to Cart",
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ),

//                             // InkWell(
//                             //   onTap: (){
//                             //      Get.to(() => CardPage());
//                             //   },
//                             //   child: SizedBox(
//                             //     width: double.infinity,
//                             //     child: ElevatedButton(
//                             //       style: ElevatedButton.styleFrom(
//                             //         backgroundColor: const Color(0xFFACBF92),
//                             //         foregroundColor: Colors.white,
//                             //         padding: const EdgeInsets.symmetric(
//                             //           vertical: 14,
//                             //         ),
//                             //         shape: RoundedRectangleBorder(
//                             //           borderRadius: BorderRadius.circular(16),
//                             //         ),
//                             //       ),
//                             //       onPressed: () {
//                             //         // Navigate to CartPage and pass data via Get.arguments
//                             //         Get.to(CardPage());
//                             //       },
//                             //       child: Text(
//                             //         "Add to Cart",
//                             //         style: TextStyle(fontSize: 16),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),

//       bottomNavigationBar: BottomNav(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/bottom_nav.dart';
import '../controllers/cart_controller.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final String name;
  final double price; // Base price passed from previous screen
  final String imageUrl;
  final String description;
  final String shopId;
  final String shopName;
  final List<dynamic> variants;

  const ProductPage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description = '',
    required this.shopId,
    required this.shopName,
    this.variants = const [],
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  final int maxQuantity = 99;

  // State variables for dynamic updates
  String selectedVariant = "";
  double currentPrice = 0.0;

  final CartController cartController = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  @override
  void initState() {
    super.initState();
    _initializeVariantAndPrice();
  }

  void _initializeVariantAndPrice() {
    // 1. Set Initial Variant
    if (widget.variants.isNotEmpty) {
      selectedVariant = _getVariantName(widget.variants[0]);

      // FIX: Immediately grab the price from the first variant if top-level is missing
      if (widget.price == 0.0) {
        currentPrice = _getVariantPrice(widget.variants[0]);
      } else {
        currentPrice = widget.price;
      }
    } else {
      selectedVariant = "Standard";
      currentPrice = widget.price;
    }
  }

  // Helper: Extract Name from Variant Object or String
  String _getVariantName(dynamic v) {
    if (v is String) return v;
    if (v is Map) return v["variant"] ?? v["name"] ?? "";
    return "";
  }

  // Helper: Extract Price from Variant Object
  double _getVariantPrice(dynamic v) {
    if (v is Map) {
      // 1. Check for 'sellPrice' (This matches your screenshot)
      if (v.containsKey('sellPrice')) {
        var p = v['sellPrice'];
        if (p is num) return p.toDouble();
        if (p is String) return double.tryParse(p) ?? 0.0;
      }
      // 2. Fallback to 'price' just in case
      if (v.containsKey('price')) {
        var p = v['price'];
        if (p is num) return p.toDouble();
        if (p is String) return double.tryParse(p) ?? 0.0;
      }
    }
    return 0.0;
  }

  // Helper: Find price for a specific variant name
  void _updatePriceForVariant(String variantName) {
    var foundVariant = widget.variants.firstWhere(
      (v) => _getVariantName(v) == variantName,
      orElse: () => null,
    );

    if (foundVariant != null) {
      double p = _getVariantPrice(foundVariant);
      if (p > 0) {
        setState(() {
          currentPrice = p;
        });
      }
    }
  }

  Future<void> _addToQuickList() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar("Error", "Please login first");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('quickPurchaseList')
          .doc(widget.productId)
          .set({
            'productId': widget.productId,
            'productName': widget.name,
            'imageUrl': widget.imageUrl,
            'shopId': widget.shopId,
            'shopName': widget.shopName,
            'variant': selectedVariant,
            'quantity': quantity,
            'addedAt': FieldValue.serverTimestamp(),
          });

      Get.snackbar(
        "Success",
        "${widget.name} added to Quick List!",
        backgroundColor: const Color(0xFFACBF92),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F0EB),
      body: Stack(
        children: [
          // Green Header Background
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: Color(0xFF587A63),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Navbar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        "Dukan Sathi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 20),

                // Main Card
                Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.imageUrl.isNotEmpty
                            ? Image.network(
                                widget.imageUrl,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  "assets/imgs/image.png",
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                "assets/imgs/image.png",
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Name & DYNAMIC Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "₹${currentPrice.toStringAsFixed(0)}", // Display currentPrice
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF295F3A),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (widget.description.isNotEmpty)
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Variants
                      if (widget.variants.isNotEmpty) ...[
                        const Text(
                          "Variant",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: widget.variants.map((v) {
                            String vName = _getVariantName(v);
                            bool selected = vName == selectedVariant;
                            return ChoiceChip(
                              label: Text(vName),
                              selected: selected,
                              selectedColor: const Color(0xFF587A63),
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                              backgroundColor: Colors.grey.shade200,
                              onSelected: (_) {
                                setState(() {
                                  selectedVariant = vName;
                                  _updatePriceForVariant(
                                    vName,
                                  ); // Update price when clicked
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                      ],

                      // Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                _qtyButton(Icons.remove, () {
                                  if (quantity > 1) setState(() => quantity--);
                                }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "$quantity",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _qtyButton(Icons.add, () {
                                  if (quantity < maxQuantity)
                                    setState(() => quantity++);
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Buttons
                      Row(
                        children: [
                          // Quick Order
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _addToQuickList,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFACBF92),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Icon(Icons.playlist_add, size: 28),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Add to Cart
                          Expanded(
                            flex: 3,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                cartController.addToCart(
                                  CartItem(
                                    productId: widget.productId,
                                    name: widget.name,
                                    imageUrl: widget.imageUrl,
                                    price:
                                        currentPrice, // Send the correct dynamic price
                                    variant: selectedVariant,
                                    shopId: widget.shopId,
                                    shopName: widget.shopName,
                                    quantity: quantity,
                                  ),
                                );
                                Get.snackbar(
                                  "Added to Cart",
                                  "${widget.name} added successfully",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF587A63),
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 1),
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () {
                                    Get.back();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF587A63),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon, size: 22, color: Colors.black87),
      ),
    );
  }
}
