import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';

class WarrantyClaimModal extends StatefulWidget {
  final WarrantyRecord? warranty;
  final WarrantyClaim? existingClaimToReview;
  final ValueChanged<WarrantyClaim> onClaimSaved;

  const WarrantyClaimModal({
    super.key,
    this.warranty,
    this.existingClaimToReview,
    required this.onClaimSaved,
  });

  @override
  State<WarrantyClaimModal> createState() => _WarrantyClaimModalState();
}

class _WarrantyClaimModalState extends State<WarrantyClaimModal> {
  final _formKey = GlobalKey<FormState>();

  late WarrantyRecord _selectedWarranty;
  final TextEditingController _issueAreaCtrl = TextEditingController(text: 'Kitchen Modular Cabinetry');
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _resolutionCtrl = TextEditingController(text: 'Free OEM hardware replacement under 1-Yr Comprehensive Warranty');
  final TextEditingController _rejectionReasonCtrl = TextEditingController();
  final TextEditingController _approvedAmountCtrl = TextEditingController(text: '3500');

  String _decision = 'Approved';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedWarranty = widget.warranty ?? AfterSalesMockData.warranties.first;
    if (widget.existingClaimToReview != null) {
      final c = widget.existingClaimToReview!;
      _issueAreaCtrl.text = c.issueArea;
      _descCtrl.text = c.description;
      _resolutionCtrl.text = c.requestedResolution;
      _approvedAmountCtrl.text = c.approvedCoverageAmount.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _issueAreaCtrl.dispose();
    _descCtrl.dispose();
    _resolutionCtrl.dispose();
    _rejectionReasonCtrl.dispose();
    _approvedAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final isReviewMode = widget.existingClaimToReview != null;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        height: 640,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.security_rounded, color: Color(0xFF10B981), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isReviewMode ? 'Review Warranty Claim & Adjudicate' : 'Lodge Warranty Repair Claim',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimaryColor),
                          ),
                          Text(
                            isReviewMode ? 'Validate warranty terms, check coverage exclusions and approve' : 'Linked to active project warranty coverage and handover certificate',
                            style: TextStyle(fontSize: 12, color: textSecondaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Warranty Policy Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedWarranty.warrantyNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _selectedWarranty.status.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(_selectedWarranty.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _selectedWarranty.status.color)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(_selectedWarranty.coveredItemWork, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                            const SizedBox(height: 2),
                            Text('${_selectedWarranty.projectName} • Customer: ${_selectedWarranty.customerName}', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                            const SizedBox(height: 8),
                            Text('Coverage includes: ${_selectedWarranty.inclusions.join(', ')}', style: const TextStyle(fontSize: 10, color: Color(0xFF10B981))),
                            Text('Exclusions: ${_selectedWarranty.exclusions.join(', ')}', style: TextStyle(fontSize: 10, color: Colors.orange.shade800)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Issue Area
                      TextFormField(
                        controller: _issueAreaCtrl,
                        readOnly: isReviewMode,
                        decoration: InputDecoration(
                          labelText: 'Defective Component / Work Area *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter component' : null,
                      ),
                      const SizedBox(height: 14),

                      // Description
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        readOnly: isReviewMode,
                        decoration: InputDecoration(
                          labelText: 'Defect Description & Cause of Claim *',
                          hintText: 'Describe how the component failed under normal usage conditions...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 14),

                      // Requested Resolution
                      TextFormField(
                        controller: _resolutionCtrl,
                        readOnly: isReviewMode,
                        decoration: InputDecoration(
                          labelText: 'Requested Resolution Under Policy *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: backgroundColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Adjudication section if review mode
                      if (isReviewMode) ...[
                        Text('Adjudication & Manager Decision', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _decision,
                                decoration: InputDecoration(
                                  labelText: 'Claim Decision *',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Approved', child: Text('Approve Claim (100% Covered)')),
                                  DropdownMenuItem(value: 'Rejected', child: Text('Reject Claim (Out of Scope / Exclusion)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _decision = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _approvedAmountCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Approved Coverage Value (₹)',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_decision == 'Rejected') ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _rejectionReasonCtrl,
                            decoration: InputDecoration(
                              labelText: 'Mandatory Reason for Claim Rejection *',
                              hintText: 'e.g. Failure caused by unauthorized third-party modification...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                            validator: (val) => (_decision == 'Rejected' && (val == null || val.trim().isEmpty)) ? 'Rejection reason is required' : null,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _saveClaim,
                    icon: _isProcessing
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(_isProcessing ? 'PROCESSING...' : (isReviewMode ? 'SAVE DECISION' : 'SUBMIT CLAIM')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveClaim() {
    if (!_formKey.currentState!.validate()) return;

    final nav = Navigator.of(context);
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      final isReviewMode = widget.existingClaimToReview != null;

      final claim = WarrantyClaim(
        id: isReviewMode ? widget.existingClaimToReview!.id : 'CLM-${DateTime.now().millisecondsSinceEpoch}',
        claimNumber: isReviewMode ? widget.existingClaimToReview!.claimNumber : 'CLM-${_selectedWarranty.projectName.substring(0, 3).toUpperCase()}-${DateTime.now().millisecond}',
        warrantyId: _selectedWarranty.id,
        warrantyNumber: _selectedWarranty.warrantyNumber,
        customerId: _selectedWarranty.customerId,
        customerName: _selectedWarranty.customerName,
        projectId: _selectedWarranty.projectId,
        projectName: _selectedWarranty.projectName,
        issueArea: _issueAreaCtrl.text.trim(),
        issueDate: DateTime.now(),
        description: _descCtrl.text.trim().isEmpty ? 'Hardware functional defect.' : _descCtrl.text.trim(),
        requestedResolution: _resolutionCtrl.text.trim(),
        claimDate: isReviewMode ? widget.existingClaimToReview!.claimDate : DateTime.now(),
        status: isReviewMode ? (_decision == 'Approved' ? WarrantyStatus.approved : WarrantyStatus.rejected) : WarrantyStatus.claimUnderReview,
        reviewerName: isReviewMode ? 'Amit Service Manager' : null,
        reviewDate: isReviewMode ? DateTime.now() : null,
        rejectionReason: _decision == 'Rejected' ? _rejectionReasonCtrl.text.trim() : null,
        approvedCoverageAmount: double.tryParse(_approvedAmountCtrl.text.trim()) ?? 0.0,
      );

      widget.onClaimSaved(claim);
      nav.pop();
    });
  }
}
