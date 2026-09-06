import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';

/// Screen 3: AI Vastu Shastra Consultant & Energy Diagnostic Engine (/client/ai-vastu)
class ClientAiVastuConsultantPage extends StatefulWidget {
  const ClientAiVastuConsultantPage({super.key});

  @override
  State<ClientAiVastuConsultantPage> createState() => _ClientAiVastuConsultantPageState();
}

class _ClientAiVastuConsultantPageState extends State<ClientAiVastuConsultantPage> {
  late final TextEditingController _descriptionController;

  // Selected directions for key architectural elements
  VastuDirection _entranceDirection = VastuDirection.northEast;
  VastuDirection _masterBedroomDirection = VastuDirection.southWest;
  VastuDirection _kitchenDirection = VastuDirection.southEast;
  VastuDirection _poojaDirection = VastuDirection.northEast;
  VastuDirection _waterTankDirection = VastuDirection.north;
  VastuDirection _toiletDirection = VastuDirection.west;

  bool _isAnalyzing = false;
  int _overallScore = 92;
  String _complianceGrade = 'A+ Auspicious';
  bool _blueprintAttached = true;
  final String _attachedFileName = 'Villa_402_Architectural_FloorPlan_v2.dwg';

  late List<VastuChakraZone> _zones;

  final List<String> _vastuQuickPresets = [
    '3BHK East-Facing Villa with Kitchen in South-East',
    'South-West Master Bedroom with North-East Entrance',
    'Open Island Kitchen in North-East (Agni Imbalance)',
    'Clockwise Staircase in West & Pooja Room in Ishan',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text:
          'Palm Heights Villa 402 is a 2,400 sq.ft duplex. Main entrance opens toward North-East (Ishan corner). Master bedroom is situated in the South-West (Nairutya) with a wooden bed oriented head toward South. The modular kitchen is positioned in South-East (Agni zone). Staircase is located on the West wall turning clockwise. A guest toilet is located in West-North-West.',
    );

    _zones = [
      VastuChakraZone(
        id: 'z_ne',
        zoneName: 'North-East (NE • Ishan)',
        deityRuling: 'Lord Shiva • Clarity & Wisdom',
        element: 'Water (Jal)',
        elementColor: const Color(0xFF0EA5E9),
        degrees: '33.75° – 56.25°',
        score: 96,
        currentUsage: 'Main Grand Entrance & Meditation Sanctuary',
        status: VastuStatus.auspicious,
        doshaDetail: 'Ideal light entrance with zero structural clogs. Divine spiritual influx is maximized.',
        nonDemolitionRemedy: 'Keep zone pristine; install water bowl with fresh white flowers at entrance.',
        isRemedyApplied: true,
      ),
      VastuChakraZone(
        id: 'z_se',
        zoneName: 'South-East (SE • Agni)',
        deityRuling: 'Agni Deva • Cashflow & Health',
        element: 'Fire (Agni)',
        elementColor: const Color(0xFFEF4444),
        degrees: '123.75° – 146.25°',
        score: 94,
        currentUsage: 'Modular Kitchen with Hob facing East',
        status: VastuStatus.auspicious,
        doshaDetail: 'Optimal burner placement activates positive metabolic digestion & steady financial flow.',
        nonDemolitionRemedy: 'Affix natural red jasper pyramid under kitchen hob baseboard.',
        isRemedyApplied: true,
      ),
      VastuChakraZone(
        id: 'z_sw',
        zoneName: 'South-West (SW • Nairutya)',
        deityRuling: 'Pithru • Stability & Mastery',
        element: 'Earth (Prithvi)',
        elementColor: const Color(0xFFF59E0B),
        degrees: '213.75° – 236.25°',
        score: 88,
        currentUsage: 'Master Bedroom Suite & Wardrobe Vault',
        status: VastuStatus.auspicious,
        doshaDetail: 'Heaviest structural weight positioned in SW provides stability and leadership authority.',
        nonDemolitionRemedy: 'Position brass energy helix in south-west skirting behind wardrobe.',
        isRemedyApplied: false,
      ),
      VastuChakraZone(
        id: 'z_wnw',
        zoneName: 'West-North-West (WNW)',
        deityRuling: 'Varuna • Detoxification & Relief',
        element: 'Space (Akash)',
        elementColor: const Color(0xFF8B5CF6),
        degrees: '281.25° – 303.75°',
        score: 82,
        currentUsage: 'Guest Powder Room & Drainage Shaft',
        status: VastuStatus.minorDosha,
        doshaDetail: 'Drainage pipe creates minor emotional lethargy if left unchecked across monsoons.',
        nonDemolitionRemedy: 'Install a 3-inch wide stainless-steel energy barrier strip around toilet base.',
        isRemedyApplied: false,
      ),
      VastuChakraZone(
        id: 'z_n',
        zoneName: 'North (N • Kuber)',
        deityRuling: 'Lord Kuber • Wealth & Growth',
        element: 'Water (Jal)',
        elementColor: const Color(0xFF10B981),
        degrees: '348.75° – 11.25°',
        score: 92,
        currentUsage: 'Living Room Bay Window & Balcony',
        status: VastuStatus.auspicious,
        doshaDetail: 'Open view toward North draws commercial growth and financial liquidity.',
        nonDemolitionRemedy: 'Place emerald green live indoor plant (money plant) in ceramic planter.',
        isRemedyApplied: true,
      ),
      VastuChakraZone(
        id: 'z_w',
        zoneName: 'West (W • Varuna)',
        deityRuling: 'Varuna Deva • Profits & Retention',
        element: 'Space (Akash)',
        elementColor: const Color(0xFF64748B),
        degrees: '258.75° – 281.25°',
        score: 90,
        currentUsage: 'Staircase Clad in Teak & Storage',
        status: VastuStatus.auspicious,
        doshaDetail: 'Clockwise climbing staircase on West wall stabilizes business profits.',
        nonDemolitionRemedy: 'Maintain warm 3000K riser illumination on all stair treads.',
        isRemedyApplied: true,
      ),
    ];
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _runVastuAnalysis() {
    setState(() => _isAnalyzing = true);

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      int calculatedScore = 85;

      // Calculate score based on directional alignments
      if (_entranceDirection == VastuDirection.northEast || _entranceDirection == VastuDirection.north) {
        calculatedScore += 5;
      }
      if (_kitchenDirection == VastuDirection.southEast) {
        calculatedScore += 5;
      } else if (_kitchenDirection == VastuDirection.northEast) {
        calculatedScore -= 8; // Agni in water zone
      }
      if (_masterBedroomDirection == VastuDirection.southWest) {
        calculatedScore += 5;
      }
      if (_poojaDirection == VastuDirection.northEast) {
        calculatedScore += 4;
      }

      // Add points for applied remedies
      final appliedCount = _zones.where((z) => z.isRemedyApplied).length;
      calculatedScore += (appliedCount * 2);
      if (calculatedScore > 100) calculatedScore = 98;

      String grade = 'A+ Auspicious';
      if (calculatedScore < 80) grade = 'B Vedic Remediable';
      if (calculatedScore < 70) grade = 'C Critical Dosha';

      setState(() {
        _overallScore = calculatedScore;
        _complianceGrade = grade;
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vedic spatial diagnostic complete! MahaVastu™ Compliance: $_overallScore/100 ($grade)',
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

  void _toggleRemedy(VastuChakraZone zone) {
    setState(() {
      zone.isRemedyApplied = !zone.isRemedyApplied;
      if (zone.isRemedyApplied) {
        zone.status = VastuStatus.remedied;
        zone.score = (zone.score + 10).clamp(0, 100);
        _overallScore = (_overallScore + 2).clamp(0, 100);
      } else {
        zone.status = VastuStatus.minorDosha;
        zone.score = (zone.score - 10).clamp(0, 100);
        _overallScore = (_overallScore - 2).clamp(0, 100);
      }
    });
  }

  void _downloadCertificate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        content: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'MahaVastu™ Verified Audit Certificate (Palm Heights Villa 402) generated as PDF.',
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
                // 1. Executive Scorecard Hero
                _buildScorecardHero(context, isDark, isMobile),
                const SizedBox(height: 22),

                // 2. Comprehensive Property Description & Spatial Intake Form
                _buildSpatialIntakeForm(context, isDark, isMobile),
                const SizedBox(height: 24),

                // 3. Five Elements Balance Meter (Pancha Tattva)
                _buildElementsMeter(isDark, isMobile),
                const SizedBox(height: 24),

                // 4. Section Title: 16-Zone Diagnostic Mandala
                Row(
                  children: [
                    const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '16-Zone Vastu Energy Diagnostic & Non-Demolition Remedies',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 15 : 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 5. Zone Diagnostic Cards Grid
                _buildZoneGrid(isDark, isMobile),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScorecardHero(BuildContext context, bool isDark, bool isMobile) {
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
              // Radial Score Display
              Container(
                width: isMobile ? 74 : 88,
                height: isMobile ? 74 : 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.md,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_overallScore',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 26 : 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      '/ 100 VEDIC',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            _complianceGrade,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Villa 402 • 2,400 sq.ft Duplex',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'MahaVastu™ Architectural Diagnostic Suite',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100% Non-Demolition Metallic & Elemental Harmonic Corrections',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _downloadCertificate(context),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Download Vastu Audit Certificate (PDF)'),
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
                onPressed: _runVastuAnalysis,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981)),
                      )
                    : const Icon(Icons.refresh_rounded, size: 16),
                label: Text(_isAnalyzing ? 'Analyzing Spatial Energy...' : 'Re-Analyze Vastu Energy'),
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

  Widget _buildSpatialIntakeForm(BuildContext context, bool isDark, bool isMobile) {
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
                child: const Icon(Icons.edit_note_rounded, color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe Your Property & Spatial Layout',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'AI parses rooms, orientations, architectural constraints & resident issues',
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
                    'Describe your floor plan e.g., "Main door faces East, master bedroom is in South-West with attached bath in West. Kitchen is in South-East..."',
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

          // Quick Presets Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _vastuQuickPresets.map((preset) {
              return ActionChip(
                onPressed: () {
                  _descriptionController.text = preset;
                  _runVastuAnalysis();
                },
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                label: Text(
                  preset,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Structured Directional Selectors Matrix
          Text(
            'KEY SPATIAL ELEMENT DIRECTIONS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF10B981),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;
              final colCount = isDesktop ? 3 : (constraints.maxWidth > 480 ? 2 : 1);

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDirectionDropdown(
                    label: 'Main Entrance Door',
                    icon: Icons.door_front_door_rounded,
                    value: _entranceDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _entranceDirection = val!),
                  ),
                  _buildDirectionDropdown(
                    label: 'Master Bedroom',
                    icon: Icons.bed_rounded,
                    value: _masterBedroomDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _masterBedroomDirection = val!),
                  ),
                  _buildDirectionDropdown(
                    label: 'Kitchen / Hob Fireplace',
                    icon: Icons.kitchen_rounded,
                    value: _kitchenDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _kitchenDirection = val!),
                  ),
                  _buildDirectionDropdown(
                    label: 'Pooja / Prayer Sanctuary',
                    icon: Icons.temple_hindu_rounded,
                    value: _poojaDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _poojaDirection = val!),
                  ),
                  _buildDirectionDropdown(
                    label: 'Water Sump / Reservoir',
                    icon: Icons.water_drop_rounded,
                    value: _waterTankDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _waterTankDirection = val!),
                  ),
                  _buildDirectionDropdown(
                    label: 'Toilets / Drainage Shaft',
                    icon: Icons.wash_rounded,
                    value: _toiletDirection,
                    width: isDesktop ? (constraints.maxWidth - 24) / 3 : (constraints.maxWidth - 12) / colCount,
                    isDark: isDark,
                    onChanged: (val) => setState(() => _toiletDirection = val!),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // Blueprint Attachment Simulation Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file_rounded, size: 18, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _blueprintAttached
                        ? 'Floor Plan CAD Attached: $_attachedFileName (Vedic grid verified)'
                        : 'No Floor Plan Attached (Analyzing based on description)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _blueprintAttached = !_blueprintAttached);
                  },
                  icon: Icon(_blueprintAttached ? Icons.close_rounded : Icons.upload_file_rounded, size: 14),
                  label: Text(_blueprintAttached ? 'Detach' : 'Upload CAD'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Primary Analysis Trigger CTA
          ElevatedButton.icon(
            onPressed: _runVastuAnalysis,
            icon: _isAnalyzing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(
              _isAnalyzing ? 'Scanning 16 Vedic Energy Zones...' : 'Analyze Vastu Energy & Compute Remedies',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionDropdown({
    required String label,
    required IconData icon,
    required VastuDirection value,
    required double width,
    required bool isDark,
    required ValueChanged<VastuDirection?> onChanged,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: const Color(0xFF10B981)),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : Colors.white,
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VastuDirection>(
                value: value,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onChanged: onChanged,
                items: VastuDirection.values.map((dir) {
                  return DropdownMenuItem<VastuDirection>(
                    value: dir,
                    child: Row(
                      children: [
                        Icon(dir.icon, size: 14, color: const Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dir.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementsMeter(bool isDark, bool isMobile) {
    final elements = [
      (name: 'Water (Jal • Clarity)', value: 0.95, color: const Color(0xFF0EA5E9), zone: 'North & NE'),
      (name: 'Air (Vayu • Growth)', value: 0.88, color: const Color(0xFF10B981), zone: 'East & ESE'),
      (name: 'Fire (Agni • Cashflow)', value: 0.74, color: const Color(0xFFEF4444), zone: 'South-East'),
      (name: 'Earth (Prithvi • Stability)', value: 0.92, color: const Color(0xFFF59E0B), zone: 'South-West'),
      (name: 'Space (Akash • Expansion)', value: 0.90, color: const Color(0xFF8B5CF6), zone: 'West & NW'),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grain_rounded, color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 8),
              Text(
                'PANCHA TATTVA (FIVE ELEMENTS) HARMONIC BALANCE',
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
            children: elements.map((elem) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: isMobile ? 120 : 160,
                      child: Text(
                        elem.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: elem.value,
                          minHeight: 8,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(elem.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${(elem.value * 100).toInt()}%',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: elem.color,
                        ),
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

  Widget _buildZoneGrid(bool isDark, bool isMobile) {
    return Column(
      children: _zones.map((zone) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildZoneCard(zone, isDark, isMobile),
        );
      }).toList(),
    );
  }

  Widget _buildZoneCard(VastuChakraZone zone, bool isDark, bool isMobile) {
    final statusColor = zone.status.color;

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: zone.isRemedyApplied
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: zone.elementColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(Icons.explore_rounded, color: zone.elementColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          zone.zoneName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: AppRadius.full,
                          ),
                          child: Text(
                            zone.status.label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${zone.deityRuling} • Angular Range: ${zone.degrees}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${zone.score}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: zone.score > 85 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              children: [
                const Icon(Icons.home_work_outlined, size: 14, color: Color(0xFF10B981)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Current Spatial Use: ${zone.currentUsage}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            zone.doshaDetail,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Remedy Row
          Row(
            children: [
              const Icon(Icons.healing_rounded, size: 15, color: Color(0xFF10B981)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Non-Demolition Remedy: ${zone.nonDemolitionRemedy}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _toggleRemedy(zone),
                icon: Icon(
                  zone.isRemedyApplied ? Icons.check_circle_rounded : Icons.add_task_rounded,
                  size: 14,
                ),
                label: Text(zone.isRemedyApplied ? 'Applied' : 'Apply Remedy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: zone.isRemedyApplied ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
