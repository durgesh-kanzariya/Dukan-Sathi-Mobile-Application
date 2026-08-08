import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/failures/auth_failure.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String name, String email, String password, String role);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _getUserFromFirestore(firebaseUser.uid);
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return await _getUserFromFirestore(firebaseUser.uid);
  }

  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromDocument(doc).toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const UnknownAuthFailure('User sign in failed.');
      }

      UserEntity? userEntity = await _getUserFromFirestore(firebaseUser.uid);

      // Auto-recreate missing Firestore profile document if DB was wiped
      if (userEntity == null) {
        final newUserModel = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName?.isNotEmpty == true ? firebaseUser.displayName! : email.split('@').first,
          email: firebaseUser.email ?? email,
          role: 'customer',
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(firebaseUser.uid)
            .set(newUserModel.toDocument());

        userEntity = newUserModel.toEntity();
      }

      return userEntity;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const UserNotFoundFailure('No user found with this email.');
        case 'wrong-password':
        case 'invalid-credential':
          throw const InvalidEmailAndPasswordFailure('Incorrect password or credentials.');
        case 'invalid-email':
          throw const InvalidEmailAndPasswordFailure('Invalid email address format.');
        default:
          throw UnknownAuthFailure(e.message ?? 'Authentication failed.');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw UnknownAuthFailure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      UserCredential userCredential;
      try {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        // If email already exists in Auth (e.g. after Firestore wipe), attempt sign in & recreate profile
        if (e.code == 'email-already-in-use') {
          userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
        } else {
          rethrow;
        }
      }

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const UnknownAuthFailure('Failed to create account.');
      }

      await firebaseUser.updateDisplayName(name);

      final userModel = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email.trim(),
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .set(userModel.toDocument());

      return userModel.toEntity();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const EmailAlreadyInUseFailure('This email address is already registered. Please sign in with your password.');
        case 'invalid-email':
          throw const InvalidEmailAndPasswordFailure('Invalid email address format.');
        case 'weak-password':
          throw const WeakPasswordFailure('Password must be at least 6 characters.');
        default:
          throw UnknownAuthFailure(e.message ?? 'Registration failed.');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw UnknownAuthFailure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
