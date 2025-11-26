// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart'; // For formatting date
// import 'package:dukan_sathi/shopkeeper/order/order_model.dart';
// import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';

// class NewOrderDetailsScreen extends StatelessWidget {
//   final Order order; // This part was already correct
//   // Find the controller
//   final OrderController controller = Get.find<OrderController>();

//   NewOrderDetailsScreen({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFBF5),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             _buildOrderSummary(),
//             _buildItemList(),
//             _buildTotalPrice(),
//             _buildActionButtons(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
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
//                 onPressed: () {
//                   Get.back(); // Use GetX navigation
//                 },
//               ),
//               const Expanded(
//                 child: Text(
//                   'DUKAN SATHI',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     letterSpacing: 4,
//                     fontFamily: "Abel",
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 48),
//             ],
//           ),
//           const Text(
//             'New Order details',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w300,
//               fontStyle: FontStyle.normal,
//               letterSpacing: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- UPDATED TO USE NEW MODEL ---
//   Widget _buildOrderSummary() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(30, 16, 20, 0),
//       child: Column(
//         children: [
//           _buildSummaryRow('Order id:', order.id),
//           _buildSummaryRow('Customer id:', order.customerId), // Changed
//           _buildSummaryRow(
//             'Date:',
//             DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt.toDate()),
//           ),
//           _buildSummaryRow('Address:', "In-Store Pickup"), // Your app is pickup only
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String label,
//     String value, {
//     bool isAddress = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: isAddress
//             ? CrossAxisAlignment.start
//             : CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF5A7D60),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- UPDATED TO USE NEW OrderItem MODEL ---
//   Widget _buildItemList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: order.items.length,
//       itemBuilder: (context, index) {
//         final item = order.items[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   // --- IMAGE REMOVED (not in new model) ---
//                   // ClipRRect(
//                   //   borderRadius: BorderRadius.circular(10),
//                   //   child: Image.network(
//                   //     "https://placehold.co/100", // No image in OrderItem model
//                   //     width: 80,
//                   //     height: 80,
//                   //     fit: BoxFit.cover,
//                   //   ),
//                   // ),
//                   // const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.productName, // Use productName
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           item.variant,
//                           style: const TextStyle(color: Colors.black54),
//                         ),
//                         Text(
//                           '\$${item.price.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xFF5A7D60),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Text(
//                       item.quantity.toString(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTotalPrice() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           const Text(
//             'Total price: ',
//             style: TextStyle(fontSize: 18, color: Colors.black54),
//           ),
//           Text(
//             '\$${order.totalPrice.toStringAsFixed(2)}',
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- UPDATED BUTTONS TO USE CONTROLLER ---
//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 controller.declineOrder(order.id);
//                 Get.back(); // Go back after declining
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey.shade200,
//                 foregroundColor: Colors.black87,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               child: const Text('Decline'),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 controller.acceptOrder(order.id);
//                 Get.back(); // Go back after accepting
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF5A7D60),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               child: const Text('Accept Order'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dukan_sathi/shopkeeper/order/order_model.dart';
import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';

class NewOrderDetailsScreen extends StatelessWidget {
  final Order order;
  final OrderController controller = Get.find<OrderController>();

  NewOrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderSummary(),
            const Divider(indent: 20, endIndent: 20),
            _buildItemList(),
            _buildTotalPrice(),
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    fontFamily: "Abel",
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Text(
            'New Order details',
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

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 16, 20, 16),
      child: Column(
        children: [
          _buildSummaryRow('Order id:', order.id),
          _buildSummaryRow('Customer id:', order.customerId),
          _buildSummaryRow(
            'Date:',
            DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt.toDate()),
          ),
          _buildSummaryRow('Address:', "In-Store Pickup"),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isAddress = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: isAddress
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A7D60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED IMAGE LOGIC HERE ---
  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final item = order.items[index];

        // Check if URL is valid
        bool hasValidUrl =
            item.imageUrl.isNotEmpty && item.imageUrl.startsWith('http');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Dynamic Image Display
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: hasValidUrl
                          ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/imgs/image.png", // Fallback local image
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item.variant,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        Text(
                          '₹${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF5A7D60),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Total price: ',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          Text(
            '₹${order.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.declineOrder(order.id);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.acceptOrder(order.id);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A7D60),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Accept Order'),
            ),
          ),
        ],
      ),
    );
  }
}
