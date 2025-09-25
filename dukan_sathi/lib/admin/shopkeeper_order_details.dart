// lib/shopkeeper_order_details.dart

import 'package:flutter/material.dart';

// --- DATA MODELS ---
// In a real app, these would be in their own files.

class OrderItem {
  final String imageUrl;
  final String name;
  final String variant;
  final double price;
  final int quantity;

  OrderItem({
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
  });
}

class FullOrder {
  final String orderId;
  final String orderStatus;
  final String customerName;
  final String date;
  final String address;
  final List<OrderItem> items;

  FullOrder({
    required this.orderId,
    required this.orderStatus,
    required this.customerName,
    required this.date,
    required this.address,
    required this.items,
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
// --- END DATA MODELS ---

class ShopkeeperOrderDetailsScreen extends StatelessWidget {
  // In a real app, you would pass a specific order object to this screen.
  // For now, we use mock data.
  final FullOrder mockOrder = FullOrder(
    orderId: '812463187642',
    orderStatus: 'Preparing', // Status for this example
    customerName: 'Parvez B.',
    date: '31/08/2025',
    address: 'Mavdi chowk, nana mauva main road, Rajkot',
    items: [
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/5A7D60/FFFFFF/png?text=Cake',
        name: 'Chocolate Cake',
        variant: '1.5 KG',
        price: 50.00,
        quantity: 2,
      ),
      OrderItem(
        imageUrl: 'https://placehold.co/100x100/5A7D60/FFFFFF/png?text=Cake',
        name: 'Chocolate Cake',
        variant: '500 GM',
        price: 25.00,
        quantity: 1,
      ),
    ],
  );

  ShopkeeperOrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      // CHANGE 1: The Stack widget was removed. The body is now just the SingleChildScrollView.
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderSummary(),
            _buildItemList(),
            _buildTotalPrice(),
            _buildActionButton(),
            // Padding at the bottom for spacing, reduced from 120
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
                onPressed: () {
                  // This will take the user back to the previous screen (the dashboard)
                  Navigator.of(context).pop();
                },
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
              const SizedBox(
                width: 48,
              ), // Balances the IconButton for centering
            ],
          ),
          const Text(
            'Order details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 16, 20, 0),
      child: Column(
        children: [
          _buildSummaryRow('Order id:', mockOrder.orderId),
          _buildSummaryRow('Order status:', mockOrder.orderStatus),
          _buildSummaryRow('Customer name:', mockOrder.customerName),
          _buildSummaryRow('Date:', mockOrder.date),
          _buildSummaryRow('Address:', mockOrder.address, isAddress: true),
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

  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockOrder.items.length,
      itemBuilder: (context, index) {
        final item = mockOrder.items[index];
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
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
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF5A7D60),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            '\$${mockOrder.totalPrice.toStringAsFixed(2)}',
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

  Widget _buildActionButton() {
    // This button can be made dynamic based on the order status
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A7D60),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Set as Ready for pickup'),
        ),
      ),
    );
  }
}
