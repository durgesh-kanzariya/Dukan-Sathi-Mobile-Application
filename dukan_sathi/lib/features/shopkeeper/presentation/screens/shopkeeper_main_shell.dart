import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../shop_mgmt/presentation/screens/shop_setup_screen.dart';
import 'manage_inventory_screen.dart';
import 'shopkeeper_analytics_screen.dart';
import 'shopkeeper_dashboard_screen.dart';

class ShopkeeperTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
  }
}

/// Provider for managing active tab index in Shopkeeper Main Shell
final shopkeeperTabNotifierProvider = NotifierProvider<ShopkeeperTabNotifier, int>(ShopkeeperTabNotifier.new);

class ShopkeeperMainShell extends ConsumerStatefulWidget {
  final int initialIndex;

  const ShopkeeperMainShell({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ShopkeeperMainShell> createState() => _ShopkeeperMainShellState();
}

class _ShopkeeperMainShellState extends ConsumerState<ShopkeeperMainShell> {
  final List<Widget> _screens = [
    const CleanShopkeeperDashboardScreen(),
    const ShopkeeperAnalyticsScreen(),
    const ManageInventoryScreen(),
    const CleanShopSetupScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(shopkeeperTabNotifierProvider.notifier).setTab(widget.initialIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(shopkeeperTabNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: 'Orders',
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart_rounded,
                  label: 'Analytics',
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2_rounded,
                  label: 'Inventory',
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.storefront_outlined,
                  activeIcon: Icons.storefront_rounded,
                  label: 'Store Profile',
                  currentIndex: currentIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(shopkeeperTabNotifierProvider.notifier).setTab(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryEmerald.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primaryEmerald : AppColors.textMuted,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppColors.primaryEmerald,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
