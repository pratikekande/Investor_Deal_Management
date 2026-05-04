import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/deal_local_datasource.dart';
import 'package:investor_deal_managemen/data/models/deal_model.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';

class DealRepositoryImpl implements DealRepository {
  final DealLocalDatasource datasource;

  DealRepositoryImpl({required this.datasource});

  DealEntity _toEntity(DealModel m) => DealEntity(
        id: m.id,
        title: m.title,
        companyName: m.companyName,
        industry: m.industry,
        investmentRequired: m.investmentRequired,
        expectedRoi: m.expectedRoi,
        riskLevel: m.riskLevel,
        status: m.status,
        postedByEmail: m.postedByEmail,
        postedByName: m.postedByName,
        description: m.description,
        createdAt: m.createdAt,
      );

  DealModel _toModel(DealEntity e) => DealModel(
        id: e.id,
        title: e.title,
        companyName: e.companyName,
        industry: e.industry,
        investmentRequired: e.investmentRequired,
        expectedRoi: e.expectedRoi,
        riskLevel: e.riskLevel,
        status: e.status,
        postedByEmail: e.postedByEmail,
        postedByName: e.postedByName,
        description: e.description,
        createdAt: e.createdAt,
      );

  @override
  Future<List<DealEntity>> getAllDeals() async {
    try {
      final models = await datasource.getAllDeals();
      return models.map(_toEntity).toList();
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to get all deals: ${e.toString()}');
    }
  }

  @override
  Future<List<DealEntity>> getDealsByPostedByEmail(String email) async {
    try {
      final models = await datasource.getDealsByPostedByEmail(email);
      return models.map(_toEntity).toList();
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to get deals: ${e.toString()}');
    }
  }

  @override
  Future<DealEntity> postDeal(DealEntity deal) async {
    try {
      final model = _toModel(deal.copyWith(id: null));
      final inserted = await datasource.insertDeal(model);
      return _toEntity(inserted);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to post deal: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDealStatus(int dealId, String status) async {
    try {
      await datasource.updateDealStatus(dealId, status);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to update deal status: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDeal(int dealId) async {
    try {
      await datasource.deleteDeal(dealId);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to delete deal: ${e.toString()}');
    }
  }
}
