import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/ai_suite_header.dart';
import '../../widgets/doubt_chat_interface.dart';

class AiDoubtSolverPage extends StatefulWidget {
  const AiDoubtSolverPage({super.key});

  @override
  State<AiDoubtSolverPage> createState() => _AiDoubtSolverPageState();
}

class _AiDoubtSolverPageState extends State<AiDoubtSolverPage> {
  int _activeViewMode = 0; // 0: Live Expert Doubt Assistant, 1: Common Mistakes & Money-Saved Playbook

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  title: 'AI Expert Doubt Solver & Site Snag Troubleshooting Core',
                  subtitle:
                      'Trained on actual wholesale rate cards, CPWD/IS specifications, and common site snag diagnostics. First 3 technical questions are completely FREE, subsequent queries just ₹50 to save Lakhs of Rupees on costly site errors.',
                  currentRoute: RouteNames.aiDoubtSolverPath,
                ),

                const SizedBox(height: 20),

                // Sub-View Switcher
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text('AI Doubt Solver Chat (3 Free + ₹50)'),
                      icon: Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text('Top 5 Expensive Site Mistakes Saved'),
                      icon: Icon(Icons.shield_rounded, size: 16),
                    ),
                  ],
                  selected: {_activeViewMode},
                  onSelectionChanged: (set) => setState(() => _activeViewMode = set.first),
                ),

                const SizedBox(height: 20),

                // View 0: Chat Interface
                if (_activeViewMode == 0) ...[
                  SizedBox(
                    height: 720,
                    child: const DoubtChatInterface(),
                  ),
                ],

                // View 1: Top Mistakes Playbook & Savings
                if (_activeViewMode == 1) ...[
                  _buildMistakesPlaybook(isDark),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMistakesPlaybook(bool isDark) {
    final mistakes = [
      (
        'Fake BWP Marine Plywood in Kitchen Wet Carcasses',
        'Commercial MR ply disguised with face veneer absorbs ambient moisture, leading to carcass swelling and termite attacks within 18 months.',
        'Always demand IS:710 ISI license numbers and perform the 72-hour boiling water test on delivery samples.',
        '₹1,40,000 Saved on complete modular kitchen re-fabrication',
        const Color(0xFFEF4444),
      ),
      (
        'Missing Polymer Membrane Behind Bathroom Wall Tiles',
        'Relying purely on cement tile adhesive without 2 coats of flexible polymer waterproofing slurry causes capillary seepage into adjoining bedroom wardrobes.',
        'Apply continuous elastomeric membrane up to 7ft shower height and 48hr ponding test.',
        '₹95,000 Saved on peeling paint, ruined wardrobe backs & mold remediation',
        const Color(0xFFF59E0B),
      ),
      (
        'Sub-standard False Ceiling Perimeter Channel Spacing',
        'Contractors placing intermediate GI channels at 36" instead of 24" center-to-center causes gypsum board sagging and hairline seam cracks.',
        'Enforce 0.50mm B.M.T. GI channels at maximum 24" spacing with butterfly anchor fasteners.',
        '₹60,000 Saved on false ceiling re-framing and scaffolding',
        const Color(0xFF8B5CF6),
      ),
      (
        'Incompatible Edge Banding Adhesive Temperature',
        'Manual application of 2mm PVC edge banding with standard rubber adhesive fails in heat, causing acrylic shutters to peel off at the seams.',
        'Mandate hot-melt EVA/PUR adhesive applied via automated edge bander at 190°C.',
        '₹45,000 Saved on shutter replacement and edge finishing',
        const Color(0xFF10B981),
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mistakes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final m = mistakes[i];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: m.$5.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.warning_amber_rounded, size: 18, color: m.$5),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Mistake #${i + 1}: ${m.$1}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m.$4,
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
              Text(
                'The Costly Error:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFEF4444),
                ),
              ),
              Text(
                m.$2,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI Prevention Protocol:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
              Text(
                m.$3,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
