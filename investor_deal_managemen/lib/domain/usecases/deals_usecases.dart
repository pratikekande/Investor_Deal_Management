import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';
import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

// ── Deal Use Cases ────────────────────────────────────────────────────────────

class GetAllDealsUsecase {
  final DealRepository repository;
  GetAllDealsUsecase(this.repository);

  Future<List<DealEntity>> call() => repository.getAllDeals();
}

class GetMyDealsUsecase {
  final DealRepository repository;
  GetMyDealsUsecase(this.repository);

  Future<List<DealEntity>> call(String email) =>
      repository.getDealsByPostedByEmail(email);
}

class PostDealUsecase {
  final DealRepository repository;
  PostDealUsecase(this.repository);

  Future<DealEntity> call(DealEntity deal) => repository.postDeal(deal);
}

class DeleteDealUsecase {
  final DealRepository repository;
  DeleteDealUsecase(this.repository);

  Future<void> call(int dealId) => repository.deleteDeal(dealId);
}

class UpdateDealStatusUsecase {
  final DealRepository repository;
  UpdateDealStatusUsecase(this.repository);

  Future<void> call(int dealId, String status) =>
      repository.updateDealStatus(dealId, status);
}

// ── Interest Use Cases ────────────────────────────────────────────────────────

class CheckInterestUsecase {
  final InterestRepository repository;
  CheckInterestUsecase(this.repository);

  Future<bool> call(int dealId, String email) =>
      repository.isInterested(dealId, email);
}

class ExpressInterestUsecase {
  final InterestRepository repository;
  ExpressInterestUsecase(this.repository);

  Future<void> call(InterestEntity interest) =>
      repository.expressInterest(interest);
}

class RemoveInterestUsecase {
  final InterestRepository repository;
  RemoveInterestUsecase(this.repository);

  Future<void> call(int dealId, String email) =>
      repository.removeInterest(dealId, email);
}

class GetMyInterestsUsecase {
  final InterestRepository repository;
  GetMyInterestsUsecase(this.repository);

  Future<List<InterestEntity>> call(String email) =>
      repository.getMyInterests(email);
}