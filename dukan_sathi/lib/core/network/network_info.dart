import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction for network availability & API connection health checks.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In production, can use connectivity_plus or internet_connection_checker
    return true;
  }
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
