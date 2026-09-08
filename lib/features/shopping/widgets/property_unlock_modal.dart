import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/shopping_models.dart';

class PropertyUnlockModal extends StatefulWidget {
  final PropertyListing property;
  final Function(PropertyUnlockRecord) onUnlockSuccess;

  const PropertyUnlockModal({
    super.key,
    required this.property,
    required this.onUnlockSuccess,
  });

  @override
  State<PropertyUnlockModal> createState() => _PropertyUnlockModalState();
}

class _PropertyUnlockModalState extends State<PropertyUnlockModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Vikramaditya Singhal');
  final _phoneController = TextEditingController(text: '+91 98102 99481');
  String _paymentMethod = 'UPI (Instant QR)';
  bool _isProcessing = false;
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final bgColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);
    final textMuted = AppColors.getTextMuted(context);
    final p = widget.property;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 540,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.lock_open_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isUnlocked ? 'Owner Phone Number Unlocked!' : 'Direct Property Owner Unlock Paywall',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Zero Brokerage Direct Deal • Flat ₹500 Access Fee',
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: textSecondary),
                  ),
                ],
              ),
            ),

            // Modal Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _isUnlocked
                    ? _buildUnlockedResult(context, textPrimary, textSecondary, borderColor, bgColor, isDark)
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Property Snapshot
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      p.images.first,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.apartment),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                                        ),
                                        Text(
                                          '${p.societyName}, ${p.city}',
                                          style: TextStyle(fontSize: 11, color: textSecondary),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          p.intent == ListingIntent.rent
                                              ? 'Rent: ₹${(p.monthlyRent / 1000).toStringAsFixed(0)}K / month'
                                              : 'Sale: ₹${(p.salePrice / 10000000).toStringAsFixed(2)} Cr',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Explanatory Value Banner
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 18),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Save 15 days brokerage! Unlocking grants direct 100% verified owner contact, title deed authenticity certificate & WhatsApp chat link.',
                                      style: TextStyle(fontSize: 11, color: Color(0xFF047857), fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              'Your Contact Verification Details',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: _nameController,
                              validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
                              decoration: InputDecoration(
                                labelText: 'Your Full Name *',
                                prefixIcon: const Icon(Icons.person_outline, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              ),
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: _phoneController,
                              validator: (v) => v == null || v.isEmpty ? 'Please enter your phone number' : null,
                              decoration: InputDecoration(
                                labelText: 'Your Mobile Number (Instant SMS delivery) *',
                                prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              'Payment Gateway (Flat ₹500)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            const SizedBox(height: 10),

                            ...['UPI (Instant QR / AutoPay)', 'Credit / Debit Card', 'NetBanking'].map((pm) {
                              final isSelected = _paymentMethod == pm;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: InkWell(
                                  onTap: () => setState(() => _paymentMethod = pm),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF10B981).withValues(alpha: 0.08) : bgColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF10B981) : borderColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                          size: 16,
                                          color: isSelected ? const Color(0xFF10B981) : textMuted,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          pm,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: _isUnlocked
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Access Fee', style: TextStyle(fontSize: 11, color: textMuted)),
                            const Text(
                              '₹500.00',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: _isProcessing ? null : _processUnlock,
                              icon: _isProcessing
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.lock_open_rounded, size: 16),
                              label: Text(
                                _isProcessing ? 'Verifying...' : 'Pay ₹500 & Unlock Owner',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
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

  Widget _buildUnlockedResult(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color bgColor,
    bool isDark,
  ) {
    final p = widget.property;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 50),
        ),
        const SizedBox(height: 14),
        Text(
          'Owner Details Successfully Unlocked!',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Delivered to ${_phoneController.text} via SMS & WhatsApp receipt.',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF10B981),
                    child: Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.ownerName,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        Text(
                          'Direct Property Title Holder',
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: borderColor),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Direct Phone Number', style: TextStyle(fontSize: 12, color: textSecondary)),
                  Text(
                    p.ownerRealPhone,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Direct Email', style: TextStyle(fontSize: 12, color: textSecondary)),
                  Text(
                    p.ownerEmail,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening WhatsApp Chat with ${p.ownerName}...')),
                  );
                },
                icon: const Icon(Icons.chat, size: 16),
                label: const Text('WhatsApp Owner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${p.ownerRealPhone}...')),
                  );
                },
                icon: const Icon(Icons.call, size: 16),
                label: const Text('Call Owner'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _processUnlock() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      final rec = PropertyUnlockRecord(
        id: 'UNL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        propertyId: widget.property.id,
        propertyTitle: widget.property.title,
        unlockedByName: _nameController.text,
        unlockedByPhone: _phoneController.text,
        paidAmount: 500.0,
        unlockedAt: DateTime.now(),
        transactionId: 'PAY-UNL-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        ownerName: widget.property.ownerName,
        ownerPhone: widget.property.ownerRealPhone,
      );

      setState(() {
        _isProcessing = false;
        _isUnlocked = true;
      });

      widget.onUnlockSuccess(rec);
    }
  }
}
