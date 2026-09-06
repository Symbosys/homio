import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'models.dart';
import 'shared_widgets.dart';

/// Screen 2: AI Room 3D Generator (50/50 Dual View) (/client/ai-room-generator)
class ClientAiRoomGeneratorPage extends StatefulWidget {
  const ClientAiRoomGeneratorPage({super.key});

  @override
  State<ClientAiRoomGeneratorPage> createState() => _ClientAiRoomGeneratorPageState();
}

class _ClientAiRoomGeneratorPageState extends State<ClientAiRoomGeneratorPage> {
  RoomType _selectedRoom = RoomType.livingRoom;
  DesignTheme _selectedTheme = DesignTheme.modernMinimalist;
  LightingCondition _selectedLighting = LightingCondition.warmEvening;
  String _selectedPalette = 'Warm Neutrals (Beige, Oak & Champagne)';
  double _splitRatio = 0.50; // 0.0 to 1.0
  bool _isGenerating = false;
  late final TextEditingController _promptController;

  final List<String> _palettes = [
    'Warm Neutrals (Beige, Oak & Champagne)',
    'Monochrome & Walnut (Charcoal, Greige & Teak)',
    'Earthy Terracotta & Sage Green',
    'High-Contrast Luxe (Black Marquina & Brass)',
  ];

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(
      text: 'Fluted wood accent panel behind 75-inch TV with warm 3000K concealed profile LED and Italian bottochino marble floor',
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _triggerGeneration() {
    if (globalAiWallet.totalTokens < 10) {
      showBuyTokensDialog(context, Theme.of(context).brightness == Brightness.dark);
      return;
    }

    setState(() => _isGenerating = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        globalAiWallet.totalTokens -= 10;
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '4K Photorealistic Render Generated! 5 Tokens (50%) credited to Designer ${globalAiWallet.assignedDesigner}.',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    });
  }

  void _showBoqDialog(bool isDark) {
    final materials = [
      (
        item: 'Action TESA HDHMR Substrate (18mm)',
        qty: '12 Sheets',
        spec: 'Laser edge-banded, high moisture resistance',
        cost: '₹34,800',
      ),
      (
        item: '1.5mm High-Gloss Anti-Scratch Acrylic',
        qty: '8 Sheets',
        spec: 'Senosan Champagne Gloss',
        cost: '₹28,000',
      ),
      (
        item: 'Hafele Sensys 110° Soft-Close Hinges',
        qty: '24 Units',
        spec: 'German tested 200,000 cycle lifetime',
        cost: '₹14,400',
      ),
      (
        item: 'Philips Hue Deep-Cove Linear LED (3000K)',
        qty: '28 Metres',
        spec: 'CRI 90+, driver and aluminum extrusion',
        cost: '₹18,200',
      ),
      (
        item: 'Italian Bottochino Marble Wall Cladding',
        qty: '140 Sq.Ft',
        spec: 'Mirror polish, book-matched veins',
        cost: '₹63,000',
      ),
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
          title: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 10),
              Text(
                'Auto-Generated Material BOQ',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Extracted directly from AI 4K Render for ${_selectedRoom.label} (${_selectedTheme.label}):',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...materials.map((m) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: AppRadius.sm,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.item,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${m.qty} • ${m.spec}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          m.cost,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Estimated Material Cost:',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹1,58,400',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'BOQ successfully attached to Palm Heights Villa 402 Work Package!',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              icon: const Icon(Icons.bookmark_add_rounded, size: 14),
              label: Text('Save to Project BOQ', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            ),
          ],
        );
      },
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
                // 1. Interactive 50/50 Dual-View Visualizer
                _buildDualViewVisualizer(context, isDark, isMobile),

                const SizedBox(height: 20),

                // 3. 50/50 Split Drag Controller
                _buildSplitSliderController(isDark, isMobile),

                const SizedBox(height: 24),

                // 4. Studio Configuration Controls
                _buildConfigControls(context, isDark, isMobile),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDualViewVisualizer(BuildContext context, bool isDark, bool isMobile) {
    final height = isMobile ? 260.0 : 420.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: const Color(0xFF6366F1).withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.lg,
            child: Stack(
              children: [
                // Layer 1: Left Background - Raw Site Photo Simulation
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF334155), Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.photo_camera_back_rounded, color: Colors.white70, size: 13),
                              const SizedBox(width: 5),
                              Text(
                                'BEFORE: RAW SITE PHOTO',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.construction_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${_selectedRoom.label} • Rough Plaster Stage',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Layer 2: Right Foreground - AI 4K Render Simulation (Clipped by _splitRatio)
                Positioned.fill(
                  child: ClipRect(
                    clipper: _SplitViewClipper(_splitRatio),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4338CA),
                            Color(0xFF6D28D9),
                            Color(0xFF3730A3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              ),
                              borderRadius: AppRadius.sm,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  'AFTER: AI 4K RENDER',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Photorealistic 4K • ${_selectedLighting.label}',
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Layer 3: Vertical Split Divider Line
                Positioned(
                  left: totalWidth * _splitRatio - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white,
                  ),
                ),

                // Layer 4: Interactive Drag Handle
                Positioned(
                  left: totalWidth * _splitRatio - 18,
                  top: height / 2 - 18,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.unfold_more_rounded,
                        size: 20,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),

                // Layer 5: Generating Overlay
                if (_isGenerating)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.65),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: Color(0xFF6366F1)),
                            const SizedBox(height: 14),
                            Text(
                              'Diffusion Vision Engine Synthesizing 4K Geometry...',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSplitSliderController(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Text(
            'Raw Photo',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Expanded(
            child: Slider(
              value: _splitRatio,
              min: 0.0,
              max: 1.0,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              onChanged: (v) => setState(() => _splitRatio = v),
            ),
          ),
          Text(
            'AI 4K Render (${(_splitRatio * 100).toInt()}%)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6366F1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigControls(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
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
          Text(
            'Design Configuration & Synthesis Parameters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Room Type
          Text(
            '1. TARGET ROOM ZONE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RoomType.values.map((r) {
              final isSel = _selectedRoom == r;
              return ChoiceChip(
                avatar: Icon(r.icon, size: 14, color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                label: Text(r.label, overflow: TextOverflow.ellipsis),
                selected: isSel,
                onSelected: (v) {
                  if (v) setState(() => _selectedRoom = r);
                },
                selectedColor: const Color(0xFF6366F1),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // 2. Design Theme
          Text(
            '2. ARCHITECTURAL THEME',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DesignTheme.values.map((t) {
              final isSel = _selectedTheme == t;
              return ChoiceChip(
                label: Text(t.label),
                selected: isSel,
                onSelected: (v) {
                  if (v) setState(() => _selectedTheme = t);
                },
                selectedColor: const Color(0xFF6366F1),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // 3. Lighting Condition
          Text(
            '3. LIGHTING ATMOSPHERE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: LightingCondition.values.map((l) {
              final isSel = _selectedLighting == l;
              return ChoiceChip(
                avatar: Icon(l.icon, size: 14, color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                label: Text('${l.label} (${l.desc.split(' ').first})', overflow: TextOverflow.ellipsis),
                selected: isSel,
                onSelected: (v) {
                  if (v) setState(() => _selectedLighting = l);
                },
                selectedColor: const Color(0xFF6366F1),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // 4. Color Palette
          Text(
            '4. CURATED COLOR PALETTE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedPalette,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            items: _palettes.map((p) {
              return DropdownMenuItem<String>(
                value: p,
                child: Text(
                  p,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedPalette = v);
            },
          ),

          const SizedBox(height: 18),

          // 5. Prompt Input
          Text(
            '5. CUSTOM DESIGN INSTRUCTIONS & MATERIAL SPECIFICATIONS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _promptController,
            maxLines: 2,
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              hintText: 'e.g. Add Italian travertine console with brass inlay and warm cove lighting...',
              border: OutlineInputBorder(
                borderRadius: AppRadius.md,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 50-50 Partner Guarantee Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Homio 50-50 Revenue Guarantee: 5 of the 10 tokens used for this render are instantly credited to your Lead Designer (${globalAiWallet.assignedDesigner}).',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons Row
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: _isGenerating ? null : _triggerGeneration,
                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                label: Text(
                  _isGenerating ? 'Synthesizing 4K...' : 'Generate 4K Render (10 Tokens)',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showBoqDialog(isDark),
                icon: const Icon(Icons.receipt_long_rounded, size: 16),
                label: Text(
                  'Auto-Generate BOQ Material List',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SplitViewClipper extends CustomClipper<Rect> {
  final double ratio;

  _SplitViewClipper(this.ratio);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width * ratio, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(_SplitViewClipper oldClipper) => oldClipper.ratio != ratio;
}
