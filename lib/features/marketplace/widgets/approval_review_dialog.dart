import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class ApprovalReviewDialog extends StatefulWidget {
  final MarketplaceApprovalItem item;

  const ApprovalReviewDialog({super.key, required this.item});

  static void show(BuildContext context, MarketplaceApprovalItem item) {
    showDialog(
      context: context,
      builder: (ctx) => ApprovalReviewDialog(item: item),
    );
  }

  @override
  State<ApprovalReviewDialog> createState() => _ApprovalReviewDialogState();
}

class _ApprovalReviewDialogState extends State<ApprovalReviewDialog> {
  final _repo = MarketplaceRepository();
  final _reasonCtrl = TextEditingController();
  bool _notifySubmitter = true;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _resolve(bool isApproved) {
    if (!isApproved && _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please state the specific reason or required change.')));
      return;
    }

    _repo.resolveApproval(widget.item.id, isApproved, _reasonCtrl.text.trim());
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isApproved ? 'Submission approved successfully!' : 'Submission rejected with feedback.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.12), borderRadius: AppRadius.sm),
                    child: const Icon(Icons.approval_rounded, color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Catalogue Approval Review Queue', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                        Text('${widget.item.entityType.label} • Priority: ${widget.item.priority}', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.entityTitle, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Submitted By: ${widget.item.submittedByName} • ${widget.item.categoryName}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8))),
                    const SizedBox(height: 6),
                    Text('Validation Status: ${widget.item.missingInformation}', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B))),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Feedback / Rejection Reason / Required Changes', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
              const SizedBox(height: 6),
              TextField(
                controller: _reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Enter specific corrections required or reason for approval decision...',
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1))),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Notify submitter via internal notifications and email', style: GoogleFonts.plusJakartaSans(fontSize: 11.5)),
                value: _notifySubmitter,
                onChanged: (v) => setState(() => _notifySubmitter = v ?? true),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _resolve(false),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
                    child: const Text('Reject / Request Changes'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _resolve(true),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                    child: const Text('Approve Submission'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
