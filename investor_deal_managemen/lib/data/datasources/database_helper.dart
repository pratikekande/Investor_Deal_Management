import 'package:investor_deal_managemen/core/db_constants.dart';
import 'package:investor_deal_managemen/data/models/deal_model.dart';
import 'package:investor_deal_managemen/data/models/interest_model.dart';
import 'package:investor_deal_managemen/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.dbName);
    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.userTable} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colName} TEXT NOT NULL,
        ${DbConstants.colEmail} TEXT NOT NULL UNIQUE,
        ${DbConstants.colPassword} TEXT NOT NULL,
        ${DbConstants.colRole} TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DbConstants.dealTable} (
        ${DbConstants.colDealId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colDealTitle} TEXT NOT NULL,
        ${DbConstants.colCompanyName} TEXT NOT NULL,
        ${DbConstants.colIndustry} TEXT NOT NULL,
        ${DbConstants.colInvestmentRequired} TEXT NOT NULL,
        ${DbConstants.colExpectedRoi} REAL NOT NULL,
        ${DbConstants.colRiskLevel} TEXT NOT NULL,
        ${DbConstants.colStatus} TEXT NOT NULL DEFAULT 'Open',
        ${DbConstants.colPostedByEmail} TEXT NOT NULL,
        ${DbConstants.colPostedByName} TEXT NOT NULL,
        ${DbConstants.colDescription} TEXT NOT NULL,
        ${DbConstants.colCreatedAt} TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DbConstants.interestTable} (
        ${DbConstants.colInterestId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colInterestDealId} INTEGER NOT NULL,
        ${DbConstants.colInterestInvestorEmail} TEXT NOT NULL,
        ${DbConstants.colInterestDealTitle} TEXT NOT NULL,
        ${DbConstants.colInterestCompanyName} TEXT NOT NULL,
        ${DbConstants.colInterestIndustry} TEXT NOT NULL,
        ${DbConstants.colInterestInvestment} TEXT NOT NULL,
        ${DbConstants.colInterestRoi} REAL NOT NULL,
        ${DbConstants.colInterestRisk} TEXT NOT NULL,
        ${DbConstants.colInterestStatus} TEXT NOT NULL,
        ${DbConstants.colInterestPostedByEmail} TEXT NOT NULL,
        ${DbConstants.colInterestPostedByName} TEXT NOT NULL,
        ${DbConstants.colInterestDescription} TEXT NOT NULL,
        ${DbConstants.colInterestCreatedAt} TEXT NOT NULL,
        UNIQUE(${DbConstants.colInterestDealId}, ${DbConstants.colInterestInvestorEmail})
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${DbConstants.dealTable} (
          ${DbConstants.colDealId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbConstants.colDealTitle} TEXT NOT NULL,
          ${DbConstants.colCompanyName} TEXT NOT NULL,
          ${DbConstants.colIndustry} TEXT NOT NULL,
          ${DbConstants.colInvestmentRequired} TEXT NOT NULL,
          ${DbConstants.colExpectedRoi} REAL NOT NULL,
          ${DbConstants.colRiskLevel} TEXT NOT NULL,
          ${DbConstants.colStatus} TEXT NOT NULL DEFAULT 'Open',
          ${DbConstants.colPostedByEmail} TEXT NOT NULL,
          ${DbConstants.colPostedByName} TEXT NOT NULL,
          ${DbConstants.colDescription} TEXT NOT NULL,
          ${DbConstants.colCreatedAt} TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${DbConstants.interestTable} (
          ${DbConstants.colInterestId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbConstants.colInterestDealId} INTEGER NOT NULL,
          ${DbConstants.colInterestInvestorEmail} TEXT NOT NULL,
          ${DbConstants.colInterestDealTitle} TEXT NOT NULL,
          ${DbConstants.colInterestCompanyName} TEXT NOT NULL,
          ${DbConstants.colInterestIndustry} TEXT NOT NULL,
          ${DbConstants.colInterestInvestment} TEXT NOT NULL,
          ${DbConstants.colInterestRoi} REAL NOT NULL,
          ${DbConstants.colInterestRisk} TEXT NOT NULL,
          ${DbConstants.colInterestStatus} TEXT NOT NULL,
          ${DbConstants.colInterestPostedByEmail} TEXT NOT NULL,
          ${DbConstants.colInterestPostedByName} TEXT NOT NULL,
          ${DbConstants.colInterestDescription} TEXT NOT NULL,
          ${DbConstants.colInterestCreatedAt} TEXT NOT NULL,
          UNIQUE(${DbConstants.colInterestDealId}, ${DbConstants.colInterestInvestorEmail})
        )
      ''');
    }
  }

  // ── USER METHODS ──
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(DbConstants.userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(DbConstants.userTable,
        where: '${DbConstants.colEmail} = ?', whereArgs: [email], limit: 1);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query(DbConstants.userTable);
    return result.map((map) => UserModel.fromMap(map)).toList();
  }

  // ── DEAL METHODS ──
  Future<int> insertDeal(DealModel deal) async {
    final db = await database;
    return await db.insert(DbConstants.dealTable, deal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DealModel>> getAllDeals() async {
    final db = await database;
    final result = await db.query(DbConstants.dealTable,
        orderBy: '${DbConstants.colCreatedAt} DESC');
    return result.map((map) => DealModel.fromMap(map)).toList();
  }

  Future<List<DealModel>> getDealsByPostedByEmail(String email) async {
    final db = await database;
    final result = await db.query(DbConstants.dealTable,
        where: '${DbConstants.colPostedByEmail} = ?',
        whereArgs: [email],
        orderBy: '${DbConstants.colCreatedAt} DESC');
    return result.map((map) => DealModel.fromMap(map)).toList();
  }

  Future<int> updateDealStatus(int dealId, String status) async {
    final db = await database;
    return await db.update(
      DbConstants.dealTable,
      {DbConstants.colStatus: status},
      where: '${DbConstants.colDealId} = ?',
      whereArgs: [dealId],
    );
  }

  Future<int> deleteDeal(int dealId) async {
    final db = await database;
    return await db.delete(DbConstants.dealTable,
        where: '${DbConstants.colDealId} = ?', whereArgs: [dealId]);
  }

  // ── INTEREST METHODS ──
  Future<int> insertInterest(InterestModel interest) async {
    final db = await database;
    return await db.insert(DbConstants.interestTable, interest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<InterestModel>> getInterestsByInvestorEmail(String email) async {
    final db = await database;
    final result = await db.query(DbConstants.interestTable,
        where: '${DbConstants.colInterestInvestorEmail} = ?',
        whereArgs: [email]);
    return result.map((map) => InterestModel.fromMap(map)).toList();
  }

  Future<bool> isInterested(int dealId, String investorEmail) async {
    final db = await database;
    final result = await db.query(DbConstants.interestTable,
        where:
            '${DbConstants.colInterestDealId} = ? AND ${DbConstants.colInterestInvestorEmail} = ?',
        whereArgs: [dealId, investorEmail],
        limit: 1);
    return result.isNotEmpty;
  }

  Future<int> deleteInterest(int dealId, String investorEmail) async {
    final db = await database;
    return await db.delete(DbConstants.interestTable,
        where:
            '${DbConstants.colInterestDealId} = ? AND ${DbConstants.colInterestInvestorEmail} = ?',
        whereArgs: [dealId, investorEmail]);
  }
}