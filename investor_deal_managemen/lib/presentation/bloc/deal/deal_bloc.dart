import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/usecases/delete_deal_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/get_all_deals_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/get_my_deals_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/post_deal_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/update_deal_status_usecase.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_state.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final GetAllDealsUsecase getAllDealsUsecase;
  final GetMyDealsUsecase getMyDealsUsecase;
  final PostDealUsecase postDealUsecase;
  final UpdateDealStatusUsecase updateDealStatusUsecase;
  final DeleteDealUsecase deleteDealUsecase;

  List<DealEntity> _allDeals = [];
  String _searchQuery = '';
  String? _industryFilter;
  String? _riskFilter;
  String? _statusFilter;
  double _roiMin = 0;
  double _roiMax = 100;

  DealBloc({
    required this.getAllDealsUsecase,
    required this.getMyDealsUsecase,
    required this.postDealUsecase,
    required this.updateDealStatusUsecase,
    required this.deleteDealUsecase,
  }) : super(DealInitial()) {
    on<LoadAllDealsEvent>(_onLoadAllDeals);
    on<LoadMyDealsEvent>(_onLoadMyDeals);
    on<PostDealEvent>(_onPostDeal);
    on<UpdateDealStatusEvent>(_onUpdateDealStatus);
    on<DeleteDealEvent>(_onDeleteDeal);
    on<SearchDealsEvent>(_onSearchDeals);
    on<FilterDealsEvent>(_onFilterDeals);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  List<DealEntity> _applyFilters() {
    List<DealEntity> filtered = List.from(_allDeals);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((d) {
        return d.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_industryFilter != null) {
      filtered = filtered
          .where((d) =>
              d.industry.toLowerCase() == _industryFilter!.toLowerCase())
          .toList();
    }

    if (_riskFilter != null) {
      filtered = filtered
          .where(
              (d) => d.riskLevel.toLowerCase() == _riskFilter!.toLowerCase())
          .toList();
    }

    if (_statusFilter != null) {
      filtered = filtered
          .where((d) => d.status.toLowerCase() == _statusFilter!.toLowerCase())
          .toList();
    }

    filtered = filtered
        .where((d) => d.expectedRoi >= _roiMin && d.expectedRoi <= _roiMax)
        .toList();

    return filtered;
  }

  Future<void> _onLoadAllDeals(
      LoadAllDealsEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      _allDeals = await getAllDealsUsecase.call();
      emit(DealsLoaded(allDeals: _allDeals, filteredDeals: _applyFilters()));
    } on DatabaseFailure catch (e) {
      emit(DealError(e.message));
    } catch (e) {
      emit(DealError('Something went wrong'));
    }
  }

  Future<void> _onLoadMyDeals(
      LoadMyDealsEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      _allDeals = await getMyDealsUsecase.call(event.email);
      emit(DealsLoaded(allDeals: _allDeals, filteredDeals: _applyFilters()));
    } on DatabaseFailure catch (e) {
      emit(DealError(e.message));
    } catch (e) {
      emit(DealError('Something went wrong'));
    }
  }

  Future<void> _onPostDeal(
      PostDealEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      final posted = await postDealUsecase.call(event.deal);
      _allDeals = [posted, ..._allDeals];
      
      // Notify listeners of the post success
      emit(DealPosted(posted));
      
      // ✅ Update the UI immediately with the fresh list
      emit(DealsLoaded(allDeals: _allDeals, filteredDeals: _applyFilters()));
      
    } on DatabaseFailure catch (e) {
      emit(DealError(e.message));
    } catch (e) {
      emit(DealError('Something went wrong'));
    }
  }

  Future<void> _onUpdateDealStatus(
      UpdateDealStatusEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      await updateDealStatusUsecase.call(event.dealId, event.status);
      _allDeals = _allDeals.map((d) {
        if (d.id == event.dealId) {
          return d.copyWith(status: event.status);
        }
        return d;
      }).toList();
      emit(DealsLoaded(allDeals: _allDeals, filteredDeals: _applyFilters()));
    } on DatabaseFailure catch (e) {
      emit(DealError(e.message));
    } catch (e) {
      emit(DealError('Something went wrong'));
    }
  }

  Future<void> _onDeleteDeal(
      DeleteDealEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      await deleteDealUsecase.call(event.dealId);
      _allDeals.removeWhere((d) => d.id == event.dealId);
      emit(DealOperationSuccess('Deal deleted'));
      emit(DealsLoaded(allDeals: _allDeals, filteredDeals: _applyFilters()));
    } on DatabaseFailure catch (e) {
      emit(DealError(e.message));
    } catch (e) {
      emit(DealError('Something went wrong'));
    }
  }

  void _onSearchDeals(SearchDealsEvent event, Emitter<DealState> emit) {
    _searchQuery = event.query;
    if (state is DealsLoaded) {
      emit(DealsLoaded(
          allDeals: _allDeals, filteredDeals: _applyFilters()));
    }
  }

  void _onFilterDeals(FilterDealsEvent event, Emitter<DealState> emit) {
    _industryFilter = event.industry;
    _riskFilter = event.riskLevel;
    _statusFilter = event.status;
    _roiMin = event.roiMin;
    _roiMax = event.roiMax;
    if (state is DealsLoaded) {
      emit(DealsLoaded(
          allDeals: _allDeals, filteredDeals: _applyFilters()));
    }
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<DealState> emit) {
    _searchQuery = '';
    _industryFilter = null;
    _riskFilter = null;
    _statusFilter = null;
    _roiMin = 0;
    _roiMax = 100;
    if (state is DealsLoaded) {
      emit(DealsLoaded(
          allDeals: _allDeals, filteredDeals: _applyFilters()));
    }
  }
}