import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

class RemoveInterestUsecase {
  final InterestRepository repository;

  RemoveInterestUsecase(this.repository);

  Future<void> call(int dealId, String email) =>
      repository.removeInterest(dealId, email);
}
