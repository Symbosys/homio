import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_enums.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';
import 'marketplace_status_badge.dart';

class PropertyVerificationDialog extends StatefulWidget {
  final PropertyListingEntity property;

  const PropertyVerificationDialog({super.key, required this.property});

  static void show(BuildContext context, PropertyListingEntity property) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PropertyVerificationDialog(property: property),
    );
  }

  @override
  State<PropertyVerificationDialog> createState() => _PropertyVerificationDialogState();
}

class _PropertyVerificationDialogState extends State<PropertyVerificationDialog> {
  final _repo = MarketplaceRepository();
  final _notesCtrl = TextEditingController();

  bool _checkedTitleDeed = false;
  bool _checkedElectricityBill = false;
  bool _checkedPhysicalVisit = false;
  bool _checkedMediaQuality = false;
  bool _checkedOwnerKyc = false;

  @override
  void initState() {
    super.initState();
    final isAlreadyVerified = widget.property.verificationStatus == PropertyVerificationStatus.verified;
    _checkedTitleDeed = isAlreadyVerified;
    _checkedElectricityBill = isAlreadyVerified;
    _checkedPhysicalVisit = isAlreadyVerified;
    _checkedMediaQuality = isAlreadyVerified;
    _checkedOwnerKyc = isAlreadyVerified;
    _notesCtrl.text = widget.property.verificationNotes ?? 'Field verification completed. All parameters compliant.';
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submitDecision(bool isApproved) {
    if (!isApproved && _notesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide specific rejection reasons in the verification notes.')),
      );
      return;
    }

    final newStatus = isApproved ? PropertyVerificationStatus.verified : PropertyVerificationStatus.rejected;
    _repo.verifyProperty(widget.property.id, newStatus, _notesCtrl.text.trim());

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApproved
              ? 'Property "${widget.property.title}" marked as Homio Verified!'
              : 'Property verification rejected.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allChecksPassed = _checkedTitleDeed && _checkedElectricityBill && _checkedPhysicalVisit && _checkedMediaQuality && _checkedOwnerKyc;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Formal Property Verification Workflow',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MarketplaceStatusBadge.verification(widget.property.verificationStatus, isSmall: true),
                          ],
                        ),
                        Text(
                          widget.property.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Summary Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: AppRadius.sm,
                            child: Image.network(widget.property.coverImageUrl, width: 70, height: 55, fit: BoxFit.cover, errorBuilder: (_, a, b) => const Icon(Icons.villa_rounded)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Owner: ${widget.property.ownerName} (${widget.property.ownerType})',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                                ),
                                Text(
                                  'Location: ${widget.property.locality}, ${widget.property.city} • ${widget.property.carpetAreaSqft} Sq.Ft',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                                Text(
                                  'Rent: ₹${widget.property.monthlyRent.toStringAsFixed(0)}/mo • Security Deposit: ₹${widget.property.securityDeposit.toStringAsFixed(0)}',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Verification Checklist
                    Text(
                      'Mandatory Verification Checklist',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    _checkItem('1. Title Deed / Khata-A Encumbrance Certificate Verified', _checkedTitleDeed, (v) => setState(() => _checkedTitleDeed = v ?? false)),
                    _checkItem('2. Latest Electricity Bill / Municipal Tax Receipt Matches Owner Name', _checkedElectricityBill, (v) => setState(() => _checkedElectricityBill = v ?? false)),
                    _checkItem('3. Physical Site Inspection Conducted by Homio Field Agent', _checkedPhysicalVisit, (v) => setState(() => _checkedPhysicalVisit = v ?? false)),
                    _checkItem('4. HD Photos & 3D Walkthrough Media Authenticated with Zero Watermark Breaches', _checkedMediaQuality, (v) => setState(() => _checkedMediaQuality = v ?? false)),
                    _checkItem('5. Owner Identity (Aadhaar / Passport) & Phone Number KYC Completed', _checkedOwnerKyc, (v) => setState(() => _checkedOwnerKyc = v ?? false)),

                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Verifier Audit Notes / Reason for Decision',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'Enter internal notes, audit trail observations, or rejection details...',
                        isDense: true,
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFCBD5E1))),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Decision Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _submitDecision(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.cancel_rounded, size: 16),
                        label: Text('Reject Verification', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: allChecksPassed ? () => _submitDecision(true) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check_circle_rounded, size: 16),
                        label: Text('Approve & Verify Property', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkItem(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
      value: value,
      activeColor: const Color(0xFF10B981),
      onChanged: onChanged,
    );
  }
}
