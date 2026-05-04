class DbConstants {
  DbConstants._();

  static const String dbName = 'dealflow.db';
  static const int dbVersion = 1;

  // Table
  static const String userTable = 'users';

  // Columns
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colEmail = 'email';
  static const String colPassword = 'password';
  static const String colRole = 'role'; // 'investor' or 'corporate'
}