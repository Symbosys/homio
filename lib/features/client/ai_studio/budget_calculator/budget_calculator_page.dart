import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_credit_service.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class BudgetCalculatorPage extends StatefulWidget {
  const BudgetCalculatorPage({super.key});

  @override
  State<BudgetCalculatorPage> createState() => _BudgetCalculatorPageState();
}

class _BudgetCalculatorPageState extends State<BudgetCalculatorPage> {
  late double _carpetAreaSqFt;
  late String _bhkConfig;
  String _selectedPackageId = 'pkg_premium';
  bool _isRecalculating = false;

  final Set<String> _selectedScopes = {
    'Modular Kitchen',
    'Wardrobes & Closets',
    'Living & TV Unit',
    'False Ceiling & Coves',
    'Painting & Wall Finish',
  };

  static const List<String> availableScopes = [
    'Modular Kitchen',
    'Wardrobes & Closets',
    'Living & TV Unit',
    'False Ceiling & Coves',
    'Painting & Wall Finish',
    'Smart Home Automation',
    'Balcony Decking & Planters',
  ];

  @override
  void initState() {
    super.initState();
    final ctx = AiStudioService.instance.projectContext;
    _carpetAreaSqFt = ctx.carpetAreaSqFt;
    _bhkConfig = ctx.unitType;
  }

  void _recalculate() async {
    if (!AiCreditService.instance.hasSufficientCredits(1)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() => _isRecalculating = true);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    AiCreditService.instance.deductCredits(
      amount: 1,
      toolName: 'Budget & Scope Estimator',
      operationTitle: 'Recalculated Budget Scope for ${_carpetAreaSqFt.toInt()} sq.ft',
    );

    AiStudioService.instance.recordGeneration(
      type: AiArtifactType.budgetSpec,
      title: 'Interior Cost Calculation: $_bhkConfig',
      subtitle: '${_carpetAreaSqFt.toInt()} sq.ft · ${_selectedScopes.length} scope scopes evaluated',
      creditsUsed: 1,
      destinationRoute: RouteNames.clientAiBudgetPath,
    );

    setState(() => _isRecalculating = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget estimates and scope packages updated!')),
    );
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Insufficient AI Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('Budget scope estimation requires 1 credit.', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/client/ai-credits');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Top Up Wallet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = AiStudioService.instance.budgetResult;

    return AiStudioPageScaffold(
      title: 'Budget & Scope Estimator',
      subtitle: 'Accurate Cost Modeling Comparing Economy Commercial Ply vs HDHMR Acrylic vs Luxury Veneer',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parameters Card
          _buildParametersCard(context, isDark),
          const SizedBox(height: 24),

          // Savings Opportunities Banner
          _buildSavingsCallout(context, result, isDark),
          const SizedBox(height: 28),

          // Tiered Package Comparisons Table
          Row(
            children: [
              Text(
                'Comprehensive Turnkey Package Comparisons',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const Spacer(),
              if (_isRecalculating)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight),
                ),
            ],
          ),
          const SizedBox(height: 14),
          BudgetBreakdownTable(
            packages: result.packageComparisons,
            selectedPackageId: _selectedPackageId,
            onSelectPackage: (pkg) {
              setState(() => _selectedPackageId = pkg.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${pkg.title} selected as your preferred package.')),
              );
            },
          ),
          const SizedBox(height: 28),

          // Sync to Project Quotation Banner
          _buildSyncQuotationBanner(context, isDark),
        ],
      ),
    );
  }

  Widget _buildParametersCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 20, color: AppColors.primaryLight),
              const SizedBox(width: 10),
              Text(
                'Calibrate Project Scope & Area',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _isRecalculating ? null : _recalculate,
                icon: const Icon(Icons.calculate_rounded, size: 16),
                label: Text(
                  'Recalculate (1 Credit)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  'Carpet Area: ${_carpetAreaSqFt.toInt()} sq.ft',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              ),
              Expanded(
                child: Slider(
                  value: _carpetAreaSqFt,
                  min: 600,
                  max: 4500,
                  divisions: 78,
                  activeColor: AppColors.primaryLight,
                  onChanged: (val) => setState(() => _carpetAreaSqFt = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Included Scope Categories',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.getTextMuted(context),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableScopes.map((scope) {
              final isChecked = _selectedScopes.contains(scope);
              return FilterChip(
                label: Text(scope),
                selected: isChecked,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedScopes.add(scope);
                    } else if (_selectedScopes.length > 1) {
                      _selectedScopes.remove(scope);
                    }
                  });
                },
                selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: isChecked ? AppColors.primaryLight : AppColors.getTextSecondary(context),
                  fontSize: 11.5,
                  fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                side: BorderSide(
                  color: isChecked ? AppColors.primaryLight.withValues(alpha: 0.5) : Colors.transparent,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCallout(BuildContext context, BudgetCalculationResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162520) : const Color(0xFFF0FDF4),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF047857) : const Color(0xFFBBF7D0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.savings_rounded, color: Color(0xFF10B981), size: 22),
              const SizedBox(width: 10),
              Text(
                'AI Identified Cost Optimization Opportunities',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.savingsOpportunities.map((saving) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      saving,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSyncQuotationBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? const Color(0xFF3730A3) : const Color(0xFFC7D2FE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, size: 28, color: AppColors.primaryLight),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to turn this estimate into an official project quotation?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  'Forward these specifications directly to your assigned project estimator for line-by-line contract confirmation.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Scope forwarded to your project manager and quotations dossier.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
            child: Text(
              'Forward to Estimator',
              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
