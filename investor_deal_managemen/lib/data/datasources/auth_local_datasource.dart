import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/database_helper.dart';
import 'package:investor_deal_managemen/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<UserModel> signUp(UserModel user);
  Future<UserModel> signIn(String email, String password);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final DatabaseHelper _dbHelper;

  AuthLocalDatasourceImpl(this._dbHelper);

  @override
  Future<UserModel> signUp(UserModel user) async {
    try {
      final existing = await _dbHelper.getUserByEmail(user.email);
      if (existing != null) {
        throw const AuthFailure('An account with this email already exists.');
      }
      final id = await _dbHelper.insertUser(user);
      return user.copyWith(id: id);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final user = await _dbHelper.getUserByEmail(email);
      if (user == null) {
        throw const AuthFailure('No account found with this email.');
      }
      if (user.password != password) {
        throw const AuthFailure('Incorrect password. Please try again.');
      }
      return user;
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Sign in failed: ${e.toString()}');
    }
  }
}