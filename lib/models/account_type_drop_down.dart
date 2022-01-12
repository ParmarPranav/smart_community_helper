import 'package:intl/intl.dart';

class AccountTypeDropDown {
  final int id;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountTypeDropDown({
    required this.id,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountTypeDropDown.fromJson(Map<String, dynamic> json) {
    return AccountTypeDropDown(
      id: json['id'] as int,
      accountType: json['account_type'] as String,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["created_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
      updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').parseUTC((json["updated_at"] as String).replaceFirst('T', ' ').replaceFirst('Z', '')),
    );
  }
}
