import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/database_helper.dart';
import 'package:investor_deal_managemen/data/models/interest_model.dart';

abstract class InterestLocalDatasource {
  Future<List<InterestModel>> getMyInterests(String investorEmail);
  Future<void> expressInterest(InterestModel interest);
  Future<void> removeInterest(int dealId, String investorEmail);
  Future<bool> isInterested(int dealId, String investorEmail);
}

class InterestLocalDatasourceImpl implements InterestLocalDatasource {
  final DatabaseHelper dbHelper;

  InterestLocalDatasourceImpl(this.dbHelper);

  @override
  Future<List<InterestModel>> getMyInterests(String investorEmail) async {
    try {
      return await dbHelper.getInterestsByInvestorEmail(investorEmail);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch interests: ${e.toString()}');
    }
  }

  @override
  Future<void> expressInterest(InterestModel interest) async {
    try {
      await dbHelper.insertInterest(interest);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to express interest: ${e.toString()}');
    }
  }

  @override
  Future<void> removeInterest(int dealId, String investorEmail) async {
    try {
      await dbHelper.deleteInterest(dealId, investorEmail);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to remove interest: ${e.toString()}');
    }
  }

  @override
  Future<bool> isInterested(int dealId, String investorEmail) async {
    try {
      return await dbHelper.isInterested(dealId, investorEmail);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to check interest: ${e.toString()}');
    }
  }
}
