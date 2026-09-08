import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/ai_suite_models.dart';
import '../../models/ai_suite_mock_data.dart';
import '../../widgets/ai_suite_header.dart';
import '../../widgets/before_after_slider.dart';
import '../../widgets/revenue_share_badge.dart';

class AiRoomGeneratorPage extends StatefulWidget {
  const AiRoomGeneratorPage({super.key});

  @override
  State<AiRoomGeneratorPage> createState() => _AiRoomGeneratorPageState();
}

class _AiRoomGeneratorPageState extends State<AiRoomGeneratorPage> {
  final List<AiRoomGenerationItem> _gallery = List.from(AiSuiteMockData.roomGenerations);
  late AiRoomGenerationItem _activeItem;

  // Form Configuration Inputs
  late AiRoomType _selectedRoomType;
  late AiDesignTheme _selectedTheme;
  late AiLightingCondition _selectedLighting;
  late AiColorPalette _selectedColorPalette;
  final TextEditingController _promptController = TextEditingController();

  bool _isGenerating = false;
  int _activeViewTab = 0; // 0: 4K Render (Before/After), 1: 3D Video Walkthrough, 2: Auto-Generated BOQ

  @override
  void initState() {
    super.initState();
    _activeItem = _gallery.first;
    _selectedRoomType = _activeItem.roomType;
    _selectedTheme = _activeItem.theme;
    _selectedLighting = _activeItem.lighting;
    _selectedColorPalette = _activeItem.colorPalette;
    _promptController.text = _activeItem.prompt;
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _triggerGeneration() {
    setState(() => _isGenerating = true);

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final newItem = AiRoomGenerationItem(
        id: 'GEN-${DateTime.now().millisecondsSinceEpoch}',
        title: '${_selectedTheme.label} ${_selectedRoomType.label}',
        roomType: _selectedRoomType,
        theme: _selectedTheme,
        lighting: _selectedLighting,
        colorPalette: _selectedColorPalette,
        prompt: _promptController.text,
        rawPhotoUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
        renderPhotoUrl:
            'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
        videoWalkthroughUrl:
            'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80',
        createdAt: DateTime.now(),
        designerAssigned: 'Pooja Hegde (Senior Interior Architect)',
        renderCost: 100.0,
        boqItems: [
          BoqSpecificationItem(
            category: 'Carpentry & Panelling',
            itemName: '${_selectedTheme.label} Wall Panelling',
            materialSpec: 'HDHMR base with 1.0mm anti-fingerprint fluted finish',
            quantity: '95 Sq.Ft',
            unitCost: 310.0,
            totalCost: 29450.0,
          ),
          BoqSpecificationItem(
            category: 'Lighting & Ambience',
            itemName: '${_selectedLighting.label} Recessed Strip',
            materialSpec: 'Concealed 24V COB linear LED with Meanwell driver',
            quantity: '38 R.Ft',
            unitCost: 230.0,
            totalCost: 8740.0,
          ),
          BoqSpecificationItem(
            category: 'Hardware & Fittings',
            itemName: 'Blum Tandembox Systems',
            materialSpec: '50kg dynamic load capacity with integrated Blumotion',
            quantity: '4 Sets',
            unitCost: 4800.0,
            totalCost: 19200.0,
          ),
        ],
      );

      setState(() {
        _gallery.insert(0, newItem);
        _activeItem = newItem;
        _isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('4K Photorealistic Render & 3D Walkthrough Video Generated Successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1024;

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
                  title: 'Generative AI Room Stylist & 3D Video Walkthrough Studio',
                  subtitle:
                      'Upload raw site photos, configure lighting, themes & colors, and generate 4K photorealistic renders, 3D walkthrough videos, and itemized BOQ specifications with 50-50 designer revenue sharing.',
                  currentRoute: RouteNames.aiRoomGeneratorPath,
                ),

                const SizedBox(height: 24),

                // 2. Main Two-Column Studio Layout
                isMobile
                    ? Column(
                        children: [
                          _buildControlsCard(isDark),
                          const SizedBox(height: 20),
                          _buildOutputsCard(isDark),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Generator Controls (420px)
                          SizedBox(
                            width: 440,
                            child: _buildControlsCard(isDark),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: Outputs Viewport & BOQ (Expanded)
                          Expanded(
                            child: _buildOutputsCard(isDark),
                          ),
                        ],
                      ),

                const SizedBox(height: 32),

                // 3. Recent Generation Gallery Carousel
                _buildGallerySection(isDark),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsCard(bool isDark) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Studio Presets & Config',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const RevenueShareBadge(isCompact: true),
            ],
          ),
          const SizedBox(height: 16),

          // Raw Photo Upload Area
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Raw site image uploaded successfully')),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_rounded, size: 28, color: Color(0xFF7C3AED)),
                  const SizedBox(height: 6),
                  Text(
                    'Upload Raw Site Photo',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Drag & drop JPG, PNG or CAD scan (Up to 25MB)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Room Type Dropdown
          _buildFieldLabel('ROOM CATEGORY'),
          const SizedBox(height: 6),
          DropdownButtonFormField<AiRoomType>(
            initialValue: _selectedRoomType,
            decoration: _inputDecoration(isDark),
            items: AiRoomType.values.map((type) {
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
              if (val != null) setState(() => _selectedRoomType = val);
            },
          ),

          const SizedBox(height: 14),

          // Design Theme Dropdown
          _buildFieldLabel('ARCHITECTURAL DESIGN THEME'),
          const SizedBox(height: 6),
          DropdownButtonFormField<AiDesignTheme>(
            initialValue: _selectedTheme,
            decoration: _inputDecoration(isDark),
            items: AiDesignTheme.values.map((theme) {
              return DropdownMenuItem(
                value: theme,
                child: Text(
                  theme.label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedTheme = val);
            },
          ),

          const SizedBox(height: 14),

          // Lighting Conditions
          _buildFieldLabel('LIGHTING & ILLUMINATION'),
          const SizedBox(height: 6),
          DropdownButtonFormField<AiLightingCondition>(
            initialValue: _selectedLighting,
            decoration: _inputDecoration(isDark),
            items: AiLightingCondition.values.map((light) {
              return DropdownMenuItem(
                value: light,
                child: Row(
                  children: [
                    Icon(light.icon, size: 16, color: const Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    Text(light.label, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedLighting = val);
            },
          ),

          const SizedBox(height: 14),

          // Color Palette Selector
          _buildFieldLabel('COLOR PALETTE & MOOD'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AiColorPalette.values.map((palette) {
              final isSelected = _selectedColorPalette == palette;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: palette.sampleColors.map((c) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 6),
                    Text(palette.label),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedColorPalette = palette);
                },
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Additional Custom Prompts
          _buildFieldLabel('ADDITIONAL SPECIFIC CLIENT REQUIREMENTS'),
          const SizedBox(height: 6),
          TextField(
            controller: _promptController,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'e.g., Add brass fluted panelling, floating TV console, Statuario marble...',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          const SizedBox(height: 20),

          // Generate Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _triggerGeneration,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 20),
              label: Text(
                _isGenerating ? 'Synthesizing 4K Renders & Video...' : 'Generate 4K Render & Video (100 Tokens)',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Cost: 100 Tokens • ₹50 to Platform, ₹50 to Assigned Designer',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputsCard(bool isDark) {
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
          // Outputs View Switcher Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('4K Before/After Slider'),
                    icon: Icon(Icons.compare_rounded, size: 16),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('3D Video Walkthrough'),
                    icon: Icon(Icons.video_library_rounded, size: 16),
                  ),
                  ButtonSegment<int>(
                    value: 2,
                    label: Text('Generated BOQ Specs'),
                    icon: Icon(Icons.receipt_long_rounded, size: 16),
                  ),
                ],
                selected: {_activeViewTab},
                onSelectionChanged: (set) => setState(() => _activeViewTab = set.first),
              ),

              // Export Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('4K Photorealistic Render downloaded in ultra-high res.')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    tooltip: 'Download 4K Render',
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pushed to Client DAM Vault & Execution Task #104.')),
                      );
                    },
                    icon: const Icon(Icons.cloud_sync_rounded),
                    tooltip: 'Push to Execution & DAM Vault',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Tab 0: Interactive Before / After Slider
          if (_activeViewTab == 0) ...[
            BeforeAfterSlider(
              beforeImageUrl: _activeItem.rawPhotoUrl,
              afterImageUrl: _activeItem.renderPhotoUrl,
              initialPosition: _activeItem.splitSliderPosition,
              height: 440,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drag center slider to inspect architectural transformation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  'Rendered for ${_activeItem.designerAssigned}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ],

          // Tab 1: 3D Video Walkthrough Preview Player
          if (_activeViewTab == 1) ...[
            Container(
              height: 440,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      _activeItem.videoWalkthroughUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, size: 48, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '3D Orbital Camera Walkthrough (0:30)',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Downloading 3D Walkthrough MP4 (1080p 60fps)...')),
                            );
                          },
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: const Text('Download MP4 Video'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Tab 2: Auto-Generated Bill of Materials (BOQ)
          if (_activeViewTab == 2) ...[
            Text(
              'AI Parsed Bill of Materials & Carpentry Specification',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                ),
                columns: const [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Material Specification')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Est. Cost')),
                ],
                rows: _activeItem.boqItems.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item.category, style: const TextStyle(fontWeight: FontWeight.w700))),
                      DataCell(Text(item.itemName)),
                      DataCell(Text(item.materialSpec, style: const TextStyle(fontSize: 12))),
                      DataCell(Text(item.quantity)),
                      DataCell(Text('₹${item.totalCost.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGallerySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Studio Generations & Projects',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              '${_gallery.length} Renders in Vault',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.25,
          ),
          itemCount: _gallery.length,
          itemBuilder: (context, i) {
            final item = _gallery[i];
            final isSelected = item.id == _activeItem.id;

            return InkWell(
              onTap: () {
                setState(() {
                  _activeItem = item;
                  _selectedRoomType = item.roomType;
                  _selectedTheme = item.theme;
                  _selectedLighting = item.lighting;
                  _selectedColorPalette = item.colorPalette;
                  _promptController.text = item.prompt;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF7C3AED) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: isSelected ? 2.5 : 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(item.renderPhotoUrl, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.theme.label} • ${item.lighting.label}',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFA5B4FC),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
