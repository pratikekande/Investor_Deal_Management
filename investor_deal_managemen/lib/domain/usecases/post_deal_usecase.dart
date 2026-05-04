import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class PostDealUsecase {
  final DealRepository repository;

  PostDealUsecase(this.repository);

  Future<DealEntity> call(DealEntity deal) => repository.postDeal(deal);
}
