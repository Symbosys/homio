import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_domain_models.dart';
import '../data/marketplace_repository.dart';

class MarketplaceConfigDialog extends StatefulWidget {
  final MarketplaceConfig config;

  const MarketplaceConfigDialog({
    super.key,
    required this.config,
  });

  static Future<void> show(BuildContext context, MarketplaceConfig config) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => MarketplaceConfigDialog(config: config),
    );
  }

  @override
  State<MarketplaceConfigDialog> createState() => _MarketplaceConfigDialogState();
}

class _MarketplaceConfigDialogState extends State<MarketplaceConfigDialog> {
  final _repo = MarketplaceRepository();

  late final TextEditingController _unlockFeeCtrl;
  late final TextEditingController _gstRateCtrl;
  late final TextEditingController _validityDaysCtrl;
  late final TextEditingController _expiryHoursCtrl;
  late final TextEditingController _maxDownloadsCtrl;
  late final TextEditingController _commRateCtrl;
  late final TextEditingController _slaDaysCtrl;
  late final TextEditingController _cancellationHoursCtrl;
  late final TextEditingController _supportEmailCtrl;
  late final TextEditingController _supportPhoneCtrl;

  late bool _notifyOwner;
  late bool _notifyCustomerWa;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.config;
    _unlockFeeCtrl = TextEditingController(text: c.propertyUnlockFee.toStringAsFixed(0));
    _gstRateCtrl = TextEditingController(text: c.propertyUnlockGstRate.toStringAsFixed(1));
    _validityDaysCtrl = TextEditingController(text: c.propertyUnlockValidityDays.toString());
    _expiryHoursCtrl = TextEditingController(text: c.digitalDownloadLinkExpiryHours.toString());
    _maxDownloadsCtrl = TextEditingController(text: c.digitalMaxDownloads.toString());
    _commRateCtrl = TextEditingController(text: c.defaultAffiliateCommissionRate.toStringAsFixed(1));
    _slaDaysCtrl = TextEditingController(text: c.materialDeliverySlaDays.toString());
    _cancellationHoursCtrl = TextEditingController(text: c.maxOrderCancellationHours.toString());
    _supportEmailCtrl = TextEditingController(text: c.supportContactEmail);
    _supportPhoneCtrl = TextEditingController(text: c.supportContactPhone);

    _notifyOwner = c.notifyOwnerOnUnlock;
    _notifyCustomerWa = c.notifyCustomerViaWhatsapp;
  }

  @override
  void dispose() {
    _unlockFeeCtrl.dispose();
    _gstRateCtrl.dispose();
    _validityDaysCtrl.dispose();
    _expiryHoursCtrl.dispose();
    _maxDownloadsCtrl.dispose();
    _commRateCtrl.dispose();
    _slaDaysCtrl.dispose();
    _cancellationHoursCtrl.dispose();
    _supportEmailCtrl.dispose();
    _supportPhoneCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    setState(() => _isSaving = true);

    final updated = widget.config.copyWith(
      propertyUnlockFee: double.tryParse(_unlockFeeCtrl.text.trim()) ?? widget.config.propertyUnlockFee,
      propertyUnlockGstRate: double.tryParse(_gstRateCtrl.text.trim()) ?? widget.config.propertyUnlockGstRate,
      propertyUnlockValidityDays: int.tryParse(_validityDaysCtrl.text.trim()) ?? widget.config.propertyUnlockValidityDays,
      notifyOwnerOnUnlock: _notifyOwner,
      notifyCustomerViaWhatsapp: _notifyCustomerWa,
      digitalDownloadLinkExpiryHours: int.tryParse(_expiryHoursCtrl.text.trim()) ?? widget.config.digitalDownloadLinkExpiryHours,
      digitalMaxDownloads: int.tryParse(_maxDownloadsCtrl.text.trim()) ?? widget.config.digitalMaxDownloads,
      defaultAffiliateCommissionRate: double.tryParse(_commRateCtrl.text.trim()) ?? widget.config.defaultAffiliateCommissionRate,
      materialDeliverySlaDays: int.tryParse(_slaDaysCtrl.text.trim()) ?? widget.config.materialDeliverySlaDays,
      maxOrderCancellationHours: int.tryParse(_cancellationHoursCtrl.text.trim()) ?? widget.config.maxOrderCancellationHours,
      supportContactEmail: _supportEmailCtrl.text.trim(),
      supportContactPhone: _supportPhoneCtrl.text.trim(),
    );

    _repo.updateConfig(updated);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marketplace operational parameters updated successfully.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF131722) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: Container(
        width: 780,
        constraints: const BoxConstraints(maxHeight: 740),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marketplace Operational Rules & Configuration',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Configure platform paywall thresholds, link expiry, commission rates, and SLAs',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, size: 20, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Property Paywall
                    _buildSectionHeader('1. Verified Property Discovery & Contact Unlock Paywall', Icons.lock_outline_rounded, textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Contact Unlock Fee (₹)',
                            helperText: 'Standard direct lead access fee',
                            controller: _unlockFeeCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'GST Rate (%)',
                            helperText: 'Applicable statutory GST (e.g. 18%)',
                            controller: _gstRateCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'Access Validity (Days)',
                            helperText: 'Days customer can view contact info',
                            controller: _validityDaysCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _notifyOwner,
                      onChanged: (val) => setState(() => _notifyOwner = val ?? false),
                      title: Text(
                        'Auto-notify Property Owner when contact is unlocked by buyer/tenant',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      subtitle: Text(
                        'Sends SMS and push alert with buyer CRM ID and phone number',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textSecondary),
                      ),
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _notifyCustomerWa,
                      onChanged: (val) => setState(() => _notifyCustomerWa = val ?? false),
                      title: Text(
                        'Dispatch Verified Owner Contact Card via WhatsApp immediately',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      subtitle: Text(
                        'Triggers Homio WhatsApp Business API with contact details & property location pin',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textSecondary),
                      ),
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    Divider(height: 32, color: borderColor),

                    // Section 2: Digital Store Delivery Rules
                    _buildSectionHeader('2. Digital Asset Delivery & Expiration Rules', Icons.file_download_outlined, textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Download Link Expiry (Hours)',
                            helperText: 'Signed token lifespan (default 48h)',
                            controller: _expiryHoursCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'Max Download Attempts',
                            helperText: 'Limit downloads per license purchase',
                            controller: _maxDownloadsCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 32, color: borderColor),

                    // Section 3: Commercial & Fulfillment SLAs
                    _buildSectionHeader('3. Commercial Terms & Fulfillment SLAs', Icons.local_shipping_outlined, textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Default Affiliate Commission (%)',
                            helperText: 'Applied to unconfigured decor partners',
                            controller: _commRateCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'Material Delivery SLA (Days)',
                            helperText: 'Guaranteed vendor dispatch window',
                            controller: _slaDaysCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'Max Cancellation Window (Hours)',
                            helperText: 'Time window for customer self-cancellation',
                            controller: _cancellationHoursCtrl,
                            keyboardType: TextInputType.number,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 32, color: borderColor),

                    // Section 4: Support Escalation Contacts
                    _buildSectionHeader('4. Marketplace Escalation Desk', Icons.headset_mic_outlined, textPrimary),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Support Desk Email',
                            helperText: 'Printed on order receipts and unlock invoices',
                            controller: _supportEmailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildTextField(
                            label: 'Support Desk Phone / Hotline',
                            helperText: 'Operations dispatch desk hotline',
                            controller: _supportPhoneCtrl,
                            keyboardType: TextInputType.phone,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: isDark ? const Color(0xFF0E131F) : const Color(0xFFF8FAFC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      side: BorderSide(color: borderColor),
                    ),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textSecondary)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    icon: _isSaving
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                    label: Text(
                      _isSaving ? 'Updating...' : 'Save Parameters',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textPrimary) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String helperText,
    required TextEditingController controller,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final borderColor = isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0);
    final fillBg = isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textPrimary),
          decoration: InputDecoration(
            isDense: true,
            hintText: label,
            helperText: helperText,
            helperStyle: GoogleFonts.plusJakartaSans(fontSize: 11, color: textSecondary),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
            border: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: AppRadius.sm, borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            filled: true,
            fillColor: fillBg,
          ),
        ),
      ],
    );
  }
}
