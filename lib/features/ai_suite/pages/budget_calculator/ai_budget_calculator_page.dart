import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/ai_suite_tool_header.dart';
import '../../widgets/credit_confirmation_dialog.dart';

class AiBudgetCalculatorPage extends StatefulWidget {
  const AiBudgetCalculatorPage({super.key});

  @override
  State<AiBudgetCalculatorPage> createState() => _AiBudgetCalculatorPageState();
}

class _AiBudgetCalculatorPageState extends State<AiBudgetCalculatorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Multi-step form step (0 to 4)
  int _currentStep = 0;

  // Step 1: Category
  final String _projectType = 'Residential Interior';
  final String _room = 'Master Bedroom';
  String _furnitureType = 'Sliding Wardrobe';

  // Step 2: Dimensions
  final TextEditingController _widthCtrl = TextEditingController(text: '10.0');
  final TextEditingController _heightCtrl = TextEditingController(text: '8.0');
  final TextEditingController _depthCtrl = TextEditingController(text: '2.0');
  final TextEditingController _quantityCtrl = TextEditingController(text: '1');
  String _unit = 'Sq.Ft.';

  // Step 3: Material & Hardware
  String _coreMaterial = 'Plywood';
  final String _thickness = '18mm carcass, 12mm backer, 25mm shelves';
  final String _grade = 'BWP Marine Grade (IS:710)';
  String _finish = 'Laminate';
  String _hardware = 'Soft-close';

  // Step 4: Preferences & Inclusions
  final String _budgetTier = 'Premium Tier';
  bool _includeInstallation = true;
  bool _includeDelivery = true;
  bool _includeLabour = true;
  bool _includeGst = true;
  final TextEditingController _additionalNotesCtrl = TextEditingController(
    text: 'Client prefers German engineered soft-close hardware and anti-fingerprint matte laminates.',
  );

  // Result state
  AiBudgetEstimateEntity? _activeEstimate;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final repo = AiSuiteRepository.instance;
    if (repo.budgetEstimates.isNotEmpty) {
      _activeEstimate = repo.budgetEstimates.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _depthCtrl.dispose();
    _quantityCtrl.dispose();
    _additionalNotesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = AiSuiteRepository.instance;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          return Column(
            children: [
              AiSuiteToolHeader(
                title: 'Budget Calculator',
                tabBar: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFF10B981),
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorColor: const Color(0xFF10B981),
                  indicatorWeight: 2,
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                  tabs: [
                    const Tab(icon: Icon(Icons.calculate_outlined, size: 15), text: 'New Estimate'),
                    Tab(icon: const Icon(Icons.save_outlined, size: 15), text: 'Saved Estimates (${repo.budgetEstimates.length})'),
                    Tab(icon: const Icon(Icons.history_rounded, size: 15), text: 'Estimate History (${repo.jobs.where((j) => j.productType == 'Budget Calculator').length})'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewEstimateTab(context, isDark, repo),
                    _buildSavedEstimatesTab(context, isDark, repo),
                    _buildEstimateHistoryTab(context, isDark, repo),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================================
  // TAB 1: NEW ESTIMATE (STEPPER WORKFLOW)
  // ==========================================================================
  Widget _buildNewEstimateTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    if (_isCalculating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981))),
            const SizedBox(height: 20),
            Text('Computing Material Slabs & Bill of Quantities...', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Fetching latest plywood, laminate & Hafele hardware index prices.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      );
    }

    final cost = repo.commercialConfig.budgetEstimateCreditCost;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stepper Progress Indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStepPill(0, '1. Item'),
                  _buildStepDivider(),
                  _buildStepPill(1, '2. Dimensions'),
                  _buildStepDivider(),
                  _buildStepPill(2, '3. Materials'),
                  _buildStepDivider(),
                  _buildStepPill(3, '4. Preferences'),
                  _buildStepDivider(),
                  _buildStepPill(4, '5. BOQ'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Step Content
          if (_currentStep == 0) _buildStep1Category(context, isDark),
          if (_currentStep == 1) _buildStep2Dimensions(context, isDark),
          if (_currentStep == 2) _buildStep3Materials(context, isDark),
          if (_currentStep == 3) _buildStep4Preferences(context, isDark),
          if (_currentStep == 4) _buildStep5Output(context, isDark, repo),

          const SizedBox(height: 12),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                OutlinedButton.icon(
                  onPressed: () => setState(() => _currentStep--),
                  icon: const Icon(Icons.arrow_back_rounded, size: 14),
                  label: const Text('Previous Step'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), textStyle: const TextStyle(fontSize: 12)),
                )
              else
                const SizedBox.shrink(),
              if (_currentStep < 3)
                ElevatedButton.icon(
                  onPressed: () => setState(() => _currentStep++),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                  label: const Text('Next Step'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: const TextStyle(fontSize: 12)),
                )
              else if (_currentStep == 3)
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await CreditConfirmationDialog.show(
                      context,
                      actionTitle: 'Generate Precision Material BOQ',
                      actionDescription: 'Calculate full itemized material, hardware, labour, finish and GST quotation estimate for $_furnitureType.',
                      creditsRequired: cost,
                      promptSummary: '$_furnitureType • $_coreMaterial • $_finish',
                    );

                    if (!confirmed || !mounted) return;

                    final deducted = repo.deductCredits(
                      amount: cost,
                      title: 'Budget Estimate - $_furnitureType',
                      referenceId: 'EST-${DateTime.now().millisecondsSinceEpoch}',
                      type: WalletTransactionType.budgetDebit,
                      rupeeEquivalent: cost * 5.0,
                    );

                    if (!deducted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient credit balance in wallet. Please top up.')),
                        );
                      }
                      return;
                    }

                    setState(() => _isCalculating = true);
                    repo.enqueueJob(
                      productType: 'Budget Calculator',
                      title: 'BOQ Estimation - $_furnitureType',
                      prompt: '$_projectType • $_furnitureType (${_widthCtrl.text}x${_heightCtrl.text}) in $_coreMaterial $_finish',
                      creditsCharged: cost,
                    );

                    await Future.delayed(const Duration(seconds: 2));
                    if (!mounted) return;

                    final w = double.tryParse(_widthCtrl.text) ?? 10.0;
                    final h = double.tryParse(_heightCtrl.text) ?? 8.0;
                    final area = w * h;
                    final matCost = area * 900.0;
                    final labCost = area * 350.0;
                    const hardCost = 18500.0;
                    final finCost = area * 180.0;
                    const instCost = 7000.0;
                    final subtotal = matCost + labCost + hardCost + finCost + instCost;
                    final gst = _includeGst ? subtotal * 0.18 : 0.0;
                    final total = subtotal + gst;

                    final newEstimate = AiBudgetEstimateEntity(
                      id: 'EST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      title: '$_furnitureType (${w.toInt()}x${h.toInt()} ft)',
                      projectName: 'DLF Phase 5 Penthouse',
                      room: _room,
                      furnitureType: _furnitureType,
                      width: w,
                      height: h,
                      depth: double.tryParse(_depthCtrl.text) ?? 2.0,
                      unit: _unit,
                      coreMaterial: _coreMaterial,
                      thickness: _thickness,
                      finish: _finish,
                      hardware: _hardware,
                      budgetTier: _budgetTier,
                      includeInstallation: _includeInstallation,
                      includeDelivery: _includeDelivery,
                      includeLabour: _includeLabour,
                      includeGst: _includeGst,
                      materialCost: matCost,
                      labourCost: labCost,
                      hardwareCost: hardCost,
                      finishCost: finCost,
                      installationCost: instCost,
                      subtotal: subtotal,
                      gstAmount: gst,
                      totalEstimate: total,
                      createdAt: DateTime.now(),
                      boqItems: [
                        AiBudgetBoqItem(item: 'Carcase Material', specification: '$_coreMaterial $_grade with 0.8mm internal liner', quantity: area, unit: 'Sq.Ft.', estimatedRate: 900.0, estimatedAmount: matCost),
                        AiBudgetBoqItem(item: 'Hardware & Fittings', specification: '$_hardware slide & soft close dampers', quantity: 1.0, unit: 'Set', estimatedRate: hardCost, estimatedAmount: hardCost),
                        AiBudgetBoqItem(item: 'External Surface Finish', specification: '$_finish 1mm with 2mm PVC edgeband', quantity: area, unit: 'Sq.Ft.', estimatedRate: 180.0, estimatedAmount: finCost),
                        AiBudgetBoqItem(item: 'Labour & Carpentry', specification: 'Precision modular joinery on-site fitment', quantity: area, unit: 'Sq.Ft.', estimatedRate: 350.0, estimatedAmount: labCost),
                      ],
                      recommendedBrands: const [
                        RecommendedBrandItem(brand: 'CenturyPly', materialName: 'Club Prime BWP Plywood', qualityTier: 'Tier 1 Marine Grade', priceRange: '₹105 - ₹125 / Sq.Ft.', vendorName: 'Greenply Century Hub Okhla', vendorRating: 4.9, warranty: '30-Year Warranty'),
                        RecommendedBrandItem(brand: 'Hafele India', materialName: 'Slido Classic 50VF Kit', qualityTier: 'German Engineered Hardware', priceRange: '₹16,500 - ₹19,800 / Set', vendorName: 'Hafele Design Studio MG Road', vendorRating: 4.8, warranty: '10-Year Replacement'),
                      ],
                    );

                    repo.saveBudgetEstimate(newEstimate);
                    setState(() {
                      _isCalculating = false;
                      _activeEstimate = newEstimate;
                      _currentStep = 4;
                    });
                  },
                  icon: const Icon(Icons.calculate_rounded, size: 14),
                  label: Text('Compute Estimate ($cost Credits)'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepPill(int stepIndex, String title) {
    final isCurrent = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFF10B981) : (isDone ? const Color(0xFF10B981).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 12, color: Color(0xFF10B981))
                : Text('${stepIndex + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCurrent ? Colors.white : Colors.grey)),
          ),
        ),
        const SizedBox(width: 5),
        Text(title, style: TextStyle(fontSize: 11, fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Container(width: 14, height: 1, color: Colors.grey.withValues(alpha: 0.3), margin: const EdgeInsets.symmetric(horizontal: 6));
  }

  // STEP 1: CATEGORY
  Widget _buildStep1Category(BuildContext context, bool isDark) {
    final items = ['Wardrobe', 'TV Unit', 'Kitchen Cabinet', 'Bed', 'Storage', 'Study Table', 'Vanity', 'Shoe Rack', 'Modular Unit', 'Other'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF111827) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Furniture Category & Item Type', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((it) {
              final isSel = _furnitureType == it || _furnitureType.contains(it);
              return ChoiceChip(
                selected: isSel,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(it),
                selectedColor: const Color(0xFF10B981),
                labelStyle: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontSize: 11, fontWeight: FontWeight.bold),
                onSelected: (_) => setState(() => _furnitureType = it),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // STEP 2: DIMENSIONS
  Widget _buildStep2Dimensions(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF111827) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter Dimensions & Measurement Units', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 560;

              if (isCompact) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(controller: _widthCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Width (Ft)', border: OutlineInputBorder())),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(controller: _heightCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Height (Ft)', border: OutlineInputBorder())),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(controller: _depthCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Depth (Ft)', border: OutlineInputBorder())),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(controller: _quantityCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Quantity', border: OutlineInputBorder())),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _unit,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Unit', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Sq.Ft.', child: Text('Sq.Ft.', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Running Ft.', child: Text('Running Ft.', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Piece/Nos', child: Text('Piece/Nos', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _unit = v!),
                    ),
                  ],
                );
              }

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 110,
                    child: TextFormField(controller: _widthCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Width (Ft)', border: OutlineInputBorder())),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextFormField(controller: _heightCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Height (Ft)', border: OutlineInputBorder())),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextFormField(controller: _depthCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Depth (Ft)', border: OutlineInputBorder())),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextFormField(controller: _quantityCtrl, style: const TextStyle(fontSize: 12), decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Quantity', border: OutlineInputBorder())),
                  ),
                  SizedBox(
                    width: 130,
                    child: DropdownButtonFormField<String>(
                      initialValue: _unit,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Unit', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Sq.Ft.', child: Text('Sq.Ft.', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Running Ft.', child: Text('Running Ft.', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Piece/Nos', child: Text('Piece/Nos', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _unit = v!),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // STEP 3: MATERIALS
  Widget _buildStep3Materials(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF111827) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Core Materials, Grade & Hardware Specifications', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 620;

              if (isCompact) {
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _coreMaterial,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Core Material', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Plywood', child: Text('Plywood (BWP / BWR)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'HDHMR', child: Text('HDHMR (High Moisture Resistance)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'MDF', child: Text('MDF', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Particle Board', child: Text('Particle Board', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Solid Wood', child: Text('Solid Wood (Teak/Sheesham)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _coreMaterial = v!),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _finish,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'External Finish', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Laminate', child: Text('Laminate (1mm Matte/Gloss)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Acrylic', child: Text('Acrylic (Anti-scratch)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Veneer', child: Text('Natural Wood Veneer + PU', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'PU', child: Text('PU Polish / Deco Paint', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Membrane', child: Text('Membrane', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _finish = v!),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _hardware,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Hardware Fitting', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Standard', child: Text('Standard', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Premium', child: Text('Premium', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Soft-close', child: Text('Soft-close (Hafele/Blum)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Custom', child: Text('Custom Luxury', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _hardware = v!),
                    ),
                  ],
                );
              }

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      initialValue: _coreMaterial,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Core Material', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Plywood', child: Text('Plywood (BWP / BWR)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'HDHMR', child: Text('HDHMR (High Moisture Resistance)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'MDF', child: Text('MDF', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Particle Board', child: Text('Particle Board', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Solid Wood', child: Text('Solid Wood (Teak/Sheesham)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _coreMaterial = v!),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      initialValue: _finish,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'External Finish', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Laminate', child: Text('Laminate (1mm Matte/Gloss)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Acrylic', child: Text('Acrylic (Anti-scratch)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Veneer', child: Text('Natural Wood Veneer + PU', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'PU', child: Text('PU Polish / Deco Paint', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Membrane', child: Text('Membrane', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _finish = v!),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      initialValue: _hardware,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Hardware Fitting', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Standard', child: Text('Standard', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Premium', child: Text('Premium', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Soft-close', child: Text('Soft-close (Hafele/Blum)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Custom', child: Text('Custom Luxury', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => setState(() => _hardware = v!),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // STEP 4: PREFERENCES & INCLUSIONS
  Widget _buildStep4Preferences(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF111827) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budget Tier & Commercial Inclusions', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: const Text('Include Installation', style: TextStyle(fontSize: 11)), selected: _includeInstallation, onSelected: (v) => setState(() => _includeInstallation = v)),
              FilterChip(visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: const Text('Include Delivery & Freight', style: TextStyle(fontSize: 11)), selected: _includeDelivery, onSelected: (v) => setState(() => _includeDelivery = v)),
              FilterChip(visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: const Text('Include Carpentry Labour', style: TextStyle(fontSize: 11)), selected: _includeLabour, onSelected: (v) => setState(() => _includeLabour = v)),
              FilterChip(visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: const Text('Include 18% GST', style: TextStyle(fontSize: 11)), selected: _includeGst, onSelected: (v) => setState(() => _includeGst = v)),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _additionalNotesCtrl,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Additional Specifications / Constraints', labelStyle: TextStyle(fontSize: 11), border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  // STEP 5: OUTPUT & BOQ
  Widget _buildStep5Output(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final est = _activeEstimate;
    if (est == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL ESTIMATED INTERIOR COST', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70)),
                    const SizedBox(height: 2),
                    Text('₹${est.totalEstimate.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('${est.furnitureType} • ${est.width.toInt()}x${est.height.toInt()} ft (${est.unit})', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: const Column(
                  children: [
                    Text('ESTIMATION RANGE', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white70)),
                    Text('± 8% Accuracy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Cost Breakdown Cards
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCostMetric('Material Cost', '₹${est.materialCost.toInt()}'),
            _buildCostMetric('Labour Estimate', '₹${est.labourCost.toInt()}'),
            _buildCostMetric('Hardware Estimate', '₹${est.hardwareCost.toInt()}'),
            _buildCostMetric('Finish Estimate', '₹${est.finishCost.toInt()}'),
            _buildCostMetric('Installation & Delivery', '₹${est.installationCost.toInt()}'),
            _buildCostMetric('18% GST', '₹${est.gstAmount.toInt()}'),
          ],
        ),
        const SizedBox(height: 14),

        // 7.6 Itemized BOQ Table
        Text('Itemized Bill of Quantities (BOQ)', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: isDark ? const Color(0xFF111827) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 34,
              dataRowMinHeight: 30,
              dataRowMaxHeight: 34,
              columns: const [
                DataColumn(label: Text('Item', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Specification', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Qty', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Unit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Rate (₹)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Amount (₹)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              ],
              rows: est.boqItems.map((b) {
                return DataRow(
                  cells: [
                    DataCell(Text(b.item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    DataCell(Text(b.specification, style: const TextStyle(fontSize: 11))),
                    DataCell(Text(b.quantity.toInt().toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(Text(b.unit, style: const TextStyle(fontSize: 11))),
                    DataCell(Text('₹${b.estimatedRate.toInt()}', style: const TextStyle(fontSize: 11))),
                    DataCell(Text('₹${b.estimatedAmount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 11))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 7.7 Recommended Brands from Homio Marketplace
        Text('Recommended Homio Marketplace Vendors & Brands', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ...est.recommendedBrands.map((brand) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              leading: const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 18),
              title: Text('${brand.brand} • ${brand.materialName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              subtitle: Text('Vendor: ${brand.vendorName} • Price: ${brand.priceRange} • Rating: ${brand.vendorRating} ★', style: const TextStyle(fontSize: 10.5)),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Direct procurement enquiry sent to ${brand.vendorName}!'), backgroundColor: const Color(0xFF10B981)),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 11)),
                child: const Text('Enquire'),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCostMetric(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 1),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 2: SAVED ESTIMATES
  // ==========================================================================
  Widget _buildSavedEstimatesTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    if (repo.budgetEstimates.isEmpty) {
      return Center(
        child: Text('No saved estimates found.', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: repo.budgetEstimates.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final est = repo.budgetEstimates[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(est.title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800)),
                      Text('${est.projectName} • ${est.coreMaterial} • ${est.finish}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${est.totalEstimate.toInt()}', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activeEstimate = est;
                          _currentStep = 4;
                        });
                        _tabController.animateTo(0);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 11)),
                      child: const Text('View BOQ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 3: ESTIMATE HISTORY
  // ==========================================================================
  Widget _buildEstimateHistoryTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final budgetJobs = repo.jobs.where((j) => j.productType == 'Budget Calculator').toList();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: budgetJobs.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final job = budgetJobs[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: job.status.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
            child: Icon(job.status.icon, color: job.status.color, size: 16),
          ),
          title: Text(job.title, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.bold)),
          subtitle: Text('Job ID: ${job.id} • Prompt: ${job.prompt}', style: const TextStyle(fontSize: 10.5)),
          trailing: Text('${job.creditsCharged} Credits', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        );
      },
    );
  }
}
