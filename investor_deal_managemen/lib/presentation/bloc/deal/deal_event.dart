import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';

abstract class DealEvent {}

class LoadAllDealsEvent extends DealEvent {}

class LoadMyDealsEvent extends DealEvent {
  final String email;
  LoadMyDealsEvent(this.email);
}

class PostDealEvent extends DealEvent {
  final DealEntity deal;
  PostDealEvent(this.deal);
}

class UpdateDealStatusEvent extends DealEvent {
  final int dealId;
  final String status;
  UpdateDealStatusEvent({required this.dealId, required this.status});
}

class DeleteDealEvent extends DealEvent {
  final int dealId;
  DeleteDealEvent(this.dealId);
}

class SearchDealsEvent extends DealEvent {
  final String query;
  SearchDealsEvent(this.query);
}

class FilterDealsEvent extends DealEvent {
  final String? industry;
  final String? riskLevel;
  final String? status;
  final double roiMin;
  final double roiMax;

  FilterDealsEvent({
    this.industry,
    this.riskLevel,
    this.status,
    required this.roiMin,
    required this.roiMax,
  });
}

class ClearFiltersEvent extends DealEvent {}
