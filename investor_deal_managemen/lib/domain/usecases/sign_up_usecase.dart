import 'package:investor_deal_managemen/domain/entities/user_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    return await repository.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}
