import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Screen 4: AI Furniture & Interior Budget Estimator (/client/ai-budget)
class ClientAiBudgetEstimatorPage extends StatefulWidget {
  const ClientAiBudgetEstimatorPage({super.key});

  @override
  State<ClientAiBudgetEstimatorPage> createState() => _ClientAiBudgetEstimatorPageState();
}

class _ClientAiBudgetEstimatorPageState extends State<ClientAiBudgetEstimatorPage> {
  late final TextEditingController _descriptionController;

  FurnitureCategory _selectedCategory = FurnitureCategory.modularWardrobe;
  SubstrateGrade _selectedSubstrate = SubstrateGrade.hdhmrBoard;
  SurfaceFinish _selectedFinish = SurfaceFinish.acrylicGloss;
  HardwarePackage _selectedHardware = HardwarePackage.germanPremium;

  double _widthFeet = 10.0;
  double _heightFeet = 9.0;
  bool _includeInstallation = true;
  bool _isAnalyzing = false;

  late AiBudgetAnalysisResult _analysisResult;

  final List<BudgetScopePreset> _presets = const [
    BudgetScopePreset(
      id: 'p_full_3bhk',
      title: 'Full 3BHK Modular Interior',
      subtitle: 'Kitchen, 3 Wardrobes, TV Unit & Beds',
      icon: Icons.holiday_village_rounded,
      defaultDescription:
          'Comprehensive 3BHK interior woodwork: Island modular kitchen in HDHMR with 1.5mm acrylic shutters and Blum tandem boxes, 3 floor-to-ceiling sliding wardrobes in BWP marine ply with matte laminate, floating TV console with charcoal fluted paneling and concealed warm 3000K LED profile.',
      defaultCategory: FurnitureCategory.modularWardrobe,
      defaultWidth: 12.0,
      defaultHeight: 9.0,
    ),
    BudgetScopePreset(
      id: 'p_master_bed',
      title: 'Master Bedroom & Walk-in Wardrobe',
      subtitle: 'Floor-to-Ceiling Wardrobe + Headboard',
      icon: Icons.bed_rounded,
      defaultDescription:
          'Master bedroom suite featuring a 10x9 ft full-height wardrobe with tinted reflective glass and champagne aluminum profile, internal sensor lighting, soft-close Sensys hinges, and a king-size hydraulic storage bed frame with fluted wall paneling.',
      defaultCategory: FurnitureCategory.modularWardrobe,
      defaultWidth: 10.0,
      defaultHeight: 9.0,
    ),
    BudgetScopePreset(
      id: 'p_island_kitchen',
      title: 'Island Modular Kitchen',
      subtitle: 'HDHMR Core + Anti-Scratch Acrylic',
      icon: Icons.kitchen_rounded,
      defaultDescription:
          'Contemporary L-shaped modular kitchen with breakfast island: 18mm Action TESA HDHMR carcass, 1.5mm high-gloss anti-scratch acrylic facades, German Hafele soft-close tandem runners, quartz countertop base support, and under-sink BWP waterproof core.',
      defaultCategory: FurnitureCategory.islandKitchen,
      defaultWidth: 14.0,
      defaultHeight: 7.5,
    ),
    BudgetScopePreset(
      id: 'p_tv_console',
      title: 'Luxury TV Wall & Paneling',
      subtitle: 'Walnut Veneer + Brass Trim Console',
      icon: Icons.tv_rounded,
      defaultDescription:
          'Living room architectural entertainment wall: 12x9 ft acoustic fluted wall paneling in natural walnut veneer with satin PU polish, floating 3-drawer low console with brass inlays, and hidden cable management chase.',
      defaultCategory: FurnitureCategory.luxuryTvUnit,
      defaultWidth: 12.0,
      defaultHeight: 8.5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: _presets.first.defaultDescription,
    );
    _computeEstimate();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _applyPreset(BudgetScopePreset preset) {
    setState(() {
      _descriptionController.text = preset.defaultDescription;
      _selectedCategory = preset.defaultCategory;
      _widthFeet = preset.defaultWidth;
      _heightFeet = preset.defaultHeight;
    });
    _runAiAnalysis();
  }

  void _runAiAnalysis() {
    setState(() => _isAnalyzing = true);

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      _computeEstimate();
      setState(() => _isAnalyzing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Budget Analysis computed! Total estimate: ₹${_analysisResult.totalLow.toInt()} – ₹${_analysisResult.totalHigh.toInt()}',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    });
  }

  void _computeEstimate() {
    final areaSqFt = _widthFeet * _heightFeet;

    // Base square footage rates by category
    double baseRatePerSqFt = 1650.0;
    if (_selectedCategory == FurnitureCategory.islandKitchen) baseRatePerSqFt = 2450.0;
    if (_selectedCategory == FurnitureCategory.luxuryTvUnit) baseRatePerSqFt = 1850.0;
    if (_selectedCategory == FurnitureCategory.hydraulicKingBed) baseRatePerSqFt = 2100.0;
    if (_selectedCategory == FurnitureCategory.bathroomVanity) baseRatePerSqFt = 1950.0;

    final rawBaseCost = areaSqFt * baseRatePerSqFt;
    final substrateMultiplier = _selectedSubstrate.costMultiplier;
    final finishMultiplier = _selectedFinish.costMultiplier;
    final hardwareMultiplier = _selectedHardware.multiplier;

    final coreCarpentry = rawBaseCost * 0.45 * substrateMultiplier;
    final surfaceFacade = rawBaseCost * 0.28 * finishMultiplier;
    final hardware = rawBaseCost * 0.15 * hardwareMultiplier;
    final labor = _includeInstallation ? rawBaseCost * 0.12 : 0.0;
    final contingency = (coreCarpentry + surfaceFacade + hardware + labor) * 0.05;

    final calculatedTotal = coreCarpentry + surfaceFacade + hardware + labor + contingency;
    final low = calculatedTotal * 0.96;
    final high = calculatedTotal * 1.05;

    final savings = finishMultiplier > 1.4 ? calculatedTotal * 0.12 : calculatedTotal * 0.08;

    _analysisResult = AiBudgetAnalysisResult(
      estimatedTotal: calculatedTotal,
      totalLow: low,
      totalHigh: high,
      coreCarpentryCost: coreCarpentry,
      surfaceFacadeCost: surfaceFacade,
      hardwareCost: hardware,
      laborCost: labor,
      contingencyCost: contingency,
      valueEngineeringSavings: savings,
      strategicRecommendations: [
        'Specifying 18mm HDHMR (Action TESA) for carcass gives 100% moisture protection at 18% lower cost than full BWP Marine ply.',
        'Using 1.5mm anti-scratch acrylic on external shutters and 0.8mm off-white balancing laminate internally optimizes cost without reducing aesthetics.',
        'German soft-close Sensys hinges ensure 2,00,000 operating cycles and eliminate ₹15,000 door sagging warranty repairs.',
      ],
      aiReasoningSummary:
          'Based on your custom description, the scope specifies high-use architectural joinery. We selected calibrated density substrate and modular hardware to maximize durability while maintaining contractor trade pricing.',
    );
  }

  void _exportQuotation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Full Itemized BOQ Quotation (Villa 402) exported successfully.',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 28.0,
          vertical: 24.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Real-Time Dynamic Price Hero
                _buildLiveEstimateHero(context, isDark, isMobile),
                const SizedBox(height: 22),

                // 2. Natural Language Description & Requirements Intake
                _buildRequirementsIntakeForm(context, isDark, isMobile),
                const SizedBox(height: 24),

                // 3. Technical Form & Itemized Analysis Matrix
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 850;
                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildConfigForm(context, isDark, isMobile),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _buildComparativeMatrix(context, isDark),
                                const SizedBox(height: 18),
                                _buildBrandRecommendations(context, isDark),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _buildConfigForm(context, isDark, isMobile),
                        const SizedBox(height: 20),
                        _buildComparativeMatrix(context, isDark),
                        const SizedBox(height: 18),
                        _buildBrandRecommendations(context, isDark),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveEstimateHero(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  'DIRECT CONTRACTOR PRICING',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Palm Heights Villa 402 • Verified BOQ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Total Estimated Price
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            children: [
              Text(
                '₹${_analysisResult.totalLow.toInt()} – ₹${_analysisResult.totalHigh.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF10B981),
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  borderRadius: AppRadius.full,
                ),
                child: Text(
                  '±4% Variance Accuracy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Itemized cost includes material substrate, German hardware, laser edge-banding, and master carpentry on site.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Distribution bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: (_analysisResult.coreCarpentryCost / _analysisResult.estimatedTotal * 100).toInt(),
                    child: Container(color: const Color(0xFF10B981)),
                  ),
                  Expanded(
                    flex: (_analysisResult.surfaceFacadeCost / _analysisResult.estimatedTotal * 100).toInt(),
                    child: Container(color: const Color(0xFF0284C7)),
                  ),
                  Expanded(
                    flex: (_analysisResult.hardwareCost / _analysisResult.estimatedTotal * 100).toInt(),
                    child: Container(color: const Color(0xFFF59E0B)),
                  ),
                  Expanded(
                    flex: (_analysisResult.laborCost / _analysisResult.estimatedTotal * 100).toInt(),
                    child: Container(color: const Color(0xFF8B5CF6)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Legend
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _buildLegendPill('Core Plywood (45%)', const Color(0xFF10B981)),
              _buildLegendPill('Finish & Facades (28%)', const Color(0xFF0284C7)),
              _buildLegendPill('Hardware (15%)', const Color(0xFFF59E0B)),
              _buildLegendPill('Master Labor (12%)', const Color(0xFF8B5CF6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendPill(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRequirementsIntakeForm(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: AppRadius.sm,
                ),
                child: const Icon(Icons.psychology_rounded, color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe Your Custom Interior Requirements',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'AI decomposes natural language specs into materials, dimensions, and labor pricing',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Multi-line Text Area
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText:
                    'Describe custom specifications e.g., "Modular kitchen in HDHMR with Senosan acrylic finish, tandem drawers with soft close, and quartz counter space..."',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                contentPadding: const EdgeInsets.all(14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Scope Preset Chips
          Text(
            'OR PICK A PRESET ARCHITECTURAL TEMPLATE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF10B981),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presets.map((p) {
              return InkWell(
                onTap: () => _applyPreset(p),
                borderRadius: AppRadius.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(p.icon, size: 14, color: const Color(0xFF10B981)),
                      const SizedBox(width: 6),
                      Text(
                        p.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Action CTA Row
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _runAiAnalysis,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.calculate_rounded, size: 16),
                label: Text(
                  _isAnalyzing ? 'Analyzing Specifications & BOQ...' : 'Analyze Scope & Generate AI Estimate',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _exportQuotation(context),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Export Itemized BOQ (PDF)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigForm(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                'FINE-TUNE SPECIFICATIONS & MATERIALS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Category Dropdown
          Text(
            'Joinery Category:',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<FurnitureCategory>(
                value: _selectedCategory,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onChanged: (val) {
                  setState(() => _selectedCategory = val!);
                  _computeEstimate();
                },
                items: FurnitureCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(cat.icon, size: 16, color: const Color(0xFF10B981)),
                        const SizedBox(width: 8),
                        Text(cat.label),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Substrate Grade
          Text(
            'Substrate Core Material:',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SubstrateGrade>(
                value: _selectedSubstrate,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onChanged: (val) {
                  setState(() => _selectedSubstrate = val!);
                  _computeEstimate();
                },
                items: SubstrateGrade.values.map((sub) {
                  return DropdownMenuItem(
                    value: sub,
                    child: Text('${sub.label} (${sub.costMultiplier}x)'),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Surface Finish
          Text(
            'Surface Finish & Shutter Facade:',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SurfaceFinish>(
                value: _selectedFinish,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onChanged: (val) {
                  setState(() => _selectedFinish = val!);
                  _computeEstimate();
                },
                items: SurfaceFinish.values.map((fin) {
                  return DropdownMenuItem(
                    value: fin,
                    child: Text('${fin.label} • ${fin.brandRef}'),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. Hardware Package
          Text(
            'Hardware & Soft-Close Fitting Package:',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<HardwarePackage>(
                value: _selectedHardware,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onChanged: (val) {
                  setState(() => _selectedHardware = val!);
                  _computeEstimate();
                },
                items: HardwarePackage.values.map((pkg) {
                  return DropdownMenuItem(
                    value: pkg,
                    child: Text(pkg.label),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 5. Dimensions Sliders
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Width: ${_widthFeet.toStringAsFixed(1)} Feet',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Slider(
                      value: _widthFeet,
                      min: 4.0,
                      max: 20.0,
                      divisions: 32,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) {
                        setState(() => _widthFeet = val);
                        _computeEstimate();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Height: ${_heightFeet.toStringAsFixed(1)} Feet',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Slider(
                      value: _heightFeet,
                      min: 3.0,
                      max: 12.0,
                      divisions: 18,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) {
                        setState(() => _heightFeet = val);
                        _computeEstimate();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Installation Checkbox
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _includeInstallation,
            activeTrackColor: const Color(0xFF10B981),
            title: Text(
              'Include Certified Master Installation & Fitting',
              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Includes site leveling, laser alignment & clean-up warranty',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.darkTextMuted),
            ),
            onChanged: (val) {
              setState(() => _includeInstallation = val);
              _computeEstimate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildComparativeMatrix(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.compare_arrows_rounded, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 6),
              Text(
                'SUBSTRATE GRADE BENCHMARK',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: SubstrateGrade.values.map((grade) {
              final isSelected = grade == _selectedSubstrate;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : (isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC)),
                  borderRadius: AppRadius.sm,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grade.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            grade.spec,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.darkTextMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${grade.costMultiplier}x',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandRecommendations(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.tips_and_updates_rounded, size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Text(
                'AI VALUE-ENGINEERING SAVINGS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFF59E0B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              children: [
                const Icon(Icons.savings_outlined, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Potential Savings: ₹${_analysisResult.valueEngineeringSavings.toInt()} with zero cosmetic degradation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...(_analysisResult.strategicRecommendations.map((rec) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      rec,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
        ],
      ),
    );
  }
}
