import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';

abstract class DealRepository {
  Future<List<DealEntity>> getAllDeals();
  Future<List<DealEntity>> getDealsByPostedByEmail(String email);
  Future<DealEntity> postDeal(DealEntity deal);
  Future<void> updateDealStatus(int dealId, String status);
  Future<void> deleteDeal(int dealId);
}
