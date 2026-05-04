import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';

abstract class InterestEvent {}

class LoadMyInterestsEvent extends InterestEvent {
  final String investorEmail;
  LoadMyInterestsEvent(this.investorEmail);
}

class ExpressInterestEvent extends InterestEvent {
  final InterestEntity interest;
  ExpressInterestEvent(this.interest);
}

class RemoveInterestEvent extends InterestEvent {
  final int dealId;
  final String investorEmail;
  RemoveInterestEvent({required this.dealId, required this.investorEmail});
}

class CheckInterestEvent extends InterestEvent {
  final int dealId;
  final String investorEmail;
  CheckInterestEvent({required this.dealId, required this.investorEmail});
}