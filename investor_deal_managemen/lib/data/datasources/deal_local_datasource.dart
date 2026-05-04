import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/database_helper.dart';
import 'package:investor_deal_managemen/data/models/deal_model.dart';

abstract class DealLocalDatasource {
  Future<List<DealModel>> getAllDeals();
  Future<List<DealModel>> getDealsByPostedByEmail(String email);
  Future<DealModel> insertDeal(DealModel deal);
  Future<void> updateDealStatus(int dealId, String status);
  Future<void> deleteDeal(int dealId);
}

class DealLocalDatasourceImpl implements DealLocalDatasource {
  final DatabaseHelper dbHelper;

  DealLocalDatasourceImpl(this.dbHelper);

  @override
  Future<List<DealModel>> getAllDeals() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return await dbHelper.getAllDeals();
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch deals: ${e.toString()}');
    }
  }

  @override
  Future<List<DealModel>> getDealsByPostedByEmail(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return await dbHelper.getDealsByPostedByEmail(email);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch deals: ${e.toString()}');
    }
  }

  @override
  Future<DealModel> insertDeal(DealModel deal) async {
    try {
      final id = await dbHelper.insertDeal(deal);
      final deals = await dbHelper.getAllDeals();
      final inserted = deals.firstWhere(
        (d) => d.id == id,
        orElse: () => deal.copyWith(id: id),
      );
      return inserted;
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to insert deal: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDealStatus(int dealId, String status) async {
    try {
      await dbHelper.updateDealStatus(dealId, status);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to update deal status: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDeal(int dealId) async {
    try {
      await dbHelper.deleteDeal(dealId);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to delete deal: ${e.toString()}');
    }
  }
}
