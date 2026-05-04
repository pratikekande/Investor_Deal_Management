import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

class CheckInterestUsecase {
  final InterestRepository repository;

  CheckInterestUsecase(this.repository);

  Future<bool> call(int dealId, String email) =>
      repository.isInterested(dealId, email);
}
