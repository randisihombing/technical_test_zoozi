class Transaction {
  final int id;
  final int walletId;
  final String type;
  final int amount;
  final String? description;
  final String? referenceId;
  final DateTime createdAt;
  final int? relatedTransactionId;

  Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.description,
    this.referenceId,
    required this.createdAt,
    this.relatedTransactionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      walletId: json['walletId'],
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      referenceId: json['referenceId'],
      createdAt: DateTime.parse(json['timestamp']),
      relatedTransactionId: json['relatedTransactionId'],
    );
  }
}
