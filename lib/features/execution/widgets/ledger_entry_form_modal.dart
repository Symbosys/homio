import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';

class LedgerEntryFormModal extends StatefulWidget {
  final ProjectMaster project;
  final LedgerType initialType;
  final FinancialLedgerEntry? initialEntry;
  final void Function(FinancialLedgerEntry entry) onSubmit;

  const LedgerEntryFormModal({
    super.key,
    required this.project,
    this.initialType = LedgerType.material,
    this.initialEntry,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required ProjectMaster project,
    LedgerType initialType = LedgerType.material,
    FinancialLedgerEntry? initialEntry,
    required void Function(FinancialLedgerEntry entry) onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LedgerEntryFormModal(
        project: project,
        initialType: initialType,
        initialEntry: initialEntry,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<LedgerEntryFormModal> createState() => _LedgerEntryFormModalState();
}

class _LedgerEntryFormModalState extends State<LedgerEntryFormModal> {
  final _formKey = GlobalKey<FormState>();
  late LedgerType _ledgerType;

  final _descriptionController = TextEditingController();
  final _vendorController = TextEditingController();
  final _refCodeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1.0');
  final _unitPriceController = TextEditingController(text: '0');
  final _totalAmountController = TextEditingController(text: '0');
  final _paidAmountController = TextEditingController(text: '0');
  final _taxGstController = TextEditingController(text: '18');

  String _paymentStatus = 'Paid';
  DateTime _entryDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ledgerType = widget.initialEntry?.type ?? widget.initialType;

    if (widget.initialEntry != null) {
      final e = widget.initialEntry!;
      _descriptionController.text = e.description;
      _vendorController.text = e.vendorOrContractor;
      _refCodeController.text = e.referenceCode;
      _quantityController.text = e.quantity.toString();
      _unitPriceController.text = e.unitPrice.toStringAsFixed(2);
      _totalAmountController.text = e.totalAmount.toStringAsFixed(2);
      _paidAmountController.text = e.paidAmount.toStringAsFixed(2);
      _taxGstController.text = e.taxGstPercentage.toStringAsFixed(0);
      _paymentStatus = e.paymentStatus;
      _entryDate = e.entryDate;
    } else {
      _setDefaultRefCode();
    }
  }

  void _setDefaultRefCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    switch (_ledgerType) {
      case LedgerType.material:
        _refCodeController.text = 'PO-$timestamp';
        _descriptionController.text = 'Ultratech Super Cement & River Sand';
        _vendorController.text = 'BuildWell Supplies Pvt Ltd';
        _unitPriceController.text = '420';
        _quantityController.text = '50';
        break;
      case LedgerType.labour:
        _refCodeController.text = 'LAB-$timestamp';
        _descriptionController.text = 'Plastering & ceiling leveling team (5 days)';
        _vendorController.text = 'Sharma Civil Works';
        _unitPriceController.text = '850';
        _quantityController.text = '15';
        break;
      case LedgerType.supervision:
        _refCodeController.text = 'SUP-$timestamp';
        _descriptionController.text = 'Site audit, structural QC & milestone certification';
        _vendorController.text = 'Vikramaditya (Senior Site Engineer)';
        _unitPriceController.text = '15000';
        _quantityController.text = '1';
        break;
    }
    _recomputeTotal();
  }

  void _recomputeTotal() {
    final qty = double.tryParse(_quantityController.text) ?? 1.0;
    final unit = double.tryParse(_unitPriceController.text) ?? 0.0;
    final gst = double.tryParse(_taxGstController.text) ?? 0.0;
    final base = qty * unit;
    final total = base + (base * gst / 100);
    _totalAmountController.text = total.toStringAsFixed(2);
    if (_paymentStatus == 'Paid') {
      _paidAmountController.text = total.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _vendorController.dispose();
    _refCodeController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _totalAmountController.dispose();
    _paidAmountController.dispose();
    _taxGstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initialEntry != null ? 'Edit Financial Entry' : 'New Ledger Bill / Voucher',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Project: ${widget.project.projectName} (${widget.project.projectCode})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 14),

                // Sub-Ledger Category
                Text(
                  'Sub-Ledger Classification *',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: LedgerType.values.map((type) {
                    final isSel = _ledgerType == type;
                    return ChoiceChip(
                      label: Text(type.label),
                      selected: isSel,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel
                            ? AppColors.primary
                            : (isDark ? AppColors.darkText : AppColors.lightText),
                      ),
                      onSelected: (val) {
                        if (val && _ledgerType != type) {
                          setState(() {
                            _ledgerType = type;
                            _setDefaultRefCode();
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Reference Code & Vendor / Contractor
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _refCodeController,
                        decoration: InputDecoration(
                          labelText: _ledgerType == LedgerType.material
                              ? 'PO / Bill Ref *'
                              : 'Voucher / Ref # *',
                          prefixIcon: const Icon(Icons.tag, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _vendorController,
                        decoration: InputDecoration(
                          labelText: _ledgerType == LedgerType.material
                              ? 'Vendor / Supplier Name *'
                              : _ledgerType == LedgerType.labour
                                  ? 'Contractor / Agency *'
                                  : 'Supervisor / Engineer *',
                          prefixIcon: const Icon(Icons.business_outlined, size: 20),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Item / Service Description *',
                    hintText: 'e.g., 200 bags OPC cement, Electrical roughing labour...',
                    prefixIcon: Icon(Icons.notes, size: 20),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Description required' : null,
                ),
                const SizedBox(height: 14),

                // Numeric Fields: Quantity, Unit Price, Tax %
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Qty / Units *',
                          prefixIcon: Icon(Icons.format_list_numbered, size: 20),
                        ),
                        onChanged: (_) => _recomputeTotal(),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _unitPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Unit Rate (₹) *',
                          prefixIcon: Icon(Icons.currency_rupee, size: 20),
                        ),
                        onChanged: (_) => _recomputeTotal(),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _taxGstController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'GST / Tax %',
                          suffixText: '%',
                          prefixIcon: Icon(Icons.percent, size: 20),
                        ),
                        onChanged: (_) => _recomputeTotal(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Total, Paid Amount, Payment Status
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Gross Total (₹) *',
                          prefixIcon: Icon(Icons.currency_rupee, size: 20),
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _paidAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Paid So Far (₹) *',
                          prefixIcon: Icon(Icons.done_all, size: 20),
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _paymentStatus,
                        decoration: const InputDecoration(
                          labelText: 'Payment Status',
                          prefixIcon: Icon(Icons.payment, size: 20),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Paid', child: Text('Fully Paid')),
                          DropdownMenuItem(value: 'Partial', child: Text('Partial')),
                          DropdownMenuItem(value: 'Pending', child: Text('Pending Approval')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _paymentStatus = val;
                              if (val == 'Paid') {
                                _paidAmountController.text = _totalAmountController.text;
                              } else if (val == 'Pending') {
                                _paidAmountController.text = '0';
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date Picker row
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Bill / Transaction Date: ${_entryDate.day}/${_entryDate.month}/${_entryDate.year}',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _entryDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() => _entryDate = picked);
                        }
                      },
                      child: const Text('Change Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Post Ledger Entry'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final total = double.parse(_totalAmountController.text);
      final paid = double.parse(_paidAmountController.text);
      final balance = total - paid;

      final entry = FinancialLedgerEntry(
        id: widget.initialEntry?.id ?? 'LEDG-${DateTime.now().millisecondsSinceEpoch}',
        projectId: widget.project.id,
        type: _ledgerType,
        referenceCode: _refCodeController.text.trim(),
        description: _descriptionController.text.trim(),
        vendorOrContractor: _vendorController.text.trim(),
        quantity: double.tryParse(_quantityController.text) ?? 1.0,
        unitPrice: double.tryParse(_unitPriceController.text) ?? 0.0,
        taxGstPercentage: double.tryParse(_taxGstController.text) ?? 18.0,
        totalAmount: total,
        paidAmount: paid,
        balanceDue: balance < 0 ? 0 : balance,
        paymentStatus: _paymentStatus,
        entryDate: _entryDate,
      );

      widget.onSubmit(entry);
      Navigator.of(context).pop();
    }
  }
}
