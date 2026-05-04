import 'package:investor_deal_managemen/core/db_constants.dart';

class InterestModel {
  final int? id;
  final int dealId;
  final String investorEmail;
  final String dealTitle;
  final String companyName;
  final String industry;
  final String investmentRequired;
  final double expectedRoi;
  final String riskLevel;
  final String status;
  final String postedByEmail;
  final String postedByName;
  final String description;
  final String createdAt;

  const InterestModel({
    this.id,
    required this.dealId,
    required this.investorEmail,
    required this.dealTitle,
    required this.companyName,
    required this.industry,
    required this.investmentRequired,
    required this.expectedRoi,
    required this.riskLevel,
    required this.status,
    required this.postedByEmail,
    required this.postedByName,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DbConstants.colInterestDealId: dealId,
      DbConstants.colInterestInvestorEmail: investorEmail,
      DbConstants.colInterestDealTitle: dealTitle,
      DbConstants.colInterestCompanyName: companyName,
      DbConstants.colInterestIndustry: industry,
      DbConstants.colInterestInvestment: investmentRequired,
      DbConstants.colInterestRoi: expectedRoi,
      DbConstants.colInterestRisk: riskLevel,
      DbConstants.colInterestStatus: status,
      DbConstants.colInterestPostedByEmail: postedByEmail,
      DbConstants.colInterestPostedByName: postedByName,
      DbConstants.colInterestDescription: description,
      DbConstants.colInterestCreatedAt: createdAt,
    };
    if (id != null) {
      map[DbConstants.colInterestId] = id;
    }
    return map;
  }

  factory InterestModel.fromMap(Map<String, dynamic> map) {
    return InterestModel(
      id: map[DbConstants.colInterestId] as int?,
      dealId: map[DbConstants.colInterestDealId] as int,
      investorEmail: map[DbConstants.colInterestInvestorEmail] as String,
      dealTitle: map[DbConstants.colInterestDealTitle] as String,
      companyName: map[DbConstants.colInterestCompanyName] as String,
      industry: map[DbConstants.colInterestIndustry] as String,
      investmentRequired: map[DbConstants.colInterestInvestment] as String,
      expectedRoi: (map[DbConstants.colInterestRoi] as num).toDouble(),
      riskLevel: map[DbConstants.colInterestRisk] as String,
      status: map[DbConstants.colInterestStatus] as String,
      postedByEmail: map[DbConstants.colInterestPostedByEmail] as String,
      postedByName: map[DbConstants.colInterestPostedByName] as String,
      description: map[DbConstants.colInterestDescription] as String,
      createdAt: map[DbConstants.colInterestCreatedAt] as String,
    );
  }
}
