import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

// NOTE: The separate shopkeeper_bottom_nav.dart file is no longer needed with this approach.

// A simple data model for an order
enum OrderStatus { New, Preparing }

class Order {
  final String customerName;
  final String timeAgo;
  final int itemCount;
  final double totalPrice;
  final OrderStatus status;

  Order({
    required this.customerName,
    required this.timeAgo,
    required this.itemCount,
    required this.totalPrice,
    required this.status,
  });
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // --- Mock Data ---
  final List<Order> newOrders = [
    Order(customerName: 'Parvez B.', timeAgo: '3 mins ago', itemCount: 5, totalPrice: 75.00, status: OrderStatus.New),
    Order(customerName: 'Sarah M.', timeAgo: '7 mins ago', itemCount: 3, totalPrice: 45.50, status: OrderStatus.New),
    Order(customerName: 'John D.', timeAgo: '12 mins ago', itemCount: 8, totalPrice: 120.25, status: OrderStatus.New),
  ];

  final List<Order> preparingOrders = [
    Order(customerName: 'Parvez B.', timeAgo: '3 mins ago', itemCount: 5, totalPrice: 75.00, status: OrderStatus.Preparing),
    Order(customerName: 'Sarah M.', timeAgo: '7 mins ago', itemCount: 3, totalPrice: 45.50, status: OrderStatus.Preparing),
  ];
  // --- End Mock Data ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      // --- BODY WRAPPED IN A STACK TO ACCOMMODATE CUSTOM NAVBAR ---
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildPerformanceCard(
                  userName: "Durgesh",
                  lastMonthSales: "\$50,000,000.00",
                  currentMonthSales: "\$100,000,000.00",
                  height: 215, // Optional override
                ),

                Transform.translate(
                    offset: const Offset(0, -80),
                    child: _buildOrderTabs()
                ),
                // Add padding at the bottom to ensure content isn't hidden by the navbar
                const SizedBox(height: 100),
              ],
            ),
          ),
          // --- CUSTOM NAVBAR POSITIONED AT THE BOTTOM ---
          _buildCustomBottomNav(),
        ],
      ),
    );
  }

  // --- NEW WIDGET FOR THE CUSTOM NAVIGATION BAR ---
  Widget _buildCustomBottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF5A7D60),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(icon: Icons.list_alt, label: 'Orders'),
                _buildNavItem(icon: Icons.inventory_2_outlined, label: 'Product'),
                const SizedBox(width: 60), // Spacer for the FAB
                _buildNavItem(icon: Icons.history, label: 'History'),
                _buildNavItem(icon: Icons.store_outlined, label: 'Shop'),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: SizedBox(
              width: 76, // Default FAB size
              height: 76,
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 0,
                backgroundColor: const Color(0xFF5A7D60),
                shape: const CircleBorder(), // Ensures it's a circle
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 38, // Adjusted for better centering
                ),
              ),
            ),
          ),
          Positioned(
              top: 45,
              child: Text("Scan", style: TextStyle(color: Colors.white.withOpacity(0.8)))
          )
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }


  Widget _buildHeader() {
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
                fontFamily: "Abel"),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF5A7D60), size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String userName,
    required String lastMonthSales,
    required String currentMonthSales,
    double? height, // optional param
  }) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: height ?? 215, // ← Use a flexible default
            borderRadius: 20,
            blur: 10,
            alignment: Alignment.bottomCenter,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
              stops: const [0.1, 1],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi, $userName',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text('Last Month - $lastMonthSales',
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          letterSpacing: 1)),
                  const SizedBox(height: 8),
                  const Text('Current Month Sells',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          letterSpacing: 1)),
                  Text(
                    currentMonthSales,
                    style: const TextStyle(
                        color: Color(0xFF5A7D60), fontSize: 32),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A7D60),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('More', style: TextStyle(color: Colors.white)),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 16),
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
    );
  }


  Widget _buildOrderTabs() {
    return DefaultTabController(
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: TabBarView(
              children: [
                _buildOrderList(newOrders),
                _buildOrderList(preparingOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(
          child: Text("No orders in this category.",
              style: TextStyle(color: Colors.black54)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.customerName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text(order.timeAgo,
                    style: const TextStyle(color: Colors.black54, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                    '${order.itemCount} items - \$${order.totalPrice.toStringAsFixed(2)}',
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            if (order.status == OrderStatus.New)
              _buildNewOrderButtons()
            else
              _buildPreparingOrderButton(),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Decline'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A7D60),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }

  Widget _buildPreparingOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A7D60),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text('View Order Details'),
      ),
    );
  }
}

