import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class GetMyDealsUsecase {
  final DealRepository repository;

  GetMyDealsUsecase(this.repository);

  Future<List<DealEntity>> call(String email) =>
      repository.getDealsByPostedByEmail(email);
}
