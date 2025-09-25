import 'package:dukan_sathi/admin/shopkeeper_order_details.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'monthly_sells_screen.dart';

// Data models (can be moved to their own file later)
enum OrderStatus { New, Preparing }

class Order {
  final String customerName;
  final String timeAgo;
  final int itemCount;
  final double totalPrice;
  final OrderStatus status;

  const Order({
    // Added const to the constructor
    required this.customerName,
    required this.timeAgo,
    required this.itemCount,
    required this.totalPrice,
    required this.status,
  });
}

// --- MOCK DATA MOVED OUTSIDE THE CLASS TO FIX THE ERROR ---
final List<Order> newOrders = const [
  Order(
    customerName: 'Parvez B.',
    timeAgo: '3 mins ago',
    itemCount: 5,
    totalPrice: 75.00,
    status: OrderStatus.New,
  ),
  Order(
    customerName: 'Sarah M.',
    timeAgo: '7 mins ago',
    itemCount: 3,
    totalPrice: 45.50,
    status: OrderStatus.New,
  ),
  Order(
    customerName: 'Jenil M.',
    timeAgo: '7 mins ago',
    itemCount: 3,
    totalPrice: 45.50,
    status: OrderStatus.New,
  ),
];

final List<Order> preparingOrders = const [
  Order(
    customerName: 'John D.',
    timeAgo: '12 mins ago',
    itemCount: 8,
    totalPrice: 120.25,
    status: OrderStatus.Preparing,
  ),
];
// --- END MOCK DATA ---

// THIS WIDGET IS NOW JUST THE CONTENT FOR THE DASHBOARD
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CHANGE 1: The layout is now a Column to create a fixed header area.
    // The SingleChildScrollView has been removed from the top level.
    return Column(
      children: [
        _buildHeader(),
        _buildPerformanceCard(context),
        // CHANGE 2: The order tabs are wrapped in an Expanded widget.
        // This makes the tab section fill the remaining vertical space,
        // and its content (the list) will be scrollable.
        Expanded(child: _buildOrderTabs(context)),
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
              fontFamily: "Abel",
            ),
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

  Widget _buildPerformanceCard(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 241,
          borderRadius: 40,
          blur: 15,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFFFFF).withOpacity(0.3),
              const Color(0xFFFFFFFF).withOpacity(0.5),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi, Durgesh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Last Month - \$50,000,000.00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Current Month Sells',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    letterSpacing: 1,
                  ),
                ),
                const Text(
                  '\$100,000,000.00',
                  style: TextStyle(
                    color: Color(0xFF5A7D60),
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Abel',
                  ),
                ),
                const Spacer(),
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
            // CHANGE 3: The TabBarView is wrapped in Expanded so it knows
            // to fill the available space provided by its parent.
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
      // CHANGE 4: Padding is added to the bottom of the list to ensure
      // the last item can be scrolled above the navigation bar.
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  order.timeAgo,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${order.itemCount} items - \$${order.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
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
                        builder: (context) => ShopkeeperOrderDetailsScreen(),
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
            onPressed: () {},
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
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
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
