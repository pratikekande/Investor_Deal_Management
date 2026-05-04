class DealEntity {
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

  const DealEntity({
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

  DealEntity copyWith({
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
    return DealEntity(
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
