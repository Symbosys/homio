import 'package:flutter/foundation.dart';
import '../models/ai_credit_transaction.dart';

/// Central singleton service managing AI credits, deductions, and transaction history.
/// Provides reactive updates via [balanceNotifier] and [transactionsNotifier].
class AiCreditService extends ChangeNotifier {
  static final AiCreditService instance = AiCreditService._internal();

  factory AiCreditService() => instance;

  AiCreditService._internal() {
    _initDefaults();
  }

  int _balance = 48;
  final List<AiCreditTransaction> _transactions = [];

  int get balance => _balance;
  List<AiCreditTransaction> get transactions => List.unmodifiable(_transactions);

  void _initDefaults() {
    _transactions.addAll([
      AiCreditTransaction(
        id: 'TXN-001',
        title: 'Monthly Subscription Bonus',
        toolUsed: 'Plan Quota',
        amountCredits: 50,
        type: CreditTransactionType.creditAdded,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
      AiCreditTransaction(
        id: 'TXN-002',
        title: '3D Living Room Photorealistic Render',
        toolUsed: 'Room Designer',
        amountCredits: 2,
        type: CreditTransactionType.generationDeduction,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      ),
    ]);
  }

  /// Checks if customer has sufficient credits for an operation.
  bool hasSufficientCredits(int requiredCredits) => _balance >= requiredCredits;

  /// Deducts credits for a tool operation. Returns true if successful.
  bool deductCredits({
    required int amount,
    required String toolName,
    required String operationTitle,
  }) {
    if (_balance < amount) return false;

    _balance -= amount;
    _transactions.insert(
      0,
      AiCreditTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: operationTitle,
        toolUsed: toolName,
        amountCredits: amount,
        type: CreditTransactionType.generationDeduction,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
    return true;
  }

  /// Adds purchased or bonus credits to the wallet.
  void addCredits({
    required int amount,
    required String packName,
  }) {
    _balance += amount;
    _transactions.insert(
      0,
      AiCreditTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: 'Purchased $packName',
        toolUsed: 'Credit Pack',
        amountCredits: amount,
        type: CreditTransactionType.creditAdded,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// Available credit packs for top-up.
  static const List<AiCreditPack> standardPacks = [
    AiCreditPack(
      id: 'pack_starter',
      name: 'Starter Pack',
      credits: 25,
      priceInr: 499,
      perCreditRateInr: 19.96,
      savingsBadge: 'Basic',
    ),
    AiCreditPack(
      id: 'pack_pro',
      name: 'Pro Studio Pack',
      credits: 100,
      priceInr: 1499,
      perCreditRateInr: 14.99,
      isPopular: true,
      savingsBadge: '25% SAVINGS',
    ),
    AiCreditPack(
      id: 'pack_enterprise',
      name: 'Villa / Master Pack',
      credits: 300,
      priceInr: 3499,
      perCreditRateInr: 11.66,
      savingsBadge: '40% SAVINGS',
    ),
  ];
}
