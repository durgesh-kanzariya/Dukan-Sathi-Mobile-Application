import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dukan_sathi/shopkeeper/order/order_model.dart';
import 'package:dukan_sathi/shopkeeper/order/order_controller.dart';

class ShopkeeperOrderDetailsScreen extends StatelessWidget {
  final Order order;
  final bool showActions;
  // Find the controller
  final OrderController controller = Get.find<OrderController>();

  ShopkeeperOrderDetailsScreen({
    Key? key,
    required this.order,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildOrderSummary(),
            _buildItemList(),
            _buildTotalPrice(),
            // Show "Ready for Pickup" button if status is 'preparing'
            if (showActions && order.status == 'preparing') _buildReadyButton(),
            // Show "Cancel" button if status is 'preparing'
            if (showActions && order.status == 'preparing')
              _buildCancelButton(),
            // Show pickup code if it's ready
            if (order.status == 'ready_for_pickup') _buildPickupCode(),
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
                  Get.back();
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
              const SizedBox(width: 48),
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

  // --- UPDATED TO USE NEW MODEL ---
  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 16, 20, 0),
      child: Column(
        children: [
          _buildSummaryRow('Order id:', order.id),
          _buildSummaryRow(
            'Order status:',
            order.status.capitalizeFirst ?? order.status,
          ),
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

  // --- UPDATED TO USE NEW OrderItem MODEL ---
  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final item = order.items[index];
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
            '\$${order.totalPrice.toStringAsFixed(2)}',
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

  // --- NEW WIDGET FOR PICKUP CODE ---
  Widget _buildPickupCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        children: [
          const Text(
            'Pickup Code:',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            order.pickupCode,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED BUTTONS TO USE CONTROLLER ---
  Widget _buildReadyButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            controller.markAsReady(order.id);
            Get.back(); // Go back after marking as ready
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
          child: const Text('Ready for pickup'),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            controller.declineOrder(order.id);
            Get.back(); // Go back after cancelling
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
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
          child: const Text('Cancel Order'),
        ),
      ),
    );
  }
}
