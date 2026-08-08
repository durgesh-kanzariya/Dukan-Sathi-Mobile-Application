import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

enum RouteDestination {
  loading,
  login,
  customerDashboard,
  shopkeeperMain,
  shopSetup,
}

/// Provider determining appropriate navigation route based on authenticated role and shop status
final roleRouterDestinationProvider = FutureProvider<RouteDestination>((ref) async {
  final authState = ref.watch(authNotifierProvider);

  if (authState.isLoading || authState.status == AuthStatus.initial) {
    return RouteDestination.loading;
  }

  if (!authState.isAuthenticated || authState.user == null) {
    return RouteDestination.login;
  }

  final user = authState.user!;

  if (user.isCustomer) {
    return RouteDestination.customerDashboard;
  }

  if (user.isShopkeeper) {
    // Check if shopkeeper has an active shop document in 'shops' collection
    try {
      final shopSnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .where('ownerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnapshot.docs.isNotEmpty) {
        return RouteDestination.shopkeeperMain;
      } else {
        return RouteDestination.shopSetup;
      }
    } catch (e) {
      return RouteDestination.shopkeeperMain;
    }
  }

  return RouteDestination.customerDashboard;
});
