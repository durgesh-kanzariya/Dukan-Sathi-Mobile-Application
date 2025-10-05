import 'dart:ui';

import 'package:dukan_sathi/admin/misc/profile_screen.dart';
import 'package:dukan_sathi/admin/order/new_order_details_screen.dart';
import 'package:dukan_sathi/admin/order/shopkeeper_order_details.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../sells/monthly_sells_screen.dart';

// --- DATA MODELS ---
enum OrderStatus { New, Preparing }

class OrderItem {
  final String imageUrl;
  final String name;
  final String variant;
  final double price;
  final int quantity;

  const OrderItem({
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
  });
}

class Order {
  final String orderId;
  final String customerName;
  final String timeAgo;
  final OrderStatus status;
  final String date;
  final String address;
  final List<OrderItem> items;

  const Order({
    required this.orderId,
    required this.customerName,
    required this.timeAgo,
    required this.status,
    required this.date,
    required this.address,
    required this.items,
  });

  // Helper properties
  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get itemCount => items.length;
}

// --- MOCK DATA ---
final List<Order> newOrders = const [
  Order(
    orderId: '9876543210',
    customerName: 'Parvez B.',
    timeAgo: '3 mins ago',
    status: OrderStatus.New,
    date: '26/09/2025',
    address: '123 Crystal Mall, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/AF8F6D/FFFFFF/png?text=Bread',
        name: 'Wheat Bread',
        variant: 'Loaf',
        price: 10.00,
        quantity: 2,
      ),
      OrderItem(
        imageUrl:
            'https://placehold.co/100x100/D2B48C/FFFFFF/png?text=Croissant',
        name: 'Croissant',
        variant: 'Single',
        price: 6.00,
        quantity: 3,
      ),
    ],
  ),
  Order(
    orderId: '9876543210',
    customerName: 'Parvez B.',
    timeAgo: '3 mins ago',
    status: OrderStatus.New,
    date: '26/09/2025',
    address: '123 Crystal Mall, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/AF8F6D/FFFFFF/png?text=Bread',
        name: 'Wheat Bread',
        variant: 'Loaf',
        price: 10.00,
        quantity: 2,
      ),
      OrderItem(
        imageUrl:
            'https://placehold.co/100x100/D2B48C/FFFFFF/png?text=Croissant',
        name: 'Croissant',
        variant: 'Single',
        price: 6.00,
        quantity: 3,
      ),
    ],
  ),
  Order(
    orderId: '9876543210',
    customerName: 'Parvez B.',
    timeAgo: '3 mins ago',
    status: OrderStatus.New,
    date: '26/09/2025',
    address: '123 Crystal Mall, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/AF8F6D/FFFFFF/png?text=Bread',
        name: 'Wheat Bread',
        variant: 'Loaf',
        price: 10.00,
        quantity: 2,
      ),
      OrderItem(
        imageUrl:
            'https://placehold.co/100x100/D2B48C/FFFFFF/png?text=Croissant',
        name: 'Croissant',
        variant: 'Single',
        price: 6.00,
        quantity: 3,
      ),
    ],
  ),
  Order(
    orderId: '5432109876',
    customerName: 'Sarah M.',
    timeAgo: '7 mins ago',
    status: OrderStatus.New,
    date: '26/09/2025',
    address: '456 Kalawad Road, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/9B1C31/FFFFFF/png?text=Cupcake',
        name: 'Red Velvet Cupcake',
        variant: 'Box of 4',
        price: 25.00,
        quantity: 1,
      ),
    ],
  ),
];

final List<Order> preparingOrders = const [
  Order(
    orderId: '812463187642',
    customerName: 'John D.',
    timeAgo: '12 mins ago',
    status: OrderStatus.Preparing,
    date: '26/09/2025',
    address: '789 University Road, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/5A3825/FFFFFF/png?text=Cake',
        name: 'Chocolate Cake',
        variant: '1.5 KG',
        price: 75.00,
        quantity: 1,
      ),
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/6F4E37/FFFFFF/png?text=Pastry',
        name: 'Chocolate Pastry',
        variant: 'Single',
        price: 3.00,
        quantity: 5,
      ),
    ],
  ),
];
// --- END MOCK DATA & MODELS ---

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context), // Pass context to the header
        _buildPerformanceCard(context),
        Expanded(child: _buildOrderTabs(context)),
      ],
    );
  }

  // 2. The header now accepts a BuildContext to handle navigation.
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
          // 3. The icon is now a tappable CircleAvatar that navigates to the ProfileScreen.
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
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

  Widget _buildPerformanceCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // --- REPLACEMENT FOR GlassmorphicContainer ---
        // This combination of widgets creates the same effect but with a dynamic height.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              // The container handles the background gradient and border.
              // Since no height is specified, it will grow to fit the Column inside.
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
                  mainAxisSize: MainAxisSize
                      .min, // This is key! It tells the Column to be only as tall as its children.
                  children: [
                    Text(
                      'Hi, Durgesh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Last Month - \$50,000,000.00',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Current Month Sells',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$100,000,000.00',
                        style: TextStyle(
                          color: Color(0xFF5A7D60),
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Abel',
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MonthlySellsScreen(),
                            ),
                          );
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

  Widget _buildOrderTabs(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: DefaultTabController(
        length: 2,
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
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(newOrders),
                  _buildOrderList(preparingOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders in this category.",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 95),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

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
                if (order.status == OrderStatus.New) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewOrderDetailsScreen(order: order),
                    ),
                  );
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          order.timeAgo,
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
                          '${order.itemCount} items - \$${order.totalPrice.toStringAsFixed(2)}',
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
            if (order.status == OrderStatus.New)
              _buildNewOrderButtons()
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShopkeeperOrderDetailsScreen(order: order),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A7D60),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Order Details'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewOrderButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Add logic to decline the order
            },
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
            onPressed: () {
              // TODO: Add logic to accept the order
            },
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
