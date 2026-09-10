import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/compact_ai_suite_actions.dart';
import '../../widgets/vastu_chakra_dial.dart';
import '../../widgets/credit_confirmation_dialog.dart';

class AiVastuConsultantPage extends StatefulWidget {
  const AiVastuConsultantPage({super.key});

  @override
  State<AiVastuConsultantPage> createState() => _AiVastuConsultantPageState();
}

class _AiVastuConsultantPageState extends State<AiVastuConsultantPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form State
  String? _floorPlanUrl;
  VastuDirection _selectedDirection = VastuDirection.northeast;
  double _northDegrees = 42.5;
  String _propertyType = 'Residential Apartment (3BHK)';
  final TextEditingController _plotAreaCtrl = TextEditingController(text: '1850');
  final TextEditingController _builtUpCtrl = TextEditingController(text: '1650');
  final int _bedrooms = 3;
  final int _bathrooms = 3;
  VastuDirection _kitchenDirection = VastuDirection.southeast;
  VastuDirection _entranceDirection = VastuDirection.northeast;
  final TextEditingController _notesCtrl = TextEditingController(
    text: 'Client wants non-demolition remedies for kitchen and master bedroom energy balance.',
  );

  bool _isAnalyzing = false;
  AiVastuReportEntity? _activeReport;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final repo = AiSuiteRepository.instance;
    if (repo.vastuReports.isNotEmpty) {
      _activeReport = repo.vastuReports.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _plotAreaCtrl.dispose();
    _builtUpCtrl.dispose();
    _notesCtrl.dispose();
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
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF111827) : Colors.white,
                  border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Vastu Consultant',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20, child: VerticalDivider(width: 1, thickness: 1)),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF0284C7),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF0284C7),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                        tabs: [
                          const Tab(icon: Icon(Icons.add_chart_rounded, size: 15), text: 'New Analysis'),
                          Tab(icon: const Icon(Icons.assessment_outlined, size: 15), text: 'My Reports (${repo.vastuReports.length})'),
                          Tab(icon: const Icon(Icons.history_rounded, size: 15), text: 'Analysis History (${repo.jobs.where((j) => j.productType == 'Vastu Consultant').length})'),
                        ],
                      ),
                    ),
                    const CompactAiSuiteActions(),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewAnalysisTab(context, isDark, repo),
                    _buildMyReportsTab(context, isDark, repo),
                    _buildAnalysisHistoryTab(context, isDark, repo),
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
  // TAB 1: NEW ANALYSIS WORKFLOW
  // ==========================================================================
  Widget _buildNewAnalysisTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    if (_isAnalyzing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7))),
            const SizedBox(height: 20),
            Text('Computing 16-Zone Spatial Vastu Matrix...', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Calibrating North-East water prana, Agneya fire element & Nairutya earth stability.', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      );
    }

    final cost = repo.commercialConfig.vastuAnalysisCreditCost;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 6.2 Floor Plan Upload & Direction Selector
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.explore_outlined, color: Color(0xFF0284C7), size: 20),
                    const SizedBox(width: 8),
                    Text('1. Floor Plan & North Direction Calibration', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      _floorPlanUrl = 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1000&auto=format&fit=crop&q=80';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sample 3BHK architectural blueprint loaded successfully!'), backgroundColor: Color(0xFF10B981)),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.5), width: 1.5),
                    ),
                    child: _floorPlanUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(_floorPlanUrl!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.file_upload_outlined, color: Color(0xFF0284C7), size: 30),
                              const SizedBox(height: 8),
                              Text('Click to Upload 2D Blueprint / CAD Floor Plan', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: const Color(0xFF0284C7))),
                              const Text('Supports PDF, PNG, JPG blueprints with clear compass markings', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // North Compass Selector
                Text('NORTH ORIENTATION ANGLE (${_northDegrees.toStringAsFixed(1)}°)', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
                const SizedBox(height: 8),
                Slider(
                  value: _northDegrees,
                  min: 0,
                  max: 360,
                  divisions: 72,
                  label: '${_northDegrees.toInt()}°',
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (v) => setState(() => _northDegrees = v),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: VastuDirection.values.map((d) {
                    final isSel = _selectedDirection == d;
                    return ChoiceChip(
                      selected: isSel,
                      label: Text(d.label),
                      selectedColor: const Color(0xFF0284C7),
                      labelStyle: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontSize: 11, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() {
                        _selectedDirection = d;
                        _northDegrees = d.angleDegrees;
                      }),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 6.3 Property Details
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.home_work_outlined, color: Color(0xFF0284C7), size: 20),
                    const SizedBox(width: 8),
                    Text('2. Spatial Attributes & Key Locations', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 260,
                      child: DropdownButtonFormField<String>(
                        initialValue: _propertyType,
                        decoration: const InputDecoration(labelText: 'Property Type', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: 'Residential Apartment (3BHK)', child: Text('Residential Apartment (3BHK)')),
                          DropdownMenuItem(value: 'Independent Villa / Bungalow', child: Text('Independent Villa')),
                          DropdownMenuItem(value: 'Builder Floor Flat', child: Text('Builder Floor')),
                          DropdownMenuItem(value: 'Commercial Office Space', child: Text('Commercial Office')),
                        ],
                        onChanged: (v) => setState(() => _propertyType = v!),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: _plotAreaCtrl,
                        decoration: const InputDecoration(labelText: 'Plot Area (Sq.Ft.)', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: _builtUpCtrl,
                        decoration: const InputDecoration(labelText: 'Built-up (Sq.Ft.)', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<VastuDirection>(
                        initialValue: _entranceDirection,
                        decoration: const InputDecoration(labelText: 'Main Entrance Facing', border: OutlineInputBorder()),
                        items: VastuDirection.values.map((d) => DropdownMenuItem(value: d, child: Text(d.label))).toList(),
                        onChanged: (v) => setState(() => _entranceDirection = v!),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<VastuDirection>(
                        initialValue: _kitchenDirection,
                        decoration: const InputDecoration(labelText: 'Kitchen Zone', border: OutlineInputBorder()),
                        items: VastuDirection.values.map((d) => DropdownMenuItem(value: d, child: Text(d.label))).toList(),
                        onChanged: (v) => setState(() => _kitchenDirection = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Specific Concerns / Family Inhabitant Notes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // CTA with Credit Safety
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cost: $cost Credits • Remaining Balance: ${repo.totalCredits} Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: const Color(0xFF0284C7))),
                    const Text('Generates full 16-zone Chakra report with non-demolition architectural remedies.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await CreditConfirmationDialog.show(
                      context,
                      actionTitle: 'Run 16-Zone Vastu Diagnostic',
                      actionDescription: 'Analyze floor plan North calibration (${_northDegrees.toStringAsFixed(1)}°), zone balance, and generate remedies.',
                      creditsRequired: cost,
                      promptSummary: '$_propertyType • North ${_northDegrees.toInt()}°',
                    );

                    if (!confirmed || !mounted) return;

                    final deducted = repo.deductCredits(
                      amount: cost,
                      title: 'Vastu Analysis - $_propertyType',
                      referenceId: 'VAS-${DateTime.now().millisecondsSinceEpoch}',
                      type: WalletTransactionType.vastuDebit,
                      rupeeEquivalent: cost * 5.0,
                    );

                    if (!deducted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient credits in wallet. Please top up.')),
                        );
                      }
                      return;
                    }

                    setState(() => _isAnalyzing = true);
                    repo.enqueueJob(
                      productType: 'Vastu Consultant',
                      title: '16-Zone Diagnostic - $_propertyType',
                      prompt: 'North ${_northDegrees.toInt()}° floor plan audit',
                      creditsCharged: cost,
                    );

                    await Future.delayed(const Duration(seconds: 2));
                    if (!mounted) return;

                    final newReport = AiVastuReportEntity(
                      id: 'VAS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      projectName: 'DLF Phase 5 Penthouse',
                      propertyType: _propertyType,
                      plotAreaSqFt: double.tryParse(_plotAreaCtrl.text) ?? 1800.0,
                      builtUpAreaSqFt: double.tryParse(_builtUpCtrl.text) ?? 1600.0,
                      totalFloors: 1,
                      bedrooms: _bedrooms,
                      bathrooms: _bathrooms,
                      entranceDirection: _entranceDirection,
                      kitchenDirection: _kitchenDirection,
                      northCalibratedDegrees: _northDegrees,
                      overallScore: 86,
                      floorPlanImageUrl: _floorPlanUrl ?? 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1000&auto=format&fit=crop&q=80',
                      createdAt: DateTime.now(),
                      creditsUsed: cost,
                      positiveObservations: [
                        'Main Entrance in Northeast (Ishanya) welcomes cosmic solar energy and positive prana.',
                        'Master bedroom in Southwest establishes authority and grounding.',
                      ],
                      areasRequiringAttention: [
                        'Pooja room should not share wall with bathroom.',
                      ],
                      zoneRecords: const [
                        VastuZoneRecord(zone: 'North', element: 'Water', currentCondition: 'Clean Foyer', assessment: 'Excellent wealth flow', recommendedAction: 'Add brass vessel with water'),
                        VastuZoneRecord(zone: 'South-East', element: 'Fire', currentCondition: 'Modular Kitchen', assessment: 'Optimal digestive vitality', recommendedAction: 'Face East during cooking'),
                      ],
                      colorRecommendations: const [
                        VastuColorRecommendation(color: 'Light Cream', suggestedRoom: 'Living Room', reason: 'Expands spatial calmness'),
                      ],
                      furniturePlacements: const [
                        VastuFurniturePlacement(furniture: 'Master Bed', recommendedDirection: 'South-West', placement: 'Headboard against South', notes: 'Zero reflection from mirrors'),
                      ],
                      remedies: const [
                        VastuRemedy(issue: 'Bathroom wall adjacent to dining', recommendedRemedy: 'Mount a lead pyramid strip behind skirting', priority: 'Medium', implementationNote: 'Non-demolition immediate correction'),
                      ],
                    );

                    repo.saveVastuReport(newReport);
                    setState(() {
                      _isAnalyzing = false;
                      _activeReport = newReport;
                    });
                    _tabController.animateTo(1);
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: Text('Run Vastu Audit ($cost Credits)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 2: MY REPORTS (STRUCTURED 16-ZONE REPORT)
  // ==========================================================================
  Widget _buildMyReportsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final report = _activeReport ?? (repo.vastuReports.isNotEmpty ? repo.vastuReports.first : null);

    if (report == null) {
      return Center(
        child: Text('No Vastu reports found. Please run a new analysis.', style: GoogleFonts.plusJakartaSans(fontSize: 14)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card with Score Badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0C4A6E), const Color(0xFF075985), const Color(0xFF0B0F19)]
                    : [const Color(0xFFE0F2FE), const Color(0xFFF0F9FF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.projectName, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('${report.propertyType} • Calibrated North: ${report.northCalibratedDegrees.toStringAsFixed(1)}°', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('${report.overallScore}/100', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text('Vastu Harmony', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 16-Zone Rotational Dial + Positive / Attention Breakdown
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isWide ? 5 : 0,
                    child: Container(
                      height: 380,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF111827) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: VastuChakraDial(calibratedDegrees: report.northCalibratedDegrees),
                      ),
                    ),
                  ),
                  if (isWide) const SizedBox(width: 20) else const SizedBox(height: 20),
                  Expanded(
                    flex: isWide ? 6 : 0,
                    child: Column(
                      children: [
                        // Positive Observations
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF111827) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 18),
                                  const SizedBox(width: 8),
                                  Text('Positive Observations', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...report.positiveObservations.map((obs) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                                        Expanded(child: Text(obs, style: const TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Areas Requiring Attention & Non-Demolition Remedies
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF111827) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 18),
                                  const SizedBox(width: 8),
                                  Text('Areas Requiring Attention & Remedies', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFF59E0B))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...report.remedies.map((rem) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Issue: ${rem.issue}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        Text('Remedy: ${rem.recommendedRemedy}', style: const TextStyle(fontSize: 12, color: Color(0xFF0284C7))),
                                        Text('Note: ${rem.implementationNote}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Actions: Export, Send to Project, Book Designer
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vastu Audit Report PDF downloaded successfully!'), backgroundColor: Color(0xFF10B981)),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Download PDF Report'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report linked to Project DLF Phase 5 Penthouse!'), backgroundColor: Color(0xFF10B981)),
                  );
                },
                icon: const Icon(Icons.link_rounded, size: 16),
                label: const Text('Send to Homio Project'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go(RouteNames.aiDesignerCalls),
                icon: const Icon(Icons.video_camera_front_outlined, size: 16),
                label: const Text('Book Designer Review (₹300)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 3: ANALYSIS HISTORY
  // ==========================================================================
  Widget _buildAnalysisHistoryTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final vastuJobs = repo.jobs.where((j) => j.productType == 'Vastu Consultant').toList();

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: vastuJobs.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final job = vastuJobs[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: job.status.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(job.status.icon, color: job.status.color, size: 20),
          ),
          title: Text(job.title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text('Job ID: ${job.id} • Prompt: ${job.prompt}'),
          trailing: Text('${job.creditsCharged} Credits', style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
