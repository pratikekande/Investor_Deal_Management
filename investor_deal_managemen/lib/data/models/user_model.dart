
import 'package:investor_deal_managemen/core/db_constants.dart';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colName: name,
      DbConstants.colEmail: email,
      DbConstants.colPassword: password,
      DbConstants.colRole: role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[DbConstants.colId] as int?,
      name: map[DbConstants.colName] as String,
      email: map[DbConstants.colEmail] as String,
      password: map[DbConstants.colPassword] as String,
      role: map[DbConstants.colRole] as String,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}