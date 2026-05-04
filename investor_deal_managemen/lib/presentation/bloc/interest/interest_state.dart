import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';

abstract class InterestState {}

class InterestInitial extends InterestState {}

class InterestLoading extends InterestState {}

class InterestsLoaded extends InterestState {
  final List<InterestEntity> interests;
  InterestsLoaded(this.interests);
}

class InterestChecked extends InterestState {
  final bool isInterested;
  final List<InterestEntity>? currentInterests;
  InterestChecked(this.isInterested, {this.currentInterests});
}

class InterestOperationSuccess extends InterestState {
  final String message;
  final List<InterestEntity>? currentInterests;
  InterestOperationSuccess(this.message, {this.currentInterests});
}

class InterestError extends InterestState {
  final String message;
  InterestError(this.message);
}