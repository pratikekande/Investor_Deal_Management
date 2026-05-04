import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/auth_local_datasource.dart';
import 'package:investor_deal_managemen/data/datasources/shared_preferences.dart';
import 'package:investor_deal_managemen/data/models/user_model.dart';
import 'package:investor_deal_managemen/domain/entities/user_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource datasource;
  final SessionManager sessionManager;

  AuthRepositoryImpl({
    required this.datasource,
    required this.sessionManager,
  });

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userModel = await datasource.signUp(
        UserModel(name: name, email: email, password: password, role: role),
      );
      await sessionManager.saveSession(userModel);
      return UserEntity(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        role: userModel.role,
      );
    } on AuthFailure {
      rethrow;
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await datasource.signIn(email, password);
      await sessionManager.saveSession(userModel);
      return UserEntity(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        role: userModel.role,
      );
    } on AuthFailure {
      rethrow;
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<UserEntity?> getSession() async {
    try {
      final isLoggedIn = await sessionManager.isLoggedIn();
      if (!isLoggedIn) return null;
      final session = await sessionManager.getSession();
      return UserEntity(
        id: null,
        name: session['name']!,
        email: session['email']!,
        role: session['role']!,
      );
    } on AuthFailure {
      rethrow;
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await sessionManager.clearSession();
    } on AuthFailure {
      rethrow;
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }
}
