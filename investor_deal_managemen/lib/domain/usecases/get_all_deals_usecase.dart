import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class GetAllDealsUsecase {
  final DealRepository repository;

  GetAllDealsUsecase(this.repository);

  Future<List<DealEntity>> call() => repository.getAllDeals();
}
