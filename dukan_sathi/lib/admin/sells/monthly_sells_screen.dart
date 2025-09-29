import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For number formatting

// --- DATA MODELS ---
class MonthlySell {
  final String month;
  final double amount;

  const MonthlySell({required this.month, required this.amount});
}

// --- MOCK DATA ---
final List<MonthlySell> mockSells = [
  const MonthlySell(month: 'January 25', amount: 100000000.00),
  const MonthlySell(month: 'December 24', amount: 50000000.00),
  const MonthlySell(month: 'November 24', amount: 100000000.00),
  const MonthlySell(month: 'October 24', amount: 50000000.00),
  const MonthlySell(month: 'September 24', amount: 100000000.00),
  const MonthlySell(month: 'August 24', amount: 50000000.00),
  const MonthlySell(month: 'July 24', amount: 100000000.00),
  const MonthlySell(month: 'June 24', amount: 50000000.00),
  const MonthlySell(month: 'May 24', amount: 100000000.00),
  const MonthlySell(month: 'April 24', amount: 50000000.00),
];
// --- END MOCK DATA ---

class MonthlySellsScreen extends StatelessWidget {
  const MonthlySellsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildSellsList(),
          ),
        ],
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
                onPressed: () => Navigator.of(context).pop(),
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
              const SizedBox(width: 48), // Balances the IconButton
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Monthly sells',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellsList() {
    // Using a number formatter for consistent currency display.
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: mockSells.length,
      itemBuilder: (context, index) {
        final sell = mockSells[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sell.month,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  currencyFormatter.format(sell.amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A7D60),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
