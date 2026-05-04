import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class DeleteDealUsecase {
  final DealRepository repository;

  DeleteDealUsecase(this.repository);

  Future<void> call(int dealId) => repository.deleteDeal(dealId);
}
