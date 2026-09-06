import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/commercial_billing_card.dart';

class ExecutionCommercialsPage extends StatefulWidget {
  const ExecutionCommercialsPage({super.key});

  @override
  State<ExecutionCommercialsPage> createState() => _ExecutionCommercialsPageState();
}

class _ExecutionCommercialsPageState extends State<ExecutionCommercialsPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  void _handleInvoiceTrigger(String milestoneName, double amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tax Invoice generated for "$milestoneName" (₹${amount.toStringAsFixed(0)}). Sent to client.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleRecordPayment(String milestoneName, double amount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Record Payment - $milestoneName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount Due: ₹${amount.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Transaction Reference / UTR #',
                prefixIcon: Icon(Icons.receipt_long),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: 'Bank NEFT/RTGS',
              decoration: const InputDecoration(labelText: 'Payment Mode'),
              items: const [
                DropdownMenuItem(value: 'Bank NEFT/RTGS', child: Text('Bank NEFT / RTGS')),
                DropdownMenuItem(value: 'UPI / QR', child: Text('UPI / QR')),
                DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                DropdownMenuItem(value: 'Direct Credit', child: Text('Direct Credit')),
              ],
              onChanged: (_) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment of ₹${amount.toStringAsFixed(0)} recorded with receipt.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Confirm Receipt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;

    // Financial calculations
    final contractValue = proj?.totalContractValue ?? 0.0;
    final billedAmount = proj?.billedAmount ?? 0.0;
    final collectedAmount = proj?.receivedAmount ?? 0.0;
    final pendingCollection = billedAmount - collectedAmount;
    final unbilledContract = contractValue - billedAmount;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ExecutionHeader(
              title: 'Contract Commercials & Milestone Billing',
              subtitle: 'Multi-contract commercial models (Fixed, Percentage, Turnkey) & automated billing triggers',
              primaryActionLabel: 'Generate Statement',
              primaryActionIcon: Icons.receipt_long_outlined,
              onPrimaryAction: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting complete client financial statement PDF...')),
                );
              },
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Synchronizing commercial ledger with accounting tally...')),
                    );
                  },
                  icon: const Icon(Icons.sync, size: 18),
                  label: const Text('Sync Accounts'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Metric Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Contract Value',
                    value: '₹${(contractValue / 100000).toStringAsFixed(2)}L',
                    subtitle: 'Model: ${proj?.contractModel.label ?? "N/A"}',
                    icon: Icons.account_balance_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Invoiced',
                    value: '₹${(billedAmount / 100000).toStringAsFixed(2)}L',
                    subtitle: '${contractValue > 0 ? ((billedAmount / contractValue) * 100).toInt() : 0}% of order value',
                    icon: Icons.receipt_outlined,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Collected',
                    value: '₹${(collectedAmount / 100000).toStringAsFixed(2)}L',
                    subtitle: 'Bank verified receipts',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Balance Receivable',
                    value: '₹${((pendingCollection > 0 ? pendingCollection : 0) / 100000).toStringAsFixed(2)}L',
                    subtitle: '₹${((unbilledContract > 0 ? unbilledContract : 0) / 100000).toStringAsFixed(2)}L unbilled',
                    icon: Icons.pending_actions_outlined,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Project Selector & Contract Model Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedProjectId,
                        underline: const SizedBox(),
                        items: _projects.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              '${p.projectName} (${p.contractModel.label})',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedProjectId = v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Model Badge
                  if (proj != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Active Commercial Model: ${proj.contractModel.label}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detailed Commercials Card (Fixed, Percentage, Turnkey)
            if (proj != null)
              CommercialBillingCard(
                project: proj,
                onTriggerInvoice: _handleInvoiceTrigger,
                onRecordPayment: _handleRecordPayment,
              )
            else
              const Center(child: Text('No project selected.')),
          ],
        ),
      ),
    );
  }
}
