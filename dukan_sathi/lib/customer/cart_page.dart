// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dukan_sathi/customer/dashboard.dart'; // Assuming this is your dashboard page
// import 'package:dukan_sathi/bottom_nav.dart';

// // --- DATA MODELS (These are correct and necessary for the cart to function) ---
// class CartItem {
//   final String imageUrl;
//   final String name;
//   final String variant;
//   final double price;
//   int quantity;

//   CartItem({
//     required this.imageUrl,
//     required this.name,
//     required this.variant,
//     required this.price,
//     required this.quantity,
//   });
// }

// class ShopOrder {
//   final String shopName;
//   final String shopId;
//   final List<CartItem> items;

//   ShopOrder({
//     required this.shopName,
//     required this.shopId,
//     required this.items,
//   });

//   double get subtotal {
//     return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
//   }
// }

// class Cart {
//   final List<ShopOrder> shopOrders;

//   Cart({required this.shopOrders});

//   double get grandTotal {
//     return shopOrders.fold(0, (sum, order) => sum + order.subtotal);
//   }
// }

// // --- MAIN WIDGET ---
// class CardPage extends StatefulWidget {
//   const CardPage({super.key});

//   @override
//   State<CardPage> createState() => _CardPageState();
// }

// class _CardPageState extends State<CardPage> {
//   late Cart _cart;

//   @override
//   void initState() {
//     super.initState();
//     _cart = Cart(
//       shopOrders: [
//         ShopOrder(
//           shopName: "Best Bakery",
//           shopId: "@BestBakery123",
//           items: [
//             CartItem(
//               imageUrl: "assets/imgs/image.png",
//               name: "Chocolate Cake",
//               variant: "1.5 KG",
//               price: 50.0,
//               quantity: 1,
//             ),
//             CartItem(
//               imageUrl: "assets/imgs/image.png",
//               name: "Croissant",
//               variant: "Pack of 4",
//               price: 80.0,
//               quantity: 2,
//             ),
//           ],
//         ),
//         ShopOrder(
//           shopName: "Daily Groceries",
//           shopId: "@DailyGroceries",
//           items: [
//             CartItem(
//               imageUrl: "assets/imgs/image.png",
//               name: "Milk",
//               variant: "1 Litre",
//               price: 60.0,
//               quantity: 3,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFBF5),
//       body: Column(
//         children: [
//           _buildHeader(),
//           // Use Expanded to make the main container fill the space
//           Expanded(
//             // This is the large gradient container from your original design
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 children: [
//                   // Make the list of shop sections scrollable
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                       itemCount: _cart.shopOrders.length,
//                       itemBuilder: (context, index) {
//                         return _buildShopSection(_cart.shopOrders[index]);
//                       },
//                     ),
//                   ),
//                   // The footer content, now inside the gradient container
//                   _buildCheckoutFooter(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: const BottomNav(),
//     );
//   }

//   /// The standard responsive header
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
//       decoration: const BoxDecoration(
//         color: Color(0xFF5A7D60),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () => Get.back(),
//               ),
//               const Expanded(
//                 child: Text(
//                   'DUKAN SATHI',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     letterSpacing: 4,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 48),
//             ],
//           ),
//           const Text(
//             'My Cart',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w300,
//               letterSpacing: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds the section for a single shop's order (without an outer card)
//   Widget _buildShopSection(ShopOrder shopOrder) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Shop Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Text(
//               shopOrder.shopName,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const Divider(color: Colors.white54, indent: 8, endIndent: 8),
//           // List of items
//           ...shopOrder.items.map((item) => _buildCartItemRow(item)).toList(),
//           const Divider(color: Colors.white54, indent: 8, endIndent: 8),
//           // Shop Subtotal
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Text(
//                   'Subtotal: ',
//                   style: TextStyle(fontSize: 16, color: Colors.white70),
//                 ),
//                 Text(
//                   '₹${shopOrder.subtotal.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds the row for a single item with the semi-transparent background
//   Widget _buildCartItemRow(CartItem item) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.5),
//             Colors.white.withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             item.imageUrl,
//             width: 60,
//             height: 60,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   item.variant,
//                   style: const TextStyle(color: Colors.black54),
//                 ),
//                 Text(
//                   '₹${item.price.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     color: Color(0xFF3D533C),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildQuantityStepper(item),
//           IconButton(
//             icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
//             onPressed: () {
//               setState(() {
//                 shopOrderLoop:
//                 for (var order in _cart.shopOrders) {
//                   if (order.items.contains(item)) {
//                     order.items.remove(item);
//                     if (order.items.isEmpty) {
//                       _cart.shopOrders.remove(order);
//                     }
//                     break shopOrderLoop;
//                   }
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds the +/- quantity stepper for an item
//   Widget _buildQuantityStepper(CartItem item) {
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.remove_circle_outline, size: 22),
//           onPressed: item.quantity > 1
//               ? () => setState(() => item.quantity--)
//               : null,
//         ),
//         Text(
//           item.quantity.toString(),
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         IconButton(
//           icon: const Icon(Icons.add_circle_outline, size: 22),
//           onPressed: () => setState(() => item.quantity++),
//         ),
//       ],
//     );
//   }

//   /// Builds the footer content to be placed at the bottom of the container
//   Widget _buildCheckoutFooter() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           const Divider(color: Colors.white, thickness: 1),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Grand Total:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 '₹${_cart.grandTotal.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               // Default style for the entire text
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.black.withOpacity(0.3),
//               ),
//               children: <TextSpan>[
//                 // The "Warning:" part with its own yellow style
//                 const TextSpan(
//                   text: 'Warning: ',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 255, 59, 59),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 // The rest of the message, which will use the default style
//                 const TextSpan(
//                   text:
//                       'This will create separate orders. You must pick up and pay at each shop location.',
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 /* TODO: Place order logic */
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(
//                   0xFF5A7D60,
//                 ), // A contrasting color for the button
//                 foregroundColor: const Color(0xFFFDFBF5),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               child: const Text('Place Separate Orders'),
//             ),
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_nav.dart';
import '../controllers/cart_controller.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5A7D60), Color(0xFFF9F3E7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                }

                Map<String, List<CartItem>> groupedItems = {};
                for (var item in cartController.cartItems) {
                  if (!groupedItems.containsKey(item.shopName)) {
                    groupedItems[item.shopName] = [];
                  }
                  groupedItems[item.shopName]!.add(item);
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: groupedItems.keys.length,
                        itemBuilder: (context, index) {
                          String shopName = groupedItems.keys.elementAt(index);
                          List<CartItem> items = groupedItems[shopName]!;
                          return _buildShopSection(
                            shopName,
                            items,
                            cartController,
                          );
                        },
                      ),
                    ),
                    _buildCheckoutFooter(cartController),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  'DUKAN SATHI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Text(
            'My Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopSection(
    String shopName,
    List<CartItem> items,
    CartController controller,
  ) {
    double subtotal = items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity.value),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              shopName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white54, indent: 8, endIndent: 8),
          ...items.map((item) => _buildCartItemRow(item, controller)).toList(),
          const Divider(color: Colors.white54, indent: 8, endIndent: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Subtotal: ',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  '₹${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemRow(CartItem item, CartController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                width: 60,
                height: 60,
                child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  item.variant,
                  style: const TextStyle(color: Colors.black54),
                ),
                Text(
                  '₹${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF3D533C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildQuantityStepper(item, controller),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: () => controller.removeFromCart(item),
          ),
        ],
      ),
    );
  }

  // --- FIX: Use Controller methods for safe updates ---
  Widget _buildQuantityStepper(CartItem item, CartController controller) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 22),
          onPressed: () => controller.decreaseQuantity(item),
        ),
        Obx(
          () => Text(
            item.quantity.value.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 22),
          onPressed: () => controller.increaseQuantity(item),
        ),
      ],
    );
  }

  Widget _buildCheckoutFooter(CartController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Divider(color: Colors.white, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Obx(
                () => Text(
                  '₹${controller.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.placeOrders(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A7D60),
                foregroundColor: const Color(0xFFFDFBF5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Place Separate Orders'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
