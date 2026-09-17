import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/platform_seller_application_model.dart';

class ReviewSellerApplicationDialog extends StatefulWidget {
  final PlatformSellerApplicationModel application;
  final Future<void> Function(bool isApproved, double? commissionRate) onReview;

  const ReviewSellerApplicationDialog({
    super.key,
    required this.application,
    required this.onReview,
  });

  @override
  State<ReviewSellerApplicationDialog> createState() => _ReviewSellerApplicationDialogState();
}

class _ReviewSellerApplicationDialogState extends State<ReviewSellerApplicationDialog> {
  late final TextEditingController _commissionCtrl;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _commissionCtrl = TextEditingController(
      text: (widget.application.commissionRate ?? 10.0).toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _commissionCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleDecision(bool isApproved) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final commission = double.tryParse(_commissionCtrl.text.trim());
      await widget.onReview(isApproved, commission);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = widget.application;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.how_to_reg_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review Seller Application',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Authorize organization to sell in category',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12.5)),
                ),
                const SizedBox(height: 12),
              ],

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _row('Organization', app.organizationName, isDark),
                    const SizedBox(height: 8),
                    _row('Category', app.categoryName, isDark),
                    const SizedBox(height: 8),
                    _row('Marketplace Vertical', app.marketplaceType, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _commissionCtrl,
                label: 'Platform Commission Rate (%)',
                hint: 'e.g. 10.0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => _handleDecision(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text('Reject', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: 'Approve Seller',
                    isLoading: _isLoading,
                    onPressed: () => _handleDecision(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
