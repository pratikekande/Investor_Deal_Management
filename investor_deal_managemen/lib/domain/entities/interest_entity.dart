class InterestEntity {
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

  const InterestEntity({
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
}
