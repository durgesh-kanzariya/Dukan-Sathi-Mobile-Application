import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/failures/auth_failure.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Check initial user state asynchronously
    _checkCurrentUser();
    return AuthState.initial();
  }

  Future<void> _checkCurrentUser() async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final currentUser = await repo.getCurrentUser();
      if (currentUser != null) {
        state = AuthState.authenticated(currentUser);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> checkCurrentUser() async {
    await _checkCurrentUser();
  }

  /// Sign In with Email & Password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signInWithEmail(
        email.trim(),
        password.trim(),
      );
      state = AuthState.authenticated(user);
      return true;
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
      return false;
    } catch (e) {
      state = AuthState.error('An unexpected error occurred during sign in.');
      return false;
    }
  }

  /// Sign Up new user with role ('customer' or 'shopkeeper')
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUpWithEmail(
        name.trim(),
        email.trim(),
        password.trim(),
        role,
      );
      state = AuthState.authenticated(user);
      return true;
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
      return false;
    } catch (e) {
      state = AuthState.error('An unexpected error occurred during sign up.');
      return false;
    }
  }

  /// Sign Out current user
  Future<void> signOut() async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Failed to sign out.');
    }
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null);
    }
  }
}

/// Global Riverpod Auth Notifier Provider
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Auth State Stream Provider listening to Firebase auth changes directly
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});
