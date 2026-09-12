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

class VastuPage extends StatefulWidget {
  const VastuPage({super.key});

  @override
  State<VastuPage> createState() => _VastuPageState();
}

class _VastuPageState extends State<VastuPage> {
  bool _isAuditing = false;
  int _auditPhase = 0;

  void _runNewAudit() async {
    if (!AiCreditService.instance.hasSufficientCredits(2)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() {
      _isAuditing = true;
      _auditPhase = 0;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _auditPhase = 1);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _auditPhase = 2);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    AiCreditService.instance.deductCredits(
      amount: 2,
      toolName: 'AI Vastu Consultant',
      operationTitle: '8-Direction Floorplan Vastu Audit',
    );

    AiStudioService.instance.recordGeneration(
      type: AiArtifactType.vastuAudit,
      title: 'Floorplan Vastu Audit Refresh',
      subtitle: 'Score 86/100 · 8 Directions harmonized with non-destructive remedies',
      creditsUsed: 2,
      destinationRoute: RouteNames.clientAiVastuPath,
    );

    setState(() {
      _isAuditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vastu energy mandala diagnostic successfully completed!')),
    );
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Insufficient AI Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('Vastu floor plan audit requires 2 credits. Top up your wallet anytime.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13)),
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
    final report = AiStudioService.instance.vastuReport;

    return AiStudioPageScaffold(
      title: 'AI Vastu Consultant',
      subtitle: '8-Direction Cosmic Energy Audit, Floorplan Chakra Scoring & Non-Destructive Vedic Remedies',
      body: _isAuditing
          ? _buildProgressView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score & Diagnostic Header Banner
                _buildDiagnosticOverview(context, report, isDark),
                const SizedBox(height: 24),

                // 8-Direction Mandala Visualizer
                VastuCompassVisualizer(
                  zones: report.zones,
                  onZoneSelected: (zone) => _showZoneDetailsDialog(context, zone),
                ),
                const SizedBox(height: 24),

                // Top Non-Demolition Priority Recommendations
                _buildPriorityRemediesSection(context, report, isDark),
                const SizedBox(height: 24),

                // Human Vastu Architect Consultation Callout
                _buildConsultationBanner(context, isDark),
              ],
            ),
    );
  }

  Widget _buildDiagnosticOverview(BuildContext context, VastuAnalysisReport report, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          final scoreWidget = Container(
            width: isNarrow ? double.infinity : 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2843) : const Color(0xFFEFF6FF),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isDark ? const Color(0xFF2E3D5C) : const Color(0xFFBFDBFE),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${report.overallScore}/100',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF10B981),
                  ),
                ),
                Text(
                  'Vastu Harmony Score',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextMuted(context),
                  ),
                ),
              ],
            ),
          );

          final detailsWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      report.chakraLevel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: _runNewAudit,
                    icon: const Icon(Icons.refresh_rounded, size: 14),
                    label: Text('Re-Audit (2 cr)', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                report.propertyTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Primary Notice: ${report.primaryDosha}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All identified imbalances are 100% remediable without structural demolition using elemental remedies (brass strips, crystal prisms, and sacred flora).',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              children: [
                scoreWidget,
                const SizedBox(height: 16),
                detailsWidget,
              ],
            );
          }

          return Row(
            children: [
              scoreWidget,
              const SizedBox(width: 20),
              Expanded(child: detailsWidget),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriorityRemediesSection(BuildContext context, VastuAnalysisReport report, bool isDark) {
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
              const Icon(Icons.auto_fix_high_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Text(
                'Top Non-Destructive Vedic Remedies',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...report.topPriorityRecommendations.map((remedy) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      remedy,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextPrimary(context),
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

  Widget _buildConsultationBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? const Color(0xFF3730A3) : const Color(0xFFC7D2FE),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.video_call_rounded, size: 28, color: AppColors.primaryLight),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book 1-on-1 Vedic Vastu Architect Consultation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  'Connect with certified architectural consultants to review complex floor plans before structural execution signoff.',
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
            onPressed: () => context.go(RouteNames.clientDesignerCallPath),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
            child: Text(
              'Schedule Call',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showZoneDetailsDialog(BuildContext context, VastuZoneResult zone) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = Color(zone.status.colorHex);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                zone.direction,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.xs,
              ),
              child: Text(
                '${zone.compliancePercent}% Harmony',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Governing Element: ${zone.governingElement}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Assigned Room: ${zone.currentRoomPlacement}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                  borderRadius: AppRadius.md,
                ),
                child: Text(
                  zone.energyAnalysis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Prescribed Non-Destructive Vedic Remedies:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              ...zone.nonDestructiveRemedies.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.getTextPrimary(context)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    final steps = [
      AiGenerationStep(
        title: 'Calibrating magnetic compass bearings & building orientation',
        description: 'Mapping true North and floor plan rotation coordinates...',
        isCompleted: _auditPhase > 0,
        isActive: _auditPhase == 0,
      ),
      AiGenerationStep(
        title: 'Evaluating 8 directional chakras & Brahmasthan core',
        description: 'Checking Ishanya (NE), Agneya (SE), Nairutya (SW), Vayavya (NW)...',
        isCompleted: _auditPhase > 1,
        isActive: _auditPhase == 1,
      ),
      AiGenerationStep(
        title: 'Synthesizing non-destructive Vedic remedy protocols',
        description: 'Compiling element rebalancing items and compliance report...',
        isCompleted: _auditPhase > 2,
        isActive: _auditPhase == 2,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: AiGenerationStateView(
        toolTitle: 'AI Vastu Consultant',
        currentOperation: 'Auditing 8-Direction Floorplan Energy',
        steps: steps,
        onCancel: () => setState(() => _isAuditing = false),
      ),
    );
  }
}
