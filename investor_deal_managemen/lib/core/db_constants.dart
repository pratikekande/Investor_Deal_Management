class DbConstants {
  DbConstants._();

  static const String dbName = 'dealflow.db';
  static const int dbVersion = 2;

  // ── User table ──
  static const String userTable = 'users';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colEmail = 'email';
  static const String colPassword = 'password';
  static const String colRole = 'role'; // 'investor' or 'corporate'

  // ── Deal table ──
  static const String dealTable = 'deals';
  static const String colDealId = 'id';
  static const String colDealTitle = 'title';
  static const String colCompanyName = 'company_name';
  static const String colIndustry = 'industry';
  static const String colInvestmentRequired = 'investment_required';
  static const String colExpectedRoi = 'expected_roi';
  static const String colRiskLevel = 'risk_level';
  static const String colStatus = 'status';
  static const String colPostedByEmail = 'posted_by_email';
  static const String colPostedByName = 'posted_by_name';
  static const String colDescription = 'description';
  static const String colCreatedAt = 'created_at';

  // ── Interest table ──
  static const String interestTable = 'interests';
  static const String colInterestId = 'id';
  static const String colInterestDealId = 'deal_id';
  static const String colInterestInvestorEmail = 'investor_email';
  static const String colInterestDealTitle = 'deal_title';
  static const String colInterestCompanyName = 'interest_company_name';
  static const String colInterestIndustry = 'interest_industry';
  static const String colInterestInvestment = 'interest_investment';
  static const String colInterestRoi = 'interest_roi';
  static const String colInterestRisk = 'interest_risk';
  static const String colInterestStatus = 'interest_status';
  static const String colInterestPostedByEmail = 'interest_posted_by_email';
  static const String colInterestPostedByName = 'interest_posted_by_name';
  static const String colInterestDescription = 'interest_description';
  static const String colInterestCreatedAt = 'interest_created_at';
}