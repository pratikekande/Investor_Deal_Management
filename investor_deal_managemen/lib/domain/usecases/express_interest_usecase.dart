import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

class ExpressInterestUsecase {
  final InterestRepository repository;

  ExpressInterestUsecase(this.repository);

  Future<void> call(InterestEntity interest) =>
      repository.expressInterest(interest);
}
