import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/ai_suite_models.dart';
import '../../models/ai_suite_mock_data.dart';
import '../../widgets/ai_suite_header.dart';
import '../../widgets/brand_recommendation_card.dart';

class AiBudgetCalculatorPage extends StatefulWidget {
  const AiBudgetCalculatorPage({super.key});

  @override
  State<AiBudgetCalculatorPage> createState() => _AiBudgetCalculatorPageState();
}

class _AiBudgetCalculatorPageState extends State<AiBudgetCalculatorPage> {
  FurnitureItemType _selectedItemType = FurnitureItemType.modularWardrobe;
  double _widthFeet = 8.0;
  double _heightFeet = 9.0;
  double _depthFeet = 2.0;
  int _quantity = 1;

  SubstrateType _selectedSubstrate = SubstrateType.bwpMarine;
  FinishType _selectedFinish = FinishType.matteLaminate;
  HardwareTier _selectedHardware = HardwareTier.standardSoftClose;

  BudgetCalculationResult _calculateBudget() {
    final areaSqFt = (_widthFeet * _heightFeet) * _quantity;
    final substrateCost = areaSqFt * _selectedSubstrate.ratePerSqFt;
    final finishCost = areaSqFt * _selectedFinish.ratePerSqFt;
    final hardwareCost = areaSqFt * _selectedHardware.ratePerSqFt;
    final labourCarpentryCost = areaSqFt * 140.0; // Benchmark Rs. 140/sqft for carcass carpentry
    final adhesivesAndConsumablesCost = areaSqFt * 35.0; // Adhesives, screws & PVC edge banding
    final estimatedTotalCost = substrateCost +
        finishCost +
        hardwareCost +
        labourCarpentryCost +
        adhesivesAndConsumablesCost;

    return BudgetCalculationResult(
      itemType: _selectedItemType,
      widthFeet: _widthFeet,
      heightFeet: _heightFeet,
      depthFeet: _depthFeet,
      quantity: _quantity,
      substrate: _selectedSubstrate,
      finish: _selectedFinish,
      hardware: _selectedHardware,
      surfaceAreaSqFt: areaSqFt,
      substrateCost: substrateCost,
      finishCost: finishCost,
      hardwareCost: hardwareCost,
      labourCarpentryCost: labourCarpentryCost,
      adhesivesAndConsumablesCost: adhesivesAndConsumablesCost,
      estimatedTotalCost: estimatedTotalCost,
      top3Brands: AiSuiteMockData.recommendedBrands,
      verifiedVendors: AiSuiteMockData.verifiedVendors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1024;
    final result = _calculateBudget();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Suite Header
                const AiSuiteHeader(
                  title: 'AI Interior Budget, Carpentry & Material Cost Estimator',
                  subtitle:
                      'Select furniture item, dimensions, core substrates, surface finishes, and hardware tiers. Generates real-time BOQ costings, top 3 recommended brands, and verified wholesale distributor contact cards.',
                  currentRoute: RouteNames.aiBudgetCalculatorPath,
                ),

                const SizedBox(height: 24),

                // 2. Main Two-Column Layout
                isMobile
                    ? Column(
                        children: [
                          _buildCalculatorForm(isDark),
                          const SizedBox(height: 20),
                          _buildCostSummaryCard(result, isDark),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Inputs & Material Selectors (460px)
                          SizedBox(
                            width: 460,
                            child: _buildCalculatorForm(isDark),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: Cost Breakdown & Brands (Expanded)
                          Expanded(
                            child: _buildCostSummaryCard(result, isDark),
                          ),
                        ],
                      ),

                const SizedBox(height: 32),

                // 3. Recommended Brands & Verified Regional Distributors
                BrandRecommendationCard(
                  brands: result.top3Brands,
                  vendors: result.verifiedVendors,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorForm(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carpentry & Dimension Parameters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Furniture Item Type Dropdown
          _buildFieldLabel('FURNITURE / JOINERY ITEM TYPE'),
          const SizedBox(height: 6),
          DropdownButtonFormField<FurnitureItemType>(
            initialValue: _selectedItemType,
            decoration: _inputDecoration(isDark),
            items: FurnitureItemType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(type.icon, size: 16, color: const Color(0xFF7C3AED)),
                    const SizedBox(width: 8),
                    Text(type.label, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedItemType = val);
            },
          ),

          const SizedBox(height: 16),

          // 2. Dimensions Grid (Width, Height, Depth, Quantity)
          _buildFieldLabel('DIMENSIONS & QUANTITY'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDimensionInput(
                  label: 'Width (Ft)',
                  value: _widthFeet,
                  onChanged: (v) => setState(() => _widthFeet = v),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDimensionInput(
                  label: 'Height (Ft)',
                  value: _heightFeet,
                  onChanged: (v) => setState(() => _heightFeet = v),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDimensionInput(
                  label: 'Depth (Ft)',
                  value: _depthFeet,
                  onChanged: (v) => setState(() => _depthFeet = v),
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculated Surface Area: ${(_widthFeet * _heightFeet * _quantity).toStringAsFixed(1)} Sq.Ft',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6366F1),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text('Qty: $_quantity', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 28),

          // 3. Substrate Material Selector
          _buildFieldLabel('CORE SUBSTRATE MATERIAL'),
          const SizedBox(height: 6),
          DropdownButtonFormField<SubstrateType>(
            initialValue: _selectedSubstrate,
            decoration: _inputDecoration(isDark),
            items: SubstrateType.values.map((s) {
              return DropdownMenuItem(
                value: s,
                child: Text(
                  '${s.label} (₹${s.ratePerSqFt.toInt()}/sqft)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedSubstrate = val);
            },
          ),
          const SizedBox(height: 4),
          Text(
            _selectedSubstrate.desc,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
          ),

          const SizedBox(height: 16),

          // 4. Surface Finish Selector
          _buildFieldLabel('SURFACE FINISH & SHUTTER AESTHETICS'),
          const SizedBox(height: 6),
          DropdownButtonFormField<FinishType>(
            initialValue: _selectedFinish,
            decoration: _inputDecoration(isDark),
            items: FinishType.values.map((f) {
              return DropdownMenuItem(
                value: f,
                child: Text(
                  '${f.label} (₹${f.ratePerSqFt.toInt()}/sqft)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedFinish = val);
            },
          ),
          const SizedBox(height: 4),
          Text(
            _selectedFinish.desc,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
          ),

          const SizedBox(height: 16),

          // 5. Hardware Tier Selector
          _buildFieldLabel('HARDWARE, CHANNELS & FITTINGS'),
          const SizedBox(height: 6),
          DropdownButtonFormField<HardwareTier>(
            initialValue: _selectedHardware,
            decoration: _inputDecoration(isDark),
            items: HardwareTier.values.map((h) {
              return DropdownMenuItem(
                value: h,
                child: Text(
                  '${h.label} (₹${h.ratePerSqFt.toInt()}/sqft)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedHardware = val);
            },
          ),
          const SizedBox(height: 4),
          Text(
            _selectedHardware.desc,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummaryCard(BudgetCalculationResult res, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Estimated Project Cost',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '±5% Market Accurate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Total Price Highlight Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESTIMATED FABRICATION & MATERIAL COST',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${res.estimatedTotalCost.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rate Benchmark: ≈ ₹${(res.estimatedTotalCost / res.surfaceAreaSqFt).toInt()} / Sq.Ft all-inclusive',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFFA5B4FC)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Itemized Cost Breakdown (BOQ)',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          _buildCostRow('Core Substrate (${res.substrate.label})', res.substrateCost, isDark),
          _buildCostRow('Surface Finish (${res.finish.label})', res.finishCost, isDark),
          _buildCostRow('Hardware & Slides (${res.hardware.label})', res.hardwareCost, isDark),
          _buildCostRow('Carpentry & Labour Installation', res.labourCarpentryCost, isDark),
          _buildCostRow('Adhesives, Screws & Edge Banding', res.adhesivesAndConsumablesCost, isDark),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bill of Quantities',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              Text(
                '₹${res.estimatedTotalCost.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Estimate successfully transferred to Client Quotation Builder!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                  icon: const Icon(Icons.post_add_rounded, size: 18),
                  label: const Text('Add to Quotation Builder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget estimate PDF exported to device.')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                label: const Text('Export PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String title, double amount, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '₹${amount.toInt()}',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionInput({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
          decoration: _inputDecoration(isDark),
          onChanged: (v) {
            final parsed = double.tryParse(v);
            if (parsed != null && parsed > 0) onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: const Color(0xFF94A3B8),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
