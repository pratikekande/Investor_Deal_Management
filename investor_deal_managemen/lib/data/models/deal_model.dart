import 'package:investor_deal_managemen/core/db_constants.dart';

class DealModel {
  final int? id;
  final String title;
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

  const DealModel({
    this.id,
    required this.title,
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
      DbConstants.colDealTitle: title,
      DbConstants.colCompanyName: companyName,
      DbConstants.colIndustry: industry,
      DbConstants.colInvestmentRequired: investmentRequired,
      DbConstants.colExpectedRoi: expectedRoi,
      DbConstants.colRiskLevel: riskLevel,
      DbConstants.colStatus: status,
      DbConstants.colPostedByEmail: postedByEmail,
      DbConstants.colPostedByName: postedByName,
      DbConstants.colDescription: description,
      DbConstants.colCreatedAt: createdAt,
    };
    if (id != null) {
      map[DbConstants.colDealId] = id;
    }
    return map;
  }

  factory DealModel.fromMap(Map<String, dynamic> map) {
    return DealModel(
      id: map[DbConstants.colDealId] as int?,
      title: map[DbConstants.colDealTitle] as String,
      companyName: map[DbConstants.colCompanyName] as String,
      industry: map[DbConstants.colIndustry] as String,
      investmentRequired: map[DbConstants.colInvestmentRequired] as String,
      expectedRoi: (map[DbConstants.colExpectedRoi] as num).toDouble(),
      riskLevel: map[DbConstants.colRiskLevel] as String,
      status: map[DbConstants.colStatus] as String,
      postedByEmail: map[DbConstants.colPostedByEmail] as String,
      postedByName: map[DbConstants.colPostedByName] as String,
      description: map[DbConstants.colDescription] as String,
      createdAt: map[DbConstants.colCreatedAt] as String,
    );
  }

  DealModel copyWith({
    int? id,
    String? title,
    String? companyName,
    String? industry,
    String? investmentRequired,
    double? expectedRoi,
    String? riskLevel,
    String? status,
    String? postedByEmail,
    String? postedByName,
    String? description,
    String? createdAt,
  }) {
    return DealModel(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      investmentRequired: investmentRequired ?? this.investmentRequired,
      expectedRoi: expectedRoi ?? this.expectedRoi,
      riskLevel: riskLevel ?? this.riskLevel,
      status: status ?? this.status,
      postedByEmail: postedByEmail ?? this.postedByEmail,
      postedByName: postedByName ?? this.postedByName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
