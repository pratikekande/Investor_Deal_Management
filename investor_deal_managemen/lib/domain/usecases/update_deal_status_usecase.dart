import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class UpdateDealStatusUsecase {
  final DealRepository repository;

  UpdateDealStatusUsecase(this.repository);

  Future<void> call(int dealId, String status) =>
      repository.updateDealStatus(dealId, status);
}
