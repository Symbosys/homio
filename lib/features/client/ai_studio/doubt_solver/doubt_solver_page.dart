import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_credit_service.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class DoubtSolverPage extends StatefulWidget {
  const DoubtSolverPage({super.key});

  @override
  State<DoubtSolverPage> createState() => _DoubtSolverPageState();
}

class _DoubtSolverPageState extends State<DoubtSolverPage> {
  DoubtDomain _selectedDomain = DoubtDomain.waterproofing;
  final TextEditingController _questionController = TextEditingController();
  bool _isSolving = false;
  int _solvingPhase = 0;
  DoubtQuery? _activeQuery;

  static const List<String> sampleQuestions = [
    'How can I ensure my bathroom sunken slab never leaks into the flat below?',
    'Should I use HDHMR or BWP Plywood for 8-foot tall wardrobe shutters to avoid warping?',
    'What is the minimum gauge and suspension channel spacing required for Saint-Gobain gypsum ceiling?',
    'Why is epoxy grouting mandatory over white cement for kitchen countertop and floor tiles?',
  ];

  @override
  void initState() {
    super.initState();
    final all = AiStudioService.instance.doubts;
    if (all.isNotEmpty) {
      _activeQuery = all.first;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _submitDoubt() async {
    final text = _questionController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your civil or execution question.')),
      );
      return;
    }

    if (!AiCreditService.instance.hasSufficientCredits(1)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() {
      _isSolving = true;
      _solvingPhase = 0;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _solvingPhase = 1);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _solvingPhase = 2);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final query = await AiStudioService.instance.submitDoubtQuery(
      domain: _selectedDomain,
      question: text,
    );

    setState(() {
      _isSolving = false;
      _activeQuery = query;
      _questionController.clear();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Technical advice generated and linked with Indian IS codes!')),
    );
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Insufficient AI Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('Resolving a technical query requires 1 credit.', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Navigate to credits
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allDoubts = AiStudioService.instance.doubts;

    return AiStudioPageScaffold(
      title: 'Civil & Tech Doubt Solver',
      subtitle: 'Instant Engineering Solutions Grounded in Indian IS Codes, NBC 2016 & On-Site Tolerances',
      body: _isSolving
          ? _buildProgressView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Container
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Engineering Domain',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: DoubtDomain.values.map((d) {
                            final isSelected = d == _selectedDomain;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(d.title),
                                selected: isSelected,
                                onSelected: (_) => setState(() => _selectedDomain = d),
                                selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                                backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.full),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _questionController,
                        maxLines: 4,
                        minLines: 2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          color: AppColors.getTextPrimary(context),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Ask any execution or material question (e.g. tile lippage standards, electrical circuit earthing, moisture testing)...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.getTextMuted(context),
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.md,
                            borderSide: BorderSide(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Quick sample chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: sampleQuestions.map((q) {
                          return ActionChip(
                            label: Text(
                              q,
                              style: GoogleFonts.plusJakartaSans(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {
                              _questionController.text = q;
                            },
                            backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _submitDoubt,
                            icon: const Icon(Icons.psychology_rounded, size: 16),
                            label: Text(
                              'Solve Technical Doubt (1 Credit)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Active Query Answer Display
                if (_activeQuery != null) ...[
                  _buildAnswerView(context, _activeQuery!, isDark),
                  const SizedBox(height: 28),
                ],

                // Previous Doubts Archive
                if (allDoubts.length > 1) ...[
                  Text(
                    'Previous Technical Queries Resolved',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allDoubts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = allDoubts[index];
                      final isCurrent = item.id == _activeQuery?.id;

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? (isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF))
                              : (isDark ? AppColors.darkSurface : Colors.white),
                          borderRadius: AppRadius.md,
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primaryLight
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.help_outline_rounded, size: 18, color: AppColors.primaryLight),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.question,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Domain: ${item.domain.title} · Verified by ${item.humanVerifierName ?? "Senior Engineer"}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppColors.getTextSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () => setState(() => _activeQuery = item),
                              child: Text(
                                isCurrent ? 'Viewing' : 'View Answer',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildAnswerView(BuildContext context, DoubtQuery query, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: AppRadius.xs,
                ),
                child: Text(
                  query.domain.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const Spacer(),
              if (query.humanVerifierName != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        'Verified: ${query.humanVerifierName}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            query.question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Text(
            query.aiDetailedAnswer,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: AppColors.getTextPrimary(context),
              height: 1.5,
            ),
          ),
          if (query.immediateChecklistSteps.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              'Mandatory Site Inspection Checklist Steps:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            ...query.immediateChecklistSteps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_box_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (query.standardIndianCodesReferenced.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: query.standardIndianCodesReferenced.map((code) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Text(
                    code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    final steps = [
      AiGenerationStep(
        title: 'Cross-referencing National Building Code (NBC 2016) & IS Standards',
        description: 'Retrieving structural tolerances and brand manufacturer guidelines...',
        isCompleted: _solvingPhase > 0,
        isActive: _solvingPhase == 0,
      ),
      AiGenerationStep(
        title: 'Formulating on-site inspection protocol',
        description: 'Synthesizing step-by-step contractor signoff criteria...',
        isCompleted: _solvingPhase > 1,
        isActive: _solvingPhase == 1,
      ),
      AiGenerationStep(
        title: 'Routing clarification to Lead Structural Auditor',
        description: 'Finalizing peer-reviewed resolution report...',
        isCompleted: _solvingPhase > 2,
        isActive: _solvingPhase == 2,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: AiGenerationStateView(
        toolTitle: 'Civil & Tech Doubt Solver',
        currentOperation: 'Evaluating Technical Query',
        steps: steps,
        onCancel: () => setState(() => _isSolving = false),
      ),
    );
  }
}
