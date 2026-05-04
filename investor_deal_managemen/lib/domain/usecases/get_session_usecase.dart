import 'package:investor_deal_managemen/domain/entities/user_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';

class GetSessionUsecase {
  final AuthRepository repository;

  GetSessionUsecase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getSession();
  }
}
