import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/providers/role_router_provider.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../auth_gate.dart';
import '../../features/customer/presentation/screens/customer_main_shell.dart';
import '../../features/shopkeeper/presentation/screens/shopkeeper_main_shell.dart';
import '../../features/shopkeeper/shop_mgmt/presentation/screens/shop_setup_screen.dart';

abstract class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String customerDashboard = '/customer-dashboard';
  static const String shopkeeperMain = '/shopkeeper-main';
  static const String shopSetup = '/shop-setup';
}

/// GoRouter configuration provider with Riverpod state listening
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final destinationAsync = ref.watch(roleRouterDestinationProvider);

  return GoRouter(
    initialLocation: AppRoutes.root,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggingIn = state.uri.toString() == AppRoutes.login;
      final isSigningUp = state.uri.toString() == AppRoutes.signUp;

      // Handle unauthenticated state
      if (authState.isUnauthenticated) {
        if (isLoggingIn || isSigningUp) return null;
        return AppRoutes.login;
      }

      // Handle authenticated state redirect based on role destination
      if (authState.isAuthenticated) {
        final destination = destinationAsync.asData?.value;

        if (destination == null || destination == RouteDestination.loading) {
          return null;
        }

        if (isLoggingIn || isSigningUp || state.uri.toString() == AppRoutes.root) {
          switch (destination) {
            case RouteDestination.customerDashboard:
              return AppRoutes.customerDashboard;
            case RouteDestination.shopkeeperMain:
              return AppRoutes.shopkeeperMain;
            case RouteDestination.shopSetup:
              return AppRoutes.shopSetup;
            default:
              return null;
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const CleanLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const CleanSignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerDashboard,
        builder: (context, state) => const CustomerMainShell(),
      ),
      GoRoute(
        path: AppRoutes.shopkeeperMain,
        builder: (context, state) => const ShopkeeperMainShell(),
      ),
      GoRoute(
        path: AppRoutes.shopSetup,
        builder: (context, state) => const CleanShopSetupScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
