// import 'dart:ui';
// import 'package:dukan_sathi/shopkeeper/misc/profile_screen.dart';
// import 'package:dukan_sathi/shopkeeper/order/new_order_details_screen.dart';
// import 'package:dukan_sathi/shopkeeper/order/shopkeeper_order_details.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart'; // For formatting time

// // --- NEW IMPORTS ---
// import '../sells/monthly_sells_screen.dart';
// import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';
// import 'package:dukan_sathi/shopkeeper/order/order_model.dart'; // Use the REAL model
// import 'package:dukan_sathi/shop_service.dart';

// // --- ALL OLD STATIC DATA MODELS (Order, OrderItem, newOrders, preparingOrders) ARE DELETED ---

// class AdminDashboardScreen extends StatelessWidget {
//   const AdminDashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // --- 1. CHANGE Get.put TO Get.find ---
//     // The controller is now created by ShopkeeperMainScreen
//     final OrderController controller = Get.find<OrderController>();
//     final ShopService shopService = Get.find<ShopService>();

//     return Column(
//       children: [
//         _buildHeader(context),
//         _buildPerformanceCard(context, shopService),
//         // --- WRAP TABS IN Obx ---
//         Expanded(
//           child: Obx(
//             () => _buildOrderTabs(
//               context,
//               controller.isLoading.value,
//               controller.newOrders,
//               controller.preparingOrders,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 100),
//       decoration: const BoxDecoration(
//         color: Color(0xFF5A7D60),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'DUKAN SATHI',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               letterSpacing: 4,
//               fontFamily: "Abel",
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Get.to(() => const ProfileScreen());
//             },
//             child: const CircleAvatar(
//               radius: 22,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, color: Color(0xFF5A7D60), size: 28),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceCard(BuildContext context, ShopService shopService) {
//     // Add null check
//     if (shopService.currentShop.value == null) {
//       return Transform.translate(
//         offset: const Offset(0, -80),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Text('Shop data loading...'),
//                   SizedBox(height: 10),
//                   CircularProgressIndicator(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Transform.translate(
//       offset: const Offset(0, -80),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(40),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [
//                     const Color(0xFFFFFFFF).withOpacity(0.18),
//                     const Color(0xFFFFFFFF).withOpacity(0.8),
//                   ],
//                 ),
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.white.withOpacity(0.2),
//                 ),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Obx(
//                       () => Text(
//                         'Hi, ${shopService.currentShop.value?.shopName ?? 'Shop'}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: screenWidth * 0.06,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Text(
//                       'Last Month - \$...', // TODO: Implement analytics
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 17,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Text(
//                       'Current Month Sells',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 17,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         '\$...', // TODO: Implement analytics
//                         style: TextStyle(
//                           color: Color(0xFF5A7D60),
//                           fontSize: 36,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: 'Abel',
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Get.to(() => const MonthlySellsScreen());
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4C6A52),
//                           shape: const StadiumBorder(),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text('More', style: TextStyle(color: Colors.white)),
//                             Icon(
//                               Icons.arrow_forward,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderTabs(
//     BuildContext context,
//     bool isLoading,
//     List<Order> newOrders,
//     List<Order> preparingOrders,
//   ) {
//     return Transform.translate(
//       offset: const Offset(0, -80),
//       child: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: [
//             const TabBar(
//               labelColor: Color(0xFF5A7D60),
//               unselectedLabelColor: Colors.black45,
//               indicatorColor: Color(0xFF5A7D60),
//               indicatorSize: TabBarIndicatorSize.label,
//               tabs: [
//                 Tab(text: 'New'),
//                 Tab(text: 'Preparing'),
//               ],
//             ),
//             Expanded(
//               child: isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF5A7D60),
//                       ),
//                     )
//                   : TabBarView(
//                       children: [
//                         _buildOrderList(newOrders, context),
//                         _buildOrderList(preparingOrders, context),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Order> orders, BuildContext context) {
//     if (orders.isEmpty) {
//       return const Center(
//         child: Text(
//           "No orders in this category.",
//           style: TextStyle(color: Colors.black54),
//         ),
//       );
//     }
//     // Find the controller that's already running
//     final OrderController controller = Get.find<OrderController>();

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 95),
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         final order = orders[index];
//         return OrderCard(order: order, controller: controller);
//       },
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final Order order;
//   final OrderController controller;

//   const OrderCard({Key? key, required this.order, required this.controller})
//     : super(key: key);

//   String _formatTimeAgo(DateTime dateTime) {
//     final difference = DateTime.now().difference(dateTime);
//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} mins ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours} hours ago';
//     } else {
//       return DateFormat('dd/MM/yy').format(dateTime);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Use the new REAL status
//                 if (order.status == 'pending') {
//                   Get.to(() => NewOrderDetailsScreen(order: order));
//                 } else {
//                   Get.to(() => ShopkeeperOrderDetailsScreen(order: order));
//                 }
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "Order: ${order.id}", // Using Order ID
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                         Text(
//                           _formatTimeAgo(order.createdAt.toDate()),
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text(
//                           '${order.items.length} items - \$${order.totalPrice.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Use the new REAL status
//             if (order.status == 'pending')
//               _buildNewOrderButtons()
//             else
//               _buildPreparingOrderButton(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPreparingOrderButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           Get.to(() => ShopkeeperOrderDetailsScreen(order: order));
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF5A7D60),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//         ),
//         child: const Text('View Order Details'),
//       ),
//     );
//   }

//   Widget _buildNewOrderButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () {
//               controller.declineOrder(order.id);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade200,
//               foregroundColor: Colors.black87,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//             child: const Text('Decline'),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () {
//               controller.acceptOrder(order.id);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF5A7D60),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//             child: const Text('Accept'),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:ui';
import 'package:dukan_sathi/shopkeeper/misc/profile_screen.dart';
import 'package:dukan_sathi/shopkeeper/order/new_order_details_screen.dart';
import 'package:dukan_sathi/shopkeeper/order/shopkeeper_order_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../sells/monthly_sells_screen.dart';
import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';
import 'package:dukan_sathi/shopkeeper/order/order_model.dart';
import 'package:dukan_sathi/shop_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OrderController>() ||
        !Get.isRegistered<ShopService>()) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(226, 249, 243, 231),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF5A7D60)),
        ),
      );
    }

    final OrderController controller = Get.find<OrderController>();
    final ShopService shopService = Get.find<ShopService>();

    return Column(
      children: [
        _buildHeader(context),
        _buildPerformanceCard(context, shopService),
        Expanded(
          child: Obx(
            () => _buildOrderTabs(
              context,
              controller.isLoading.value,
              controller.newOrders,
              controller.preparingOrders,
              controller.readyOrders,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 100),
      decoration: const BoxDecoration(
        color: Color(0xFF5A7D60),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'DUKAN SATHI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 4,
              fontFamily: "Abel",
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF5A7D60), size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context, ShopService shopService) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (shopService.isLoading.value) {
        return _buildPerformanceCardLoading(context);
      }
      return _buildPerformanceCardWithData(context, shopService, screenWidth);
    });
  }

  Widget _buildPerformanceCardLoading(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Loading shop data...',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(color: Color(0xFF5A7D60)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCardWithData(
    BuildContext context,
    ShopService shopService,
    double screenWidth,
  ) {
    final OrderController orderController = Get.find<OrderController>();

    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xFFFFFFFF).withOpacity(0.18),
                    const Color(0xFFFFFFFF).withOpacity(0.8),
                  ],
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Text(
                        'Hi, ${shopService.currentShop.value?.shopName ?? 'Shop'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(() {
                      if (orderController.isCalculatingPerformance.value) {
                        return const Text(
                          'Last Month - ...',
                          style: TextStyle(fontSize: 17),
                        );
                      }
                      return Text(
                        'Last Month Profit - \$${orderController.lastMonthProfit.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          letterSpacing: 1,
                        ),
                      );
                    }),
                    const SizedBox(height: 5),
                    const Text(
                      'Current Month Profit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Obx(() {
                        if (orderController.isCalculatingPerformance.value) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFF5A7D60),
                            ),
                          );
                        }
                        return Text(
                          '\$${orderController.currentMonthProfit.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF5A7D60),
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Abel',
                          ),
                        );
                      }),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const MonthlySellsScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C6A52),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('More', style: TextStyle(color: Colors.white)),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTabs(
    BuildContext context,
    bool isLoading,
    List<Order> newOrders,
    List<Order> preparingOrders,
    List<Order> readyOrders,
  ) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFF5A7D60),
              unselectedLabelColor: Colors.black45,
              indicatorColor: Color(0xFF5A7D60),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Preparing'),
                Tab(text: 'Ready'),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5A7D60),
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildOrderList(newOrders, context, isReadyTab: false),
                        _buildOrderList(
                          preparingOrders,
                          context,
                          isReadyTab: false,
                        ),
                        _buildOrderList(
                          readyOrders,
                          context,
                          isReadyTab: true,
                        ), // Enable Ready Mode
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    List<Order> orders,
    BuildContext context, {
    required bool isReadyTab,
  }) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders in this category.",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }
    final OrderController controller = Get.find<OrderController>();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 95),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          controller: controller,
          isReadyTab: isReadyTab,
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final OrderController controller;
  final bool isReadyTab;

  const OrderCard({
    Key? key,
    required this.order,
    required this.controller,
    this.isReadyTab = false,
  }) : super(key: key);

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (order.status == 'pending') {
                  Get.to(() => NewOrderDetailsScreen(order: order));
                } else {
                  Get.to(() => ShopkeeperOrderDetailsScreen(order: order));
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Order: ${order.id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          _formatTimeAgo(order.createdAt.toDate()),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${order.items.length} items - \$${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- BUTTON LOGIC ---
            if (order.status == 'pending')
              _buildNewOrderButtons()
            else if (isReadyTab)
              _buildReadyTabButtons(context) // <--- NEW: Logic for "Ready" page
            else
              _buildPreparingOrderButton(),
          ],
        ),
      ),
    );
  }

  // --- NEW: Buttons specifically for "Ready" Tab ---
  Widget _buildReadyTabButtons(BuildContext context) {
    return Column(
      children: [
        // 1. Waiting Status Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Get.to(() => ShopkeeperOrderDetailsScreen(order: order)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[50],
              foregroundColor: Colors.blueGrey[700],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 18),
                SizedBox(width: 8),
                Text('Waiting for Customer'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 2. Cancel Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _confirmCancel(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Cancel Order'),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context) {
    Get.defaultDialog(
      title: "Cancel Order?",
      middleText: "Customer didn't show up? This will remove the order.",
      textConfirm: "Yes, Cancel",
      textCancel: "Back",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.declineOrder(order.id); // Sets status to 'cancelled'
        Get.back(); // Close dialog
      },
    );
  }

  Widget _buildPreparingOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            Get.to(() => ShopkeeperOrderDetailsScreen(order: order)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text('View & Mark Ready'),
      ),
    );
  }

  Widget _buildNewOrderButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.declineOrder(order.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Decline'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.acceptOrder(order.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A7D60),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }
}
