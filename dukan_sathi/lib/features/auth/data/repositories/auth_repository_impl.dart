import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  ) async {
    return await _remoteDataSource.signUpWithEmail(name, email, password, role);
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}

// Riverpod Providers for Auth Data & Repository
final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});
