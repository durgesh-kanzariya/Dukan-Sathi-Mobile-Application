
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_nav.dart';

import 'shop_productpage.dart';
import 'quick_order.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  final int maxQuantity = 99;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 80; // adaptive width

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF567751),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      Get.to(ShopProductpage());
                    },
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
                top: 100,
                left: 40,
                right: 40,
                child: Container(
                  width: cardWidth,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          "assets/imgs/image1.png",
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Chocolate Cake",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  "\$50",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("1.5 KG"),
                                Text("1 KG"),
                                Text("500 GM"),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: quantity > 1
                                            ? () {
                                                setState(() {
                                                  quantity--;
                                                });
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.remove_circle_rounded,
                                          color: quantity > 1
                                              ? null
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          "$quantity",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: quantity < maxQuantity
                                            ? () {
                                                setState(() {
                                                  quantity++;
                                                });
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.add_circle_rounded,
                                          color: quantity < maxQuantity
                                              ? null
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFACBF92),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      // pass to quick order screen if needed
                                      Get.to(() => QuickOrder());
                                    },
                                    child: const Text(
                                      "Add to quick order list",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                           Container(
                              width: 250,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    () => CardPage(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFACBF92),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),

                            // InkWell(
                            //   onTap: (){
                            //      Get.to(() => CardPage());
                            //   },
                            //   child: SizedBox(
                            //     width: double.infinity,
                            //     child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: const Color(0xFFACBF92),
                            //         foregroundColor: Colors.white,
                            //         padding: const EdgeInsets.symmetric(
                            //           vertical: 14,
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(16),
                            //         ),
                            //       ),
                            //       onPressed: () {
                            //         // Navigate to CartPage and pass data via Get.arguments
                            //         Get.to(CardPage());
                            //       },
                            //       child: Text(
                            //         "Add to Cart",
                            //         style: TextStyle(fontSize: 16),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNav(),
    );
  }
}
