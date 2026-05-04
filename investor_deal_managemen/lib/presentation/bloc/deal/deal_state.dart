import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';

abstract class DealState {}

class DealInitial extends DealState {}

class DealLoading extends DealState {}

class DealsLoaded extends DealState {
  final List<DealEntity> allDeals;
  final List<DealEntity> filteredDeals;

  DealsLoaded({required this.allDeals, required this.filteredDeals});
}

class DealPosted extends DealState {
  final DealEntity deal;
  DealPosted(this.deal);
}

class DealOperationSuccess extends DealState {
  final String message;
  DealOperationSuccess(this.message);
}

class DealError extends DealState {
  final String message;
  DealError(this.message);
}
