import '../entities/user_entity.dart';

/// Contract repository interface for Auth operations.
abstract class IAuthRepository {
  Stream<UserEntity?> authStateChanges();
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  );
  Future<void> signOut();
}
