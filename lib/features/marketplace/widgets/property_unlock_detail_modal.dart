import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../domain/marketplace_domain_models.dart';
import 'marketplace_status_badge.dart';

class PropertyUnlockDetailModal extends StatelessWidget {
  final PropertyUnlockTransaction transaction;

  const PropertyUnlockDetailModal({super.key, required this.transaction});

  static void show(BuildContext context, PropertyUnlockTransaction tx) {
    showDialog(
      context: context,
      builder: (ctx) => PropertyUnlockDetailModal(transaction: tx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF131722) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(Icons.vpn_key_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Owner Contact Unlock Transaction Dossier',
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        Text(transaction.id, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Property and Customer summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: isDark ? const Color(0xFF262D40) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _row('Property Title', transaction.propertyTitle, isDark),
                    _row('Property ID', transaction.propertyId, isDark),
                    _row('Customer Name', transaction.customerName, isDark),
                    _row('Customer Mobile', transaction.customerMobile, isDark),
                    _row('Customer Email', transaction.customerEmail, isDark),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Financial breakdown
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _row('Configured Unlock Fee', '₹${transaction.unlockFee.toStringAsFixed(2)}', isDark),
                    _row('GST Tax (18%)', '₹${transaction.gstTaxAmount.toStringAsFixed(2)}', isDark),
                    const Divider(),
                    _row('Total Paid Amount', '₹${transaction.totalPaid.toStringAsFixed(2)}', isDark, isBold: true),
                    _row('Gateway Reference', transaction.paymentGatewayRef, isDark),
                    _row('Payment Status', 'Paid & Settled', isDark, badge: MarketplaceStatusBadge.payment(transaction.paymentStatus, isSmall: true)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Dispatch Status
              Text('Multi-Channel Contact Dispatch Audit', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
              const SizedBox(height: 6),
              _dispatchStatus('SMS Gateway', transaction.deliveryStatusSms, Icons.sms_rounded, const Color(0xFF3B82F6), isDark),
              _dispatchStatus('WhatsApp Official Cloud API', transaction.deliveryStatusWhatsApp, Icons.chat_rounded, const Color(0xFF10B981), isDark),
              const SizedBox(height: AppSpacing.md),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Dismiss', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String val, bool isDark, {bool isBold = false, Widget? badge}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF94A3B8))),
          if (badge != null)
            badge
          else
            Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _dispatchStatus(String channel, String status, IconData icon, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.sm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(channel, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600))),
          Text(status, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
