import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

class GetMyInterestsUsecase {
  final InterestRepository repository;

  GetMyInterestsUsecase(this.repository);

  Future<List<InterestEntity>> call(String email) =>
      repository.getMyInterests(email);
}
