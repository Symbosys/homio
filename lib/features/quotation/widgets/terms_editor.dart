import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Terms, conditions, warranty, and exclusions editor with preset loading.
class TermsEditor extends StatefulWidget {
  final String? initialTerms;
  final ValueChanged<String> onTermsChanged;

  const TermsEditor({
    super.key,
    this.initialTerms,
    required this.onTermsChanged,
  });

  @override
  State<TermsEditor> createState() => _TermsEditorState();
}

class _TermsEditorState extends State<TermsEditor> {
  late TextEditingController _termsCtrl;

  static const String standardResidentialTerms =
      '1. Scope & Execution: Prices quoted include supply, fabrication, freight to site, and on-site assembly.\n'
      '2. Payment Terms: 10% advance on signing, 40% prior to factory CNC cutting, 40% upon dispatch, and 10% on handover.\n'
      '3. Warranty: 10-year limited structural warranty on Century/Greenply BWP plywood; 5-year replacement warranty on Blum/Hafele hardware.\n'
      '4. Delivery Timeline: Guaranteed handover within 45 working days following site civil clearance.\n'
      '5. Exclusions: Deep civil demolitions, main electrical meter upgrade, and building society permission fees are client responsibility.';

  static const String turnkeyTerms =
      '1. Complete Turnkey Scope: Covers full design engineering, civil modifications, MEP routing, modular woodwork, painting, and deep cleaning.\n'
      '2. Payment Schedule: Milestone-linked drawdown as per architectural verification certificates.\n'
      '3. Delay Penalty SLA: Delays attributable to Homio compensated at ₹1,000/day capped at 5% contract value.\n'
      '4. Snag Liability: 12-month zero-cost snag rectification warranty post-handover.';

  @override
  void initState() {
    super.initState();
    _termsCtrl = TextEditingController(
      text: widget.initialTerms?.isNotEmpty == true ? widget.initialTerms : standardResidentialTerms,
    );
  }

  @override
  void dispose() {
    _termsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.gavel_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Terms, Warranty & Legal Sign-off',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _termsCtrl.text = standardResidentialTerms;
                      widget.onTermsChanged(standardResidentialTerms);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    child: Text('Standard Residential', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _termsCtrl.text = turnkeyTerms;
                      widget.onTermsChanged(turnkeyTerms);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    ),
                    child: Text('Turnkey Contract', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _termsCtrl,
            maxLines: 8,
            style: GoogleFonts.inter(fontSize: 12, height: 1.4),
            decoration: InputDecoration(
              hintText: 'Enter contractual terms...',
              border: OutlineInputBorder(borderRadius: AppRadius.sm),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: widget.onTermsChanged,
          ),
        ],
      ),
    );
  }
}
