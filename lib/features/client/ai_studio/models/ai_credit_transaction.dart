enum CreditTransactionType {
  creditAdded('Credit Purchase / Bonus', true),
  generationDeduction('AI Generation Usage', false),
  refundAdjustment('Auto-Refund / Adjustment', true);

  final String label;
  final bool isPositive;
  const CreditTransactionType(this.label, this.isPositive);
}

class AiCreditTransaction {
  final String id;
  final String title;
  final String toolUsed;
  final int amountCredits;
  final CreditTransactionType type;
  final DateTime timestamp;
  final String? referenceId;

  const AiCreditTransaction({
    required this.id,
    required this.title,
    required this.toolUsed,
    required this.amountCredits,
    required this.type,
    required this.timestamp,
    this.referenceId,
  });
}

class AiCreditPack {
  final String id;
  final String name;
  final int credits;
  final double priceInr;
  final double perCreditRateInr;
  final bool isPopular;
  final String savingsBadge;

  const AiCreditPack({
    required this.id,
    required this.name,
    required this.credits,
    required this.priceInr,
    required this.perCreditRateInr,
    this.isPopular = false,
    this.savingsBadge = '',
  });
}
