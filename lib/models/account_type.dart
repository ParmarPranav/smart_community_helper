import 'package:intl/intl.dart';

class AccountType {
  final int id;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountType({
    required this.id,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountType.fromJson(Map<String, dynamic> json) => AccountType(
        id: json["id"] as int,
        accountType: json["account_type"] as String,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
        updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      );

  static Map<String, dynamic> toJson(AccountType accountType) => {
        "id": accountType.id,
        "account_type": accountType.accountType,
        "created_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(accountType.createdAt),
        "updated_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(accountType.updatedAt),
      };
}
