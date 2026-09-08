import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Clean repository interface for Wallet & Incentives module.
abstract class IWalletRepository {
  Future<WalletSummary> getWalletSummary({DashboardDateFilter? dateFilter});
  Future<List<WalletTransaction>> getTransactions({TransactionCategory? category, String? searchQuery});
  Future<List<IncentiveBreakdownItem>> getIncentiveBreakdowns();
  Future<WalletTransaction> requestPayout({required double amount, required String bankAccount});
  Future<WalletTransaction> submitExpenseClaim({
    required String title,
    required TransactionCategory category,
    required double amount,
    required String projectName,
    required String description,
  });
}

/// Production-ready mock implementation of WalletRepository.
class WalletRepository implements IWalletRepository {
  static final WalletRepository instance = WalletRepository._internal();
  WalletRepository._internal() {
    _initializeData();
  }
  factory WalletRepository() => instance;

  double _currentBalance = 12450.0;
  final double _totalSpent = 38200.0;
  double _pendingReimbursement = 4850.0;
  final double _approvedReimbursement = 8400.0;

  final List<WalletTransaction> _transactions = [];
  final List<IncentiveBreakdownItem> _incentives = [];

  void _initializeData() {
    _incentives.addAll([
      const IncentiveBreakdownItem(
        id: 'INC-01',
        title: 'Sales Booking Incentive',
        amount: 8000.0,
        rule: '1.25% of ₹64 Lakhs DLF Phase 5 Villa contract token signed',
        status: 'Approved & Settled',
        icon: Icons.monetization_on_rounded,
      ),
      const IncentiveBreakdownItem(
        id: 'INC-02',
        title: 'Task Performance & Velocity',
        amount: 3500.0,
        rule: '94% On-time task completion rate (>90% threshold tier)',
        status: 'Approved & Settled',
        icon: Icons.bolt_rounded,
      ),
      const IncentiveBreakdownItem(
        id: 'INC-03',
        title: 'Project Milestone Completion',
        amount: 4000.0,
        rule: 'Sobha City Penthouse framing milestone closed 3 days ahead of schedule',
        status: 'Approved & Settled',
        icon: Icons.verified_rounded,
      ),
      const IncentiveBreakdownItem(
        id: 'INC-04',
        title: 'Customer Satisfaction (CSAT)',
        amount: 3000.0,
        rule: '4.9/5 client review rating from Mr. Rahul Sharma',
        status: 'Approved & Settled',
        icon: Icons.thumb_up_alt_rounded,
      ),
    ]);

    _transactions.addAll([
      const WalletTransaction(
        id: 'TXN-9841',
        title: 'DLF Phase 5 Site Fuel & Travel Claim',
        category: TransactionCategory.travel,
        amount: 220.80,
        isCredit: true,
        date: '08 Sep 2026',
        status: 'pending',
        referenceId: 'REF-TRV-104',
        projectName: 'DLF Phase 5 Villa #104',
        clientName: 'Rahul Sharma',
        approvedBy: 'Pending Manager Approval',
      ),
      const WalletTransaction(
        id: 'TXN-9840',
        title: 'Emergency Site Masonry Fasteners',
        category: TransactionCategory.pettyCash,
        amount: 850.00,
        isCredit: false,
        date: '07 Sep 2026',
        status: 'settled',
        referenceId: 'REF-PC-891',
        projectName: 'Sobha City Penthouse',
        clientName: 'Pooja Verma',
        approvedBy: 'Aarav Sharma (Site Head)',
      ),
      const WalletTransaction(
        id: 'TXN-9839',
        title: 'August Performance Incentive Payout',
        category: TransactionCategory.incentive,
        amount: 14300.00,
        isCredit: true,
        date: '01 Sep 2026',
        status: 'settled',
        referenceId: 'REF-INC-AUG',
        projectName: 'Operations Enterprise Hub',
        clientName: 'Homio Finance Treasury',
        approvedBy: 'Director of Operations',
      ),
      const WalletTransaction(
        id: 'TXN-9838',
        title: 'Architectural Blueprint Printing (A0 Plotter)',
        category: TransactionCategory.siteExpense,
        amount: 1240.00,
        isCredit: false,
        date: '28 Aug 2026',
        status: 'settled',
        referenceId: 'REF-EXP-342',
        projectName: 'Godrej Woods 3BHK',
        clientName: 'Ananya Deshmukh',
        approvedBy: 'Design Lead',
      ),
      const WalletTransaction(
        id: 'TXN-9837',
        title: 'Inter-City Site Travel Reimbursement',
        category: TransactionCategory.reimbursement,
        amount: 4850.00,
        isCredit: true,
        date: '25 Aug 2026',
        status: 'settled',
        referenceId: 'REF-TRV-AUG2',
        projectName: 'Kishangarh Marble Selection',
        clientName: 'Homio Procurement',
        approvedBy: 'VP Finance',
      ),
      const WalletTransaction(
        id: 'TXN-9836',
        title: 'Delay Penalty Salary Deduction',
        category: TransactionCategory.deduction,
        amount: 2000.00,
        isCredit: false,
        date: '20 Aug 2026',
        status: 'settled',
        referenceId: 'REF-DED-01',
        projectName: 'HRMS Penalty Sync',
        clientName: 'HR Audit System',
        approvedBy: 'System Auto-Audit',
      ),
    ]);
  }

  @override
  Future<WalletSummary> getWalletSummary({DashboardDateFilter? dateFilter}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return WalletSummary(
      currentBalance: _currentBalance,
      totalSpent: _totalSpent,
      pendingReimbursement: _pendingReimbursement,
      approvedReimbursement: _approvedReimbursement,
    );
  }

  @override
  Future<List<WalletTransaction>> getTransactions({TransactionCategory? category, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = List<WalletTransaction>.from(_transactions);

    if (category != null) {
      list = list.where((t) => t.category == category).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((t) =>
        t.title.toLowerCase().contains(q) ||
        t.referenceId.toLowerCase().contains(q) ||
        t.projectName.toLowerCase().contains(q) ||
        t.clientName.toLowerCase().contains(q)
      ).toList();
    }

    return list;
  }

  @override
  Future<List<IncentiveBreakdownItem>> getIncentiveBreakdowns() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_incentives);
  }

  @override
  Future<WalletTransaction> requestPayout({required double amount, required String bankAccount}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final txn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: 'Requested Bank Payout ($bankAccount)',
      category: TransactionCategory.reimbursement,
      amount: amount,
      isCredit: false,
      date: 'Today',
      status: 'processing',
      referenceId: 'REF-PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      projectName: 'Personal Wallet',
      clientName: 'Vikram Malhotra',
      approvedBy: 'Processing in HDFC Gateway',
    );
    _currentBalance -= amount;
    _transactions.insert(0, txn);
    return txn;
  }

  @override
  Future<WalletTransaction> submitExpenseClaim({
    required String title,
    required TransactionCategory category,
    required double amount,
    required String projectName,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final txn = WalletTransaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: title,
      category: category,
      amount: amount,
      isCredit: true,
      date: 'Today',
      status: 'pending',
      referenceId: 'REF-CLM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      projectName: projectName,
      clientName: 'Homio Claims Desk',
      approvedBy: 'Pending Audit Review',
    );
    _pendingReimbursement += amount;
    _transactions.insert(0, txn);
    return txn;
  }
}
