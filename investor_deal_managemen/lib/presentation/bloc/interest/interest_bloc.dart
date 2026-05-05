import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/domain/usecases/deals_usecases.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_state.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  final GetMyInterestsUsecase getMyInterestsUsecase;
  final ExpressInterestUsecase expressInterestUsecase;
  final RemoveInterestUsecase removeInterestUsecase;
  final CheckInterestUsecase checkInterestUsecase;

  InterestBloc({
    required this.getMyInterestsUsecase,
    required this.expressInterestUsecase,
    required this.removeInterestUsecase,
    required this.checkInterestUsecase,
  }) : super(InterestInitial()) {
    on<LoadMyInterestsEvent>(_onLoadMyInterests);
    on<ExpressInterestEvent>(_onExpressInterest);
    on<RemoveInterestEvent>(_onRemoveInterest);
    on<CheckInterestEvent>(_onCheckInterest);
  }

  List<InterestEntity> _currentList() {
    final s = state;
    if (s is InterestsLoaded) return s.interests;
    if (s is InterestChecked) return s.currentInterests ?? [];
    if (s is InterestOperationSuccess) return s.currentInterests ?? [];
    return [];
  }

  Future<void> _onLoadMyInterests(
      LoadMyInterestsEvent event, Emitter<InterestState> emit) async {
    emit(InterestLoading());
    try {
      final list = await getMyInterestsUsecase.call(event.investorEmail);
      emit(InterestsLoaded(list));
    } on DatabaseFailure catch (e) {
      emit(InterestError(e.message));
    } catch (_) {
      emit(InterestError('Something went wrong'));
    }
  }

  Future<void> _onExpressInterest(
      ExpressInterestEvent event, Emitter<InterestState> emit) async {
    try {
      await expressInterestUsecase.call(event.interest);
      emit(InterestOperationSuccess(
        'Interest expressed!',
        currentInterests: _currentList(),
      ));
      final list =
          await getMyInterestsUsecase.call(event.interest.investorEmail);
      emit(InterestsLoaded(list));
    } on DatabaseFailure catch (e) {
      emit(InterestError(e.message));
    } catch (_) {
      emit(InterestError('Something went wrong'));
    }
  }

  Future<void> _onRemoveInterest(
      RemoveInterestEvent event, Emitter<InterestState> emit) async {
    try {
      await removeInterestUsecase.call(event.dealId, event.investorEmail);
      emit(InterestOperationSuccess(
        'Interest removed',
        currentInterests: _currentList(),
      ));
      final list = await getMyInterestsUsecase.call(event.investorEmail);
      emit(InterestsLoaded(list));
    } on DatabaseFailure catch (e) {
      emit(InterestError(e.message));
    } catch (_) {
      emit(InterestError('Something went wrong'));
    }
  }

  Future<void> _onCheckInterest(
      CheckInterestEvent event, Emitter<InterestState> emit) async {
    try {
      final result =
          await checkInterestUsecase.call(event.dealId, event.investorEmail);
      emit(InterestChecked(result, currentInterests: _currentList()));
    } on DatabaseFailure catch (e) {
      emit(InterestError(e.message));
    } catch (_) {
      emit(InterestError('Something went wrong'));
    }
  }
}