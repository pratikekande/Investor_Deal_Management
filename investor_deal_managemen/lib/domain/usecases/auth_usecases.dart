import 'package:investor_deal_managemen/domain/entities/user_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';

// ── Auth Use Cases ────────────────────────────────────────────────────────────

class GetSessionUsecase {
  final AuthRepository repository;
  GetSessionUsecase(this.repository);

  Future<UserEntity?> call() => repository.getSession();
}

class SignInUsecase {
  final AuthRepository repository;
  SignInUsecase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) => repository.signIn(email: email, password: password);
}

class SignOutUsecase {
  final AuthRepository repository;
  SignOutUsecase(this.repository);

  Future<void> call() => repository.signOut();
}

class SignUpUsecase {
  final AuthRepository repository;
  SignUpUsecase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    required String role,
  }) => repository.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
}