import 'package:investor_deal_managemen/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<UserEntity?> getSession();

  Future<void> signOut();
}
