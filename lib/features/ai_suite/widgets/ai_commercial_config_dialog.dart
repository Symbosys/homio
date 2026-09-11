import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/ai_suite_repository.dart';
import '../models/ai_suite_models.dart';

class AiCommercialConfigDialog extends StatefulWidget {
  const AiCommercialConfigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const AiCommercialConfigDialog(),
    );
  }

  @override
  State<AiCommercialConfigDialog> createState() => _AiCommercialConfigDialogState();
}

class _AiCommercialConfigDialogState extends State<AiCommercialConfigDialog> {
  final _repo = AiSuiteRepository.instance;
  late double _platformSplit;
  late double _designerSplit;
  late double _doubtFee;
  late double _videoConsultFee;
  late int _roomRenderCredits;
  late int _videoWalkthroughCredits;
  late int _vastuCredits;
  late int _freeQueries;
  final _reasonController = TextEditingController();
  final _actorEmailController = TextEditingController(text: 'operations.admin@homio.in');

  @override
  void initState() {
    super.initState();
    final cfg = _repo.commercialConfig;
    _platformSplit = cfg.platformSharePercent;
    _designerSplit = cfg.designerSharePercent;
    _doubtFee = cfg.doubtQueryFee;
    _videoConsultFee = cfg.videoConsultationFee;
    _roomRenderCredits = cfg.roomRenderCreditCost;
    _videoWalkthroughCredits = cfg.walkthroughVideoCreditCost;
    _vastuCredits = cfg.vastuCreditCost;
    _freeQueries = cfg.freeDoubtQueriesCount;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _actorEmailController.dispose();
    super.dispose();
  }

  void _saveConfig() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please state an operational reason for this commercial update.')),
      );
      return;
    }

    final newConfig = AiCommercialConfig(
      platformSharePercent: _platformSplit,
      designerSharePercent: _designerSplit,
      doubtQueryFee: _doubtFee,
      videoConsultationFee: _videoConsultFee,
      roomRenderCreditCost: _roomRenderCredits,
      walkthroughVideoCreditCost: _videoWalkthroughCredits,
      vastuCreditCost: _vastuCredits,
      freeDoubtQueriesCount: _freeQueries,
    );

    _repo.updateCommercialConfig(
      newConfig,
      actorEmail: _actorEmailController.text.trim(),
      reason: _reasonController.text.trim(),
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF10B981),
        content: Text('Commercial Rules updated and recorded in audit log successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 620, maxHeight: screenHeight * 0.88),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Color(0xFF7C3AED), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commercial Rules & Pricing Engine',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Configure platform vs designer revenue splits, credit costs & free allowances',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),

              // Scrollable Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Revenue Share Slider
                      Text(
                        '1. Platform / Designer Revenue Split Ratio',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Homio Platform: ${_platformSplit.toStringAsFixed(0)}%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ),
                                Text(
                                  'Designer Partner: ${_designerSplit.toStringAsFixed(0)}%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _platformSplit,
                              min: 10,
                              max: 90,
                              divisions: 16,
                              activeColor: const Color(0xFF7C3AED),
                              inactiveColor: const Color(0xFF10B981),
                              onChanged: (val) {
                                setState(() {
                                  _platformSplit = val;
                                  _designerSplit = 100.0 - val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 2. Direct Paid Fees
                      Text(
                        '2. Paid Service Fee Cards',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumericField(
                              label: '30-Min Video Consult Fee (₹)',
                              value: _videoConsultFee.toStringAsFixed(0),
                              onChanged: (val) {
                                final v = double.tryParse(val);
                                if (v != null) _videoConsultFee = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumericField(
                              label: 'Doubt Query Fee (₹)',
                              value: _doubtFee.toStringAsFixed(0),
                              onChanged: (val) {
                                final v = double.tryParse(val);
                                if (v != null) _doubtFee = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 3. AI Tool Credit Costs
                      Text(
                        '3. Credit Consumption Rates',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumericField(
                              label: 'Room Render (Credits)',
                              value: '$_roomRenderCredits',
                              onChanged: (val) {
                                final v = int.tryParse(val);
                                if (v != null) _roomRenderCredits = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumericField(
                              label: 'Walkthrough Video (Credits)',
                              value: '$_videoWalkthroughCredits',
                              onChanged: (val) {
                                final v = int.tryParse(val);
                                if (v != null) _videoWalkthroughCredits = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumericField(
                              label: 'Vastu 16-Zone Audit (Credits)',
                              value: '$_vastuCredits',
                              onChanged: (val) {
                                final v = int.tryParse(val);
                                if (v != null) _vastuCredits = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumericField(
                              label: 'Free Doubt Queries Quota',
                              value: '$_freeQueries',
                              onChanged: (val) {
                                final v = int.tryParse(val);
                                if (v != null) _freeQueries = v;
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 4. Audit Metadata
                      Text(
                        '4. Audit Trail Justification *',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Enter justification for pricing change (e.g. Q3 Commercial Harmonization)',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),
              const SizedBox(height: 16),

              // Action Buttons
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 10,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  ),
                  ElevatedButton(
                    onPressed: _saveConfig,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Save Commercial Rules', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumericField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
