import 'package:investor_deal_managemen/core/failures.dart';
import 'package:investor_deal_managemen/data/datasources/interest_local_datasource.dart';
import 'package:investor_deal_managemen/data/models/interest_model.dart';
import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';

class InterestRepositoryImpl implements InterestRepository {
  final InterestLocalDatasource datasource;

  InterestRepositoryImpl({required this.datasource});

  InterestEntity _toEntity(InterestModel m) => InterestEntity(
        id: m.id,
        dealId: m.dealId,
        investorEmail: m.investorEmail,
        dealTitle: m.dealTitle,
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

  InterestModel _toModel(InterestEntity e) => InterestModel(
        id: e.id,
        dealId: e.dealId,
        investorEmail: e.investorEmail,
        dealTitle: e.dealTitle,
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
  Future<List<InterestEntity>> getMyInterests(String investorEmail) async {
    try {
      final models = await datasource.getMyInterests(investorEmail);
      return models.map(_toEntity).toList();
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to get interests: ${e.toString()}');
    }
  }

  @override
  Future<void> expressInterest(InterestEntity interest) async {
    try {
      await datasource.expressInterest(_toModel(interest));
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to express interest: ${e.toString()}');
    }
  }

  @override
  Future<void> removeInterest(int dealId, String investorEmail) async {
    try {
      await datasource.removeInterest(dealId, investorEmail);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to remove interest: ${e.toString()}');
    }
  }

  @override
  Future<bool> isInterested(int dealId, String investorEmail) async {
    try {
      return await datasource.isInterested(dealId, investorEmail);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to check interest: ${e.toString()}');
    }
  }
}
