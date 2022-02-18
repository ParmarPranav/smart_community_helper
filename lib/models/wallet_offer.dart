class WalletOffer {
  WalletOffer({
    required this.id,
    required this.walletAmount,
    required this.bonusAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int walletAmount;
  final int bonusAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory WalletOffer.fromJson(Map<String, dynamic> json) => WalletOffer(
    id: json["id"],
    walletAmount: json["wallet_amount"],
    bonusAmount: json["bonus_amount"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "wallet_amount": walletAmount,
    "bonus_amount": bonusAmount,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
