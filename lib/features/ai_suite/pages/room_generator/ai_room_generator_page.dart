import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/ai_suite_models.dart';
import '../../data/ai_suite_repository.dart';
import '../../widgets/compact_ai_suite_actions.dart';
import '../../widgets/before_after_slider.dart';
import '../../widgets/credit_confirmation_dialog.dart';

class AiRoomGeneratorPage extends StatefulWidget {
  const AiRoomGeneratorPage({super.key});

  @override
  State<AiRoomGeneratorPage> createState() => _AiRoomGeneratorPageState();
}

class _AiRoomGeneratorPageState extends State<AiRoomGeneratorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Configuration Form State
  String? _uploadedImagePath;
  AiRoomType _selectedRoomType = AiRoomType.livingRoom;
  String _customRoomType = '';
  AiLightingMode _selectedLighting = AiLightingMode.warm;
  AiDesignStyle _selectedStyle = AiDesignStyle.luxury;
  AiColorPalette _selectedPalette = AiColorPalette.neutral;
  final TextEditingController _customRequirementsCtrl = TextEditingController(
    text: 'Keep the existing marble floor, add concealed linear warm LEDs, fluted wood TV wall and luxury brass accents.',
  );
  final TextEditingController _roomNameCtrl = TextEditingController(text: 'Grand Living & Dining Lounge');
  final TextEditingController _areaCtrl = TextEditingController(text: '340');
  final TextEditingController _widthCtrl = TextEditingController(text: '20');
  final TextEditingController _lengthCtrl = TextEditingController(text: '17');
  final TextEditingController _heightCtrl = TextEditingController(text: '10.5');
  String _selectedProject = 'DLF Phase 5 Penthouse';

  // Furniture & Material preferences
  final String _seatingPref = '3-Seater with Chaise Lounge';
  final String _storagePref = 'Concealed Handleless Storage';
  final String _flooringPref = 'Italian Statuario Marble';
  final String _wallFinishPref = 'Fluted Wood & Champagne Brass Trims';

  // Advanced AI toggles
  bool _preserveLayout = true;
  bool _preserveFurniture = false;
  bool _changeFlooring = false;
  bool _addFalseCeiling = true;
  bool _addLighting = true;
  bool _addPlants = true;
  bool _addArtwork = true;
  bool _addConcealedStorage = true;
  bool _showAdvancedSettings = false;

  // Processing State Machine
  bool _isGenerating = false;
  String _generationStage = 'Preparing';
  double _generationProgress = 0.0;

  // Selected Result View Mode (Slider, Side-by-Side, Toggle)
  String _comparisonMode = 'Slider';
  AiRoomDesignEntity? _currentResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final repo = AiSuiteRepository.instance;
    if (repo.roomDesigns.isNotEmpty) {
      _currentResult = repo.roomDesigns.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customRequirementsCtrl.dispose();
    _roomNameCtrl.dispose();
    _areaCtrl.dispose();
    _widthCtrl.dispose();
    _lengthCtrl.dispose();
    _heightCtrl.dispose();
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
                        'Room Designer',
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
                        labelColor: const Color(0xFF7C3AED),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF7C3AED),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                        tabs: [
                          const Tab(icon: Icon(Icons.add_photo_alternate_outlined, size: 15), text: 'New Design'),
                          Tab(icon: const Icon(Icons.bookmark_outline_rounded, size: 15), text: 'My Designs (${repo.roomDesigns.length})'),
                          const Tab(icon: Icon(Icons.view_in_ar_rounded, size: 15), text: 'Generated Results'),
                          Tab(icon: const Icon(Icons.history_rounded, size: 15), text: 'Design History (${repo.jobs.where((j) => j.productType == 'Room Designer').length})'),
                        ],
                      ),
                    ),
                    const CompactAiSuiteActions(),
                  ],
                ),
              ),

              // 3. TAB VIEWS
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewDesignTab(context, isDark, repo),
                    _buildMyDesignsTab(context, isDark, repo),
                    _buildGeneratedResultsTab(context, isDark, repo),
                    _buildDesignHistoryTab(context, isDark, repo),
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
  // TAB 1: NEW DESIGN WORKFLOW
  // ==========================================================================
  Widget _buildNewDesignTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    if (_isGenerating) {
      return _buildGeneratingState(context, isDark);
    }

    final isMobile = MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guidance banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF7C3AED), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Upload room photo or select an existing project room. Supported formats: JPG, PNG, WEBP (Up to 25MB). Use wide-angle lens with natural light for optimal neural depth estimation.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5.2 Room Image Upload & Project Information
          _buildUploadSection(context, isDark),
          const SizedBox(height: 12),

          // 5.3 Configuration: Room Type, Lighting, Theme, Palette
          _buildConfigurationSection(context, isDark),
          const SizedBox(height: 12),

          // 5.4 Advanced AI Controls (Expandable)
          _buildAdvancedSettingsSection(context, isDark),
          const SizedBox(height: 14),

          // 5.5 Generation Summary & Credit Safety CTA
          _buildGenerationSummary(context, isDark, repo),
        ],
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.cloud_upload_outlined, color: Color(0xFF7C3AED), size: 16),
              const SizedBox(width: 8),
              Text(
                '1. Room Image & Project Context',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Drag & drop dropzone
          InkWell(
            onTap: () {
              setState(() {
                _uploadedImagePath = 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=1200&auto=format&fit=crop&q=80';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Room photo loaded successfully with high-resolution depth map!'), backgroundColor: Color(0xFF10B981)),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _uploadedImagePath != null ? const Color(0xFF10B981) : const Color(0xFF7C3AED).withValues(alpha: 0.5),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: _uploadedImagePath != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(
                            _uploadedImagePath!,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(height: 110, color: Colors.black12, child: const Icon(Icons.image)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Color(0xFF10B981), size: 12),
                                    SizedBox(width: 4),
                                    Text('Room Photo Ready (1920x1080)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => setState(() => _uploadedImagePath = null),
                                icon: const Icon(Icons.delete_outline, size: 12),
                                label: const Text('Replace'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), textStyle: const TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFF7C3AED).withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF7C3AED), size: 20),
                        ),
                        const SizedBox(height: 6),
                        Text('Click to Browse or Drag & Drop Room Photo', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF7C3AED))),
                        const SizedBox(height: 2),
                        Text('Supports wide shots of living rooms, bedrooms, kitchens & empty shells', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Project & Room metadata fields
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedProject,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Homio Project Link', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'DLF Phase 5 Penthouse', child: Text('DLF Phase 5 Penthouse', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Prestige Lakeside Habitat', child: Text('Prestige Lakeside', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Lodha Bellissimo', child: Text('Lodha Bellissimo', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Direct Personal Session', child: Text('Direct Personal Session', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) => setState(() => _selectedProject = v!),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _roomNameCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Room Name / Label', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: _areaCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Area (Sq.Ft.)', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 75,
                child: TextFormField(
                  controller: _widthCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'W (Ft)', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 75,
                child: TextFormField(
                  controller: _lengthCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'L (Ft)', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 75,
                child: TextFormField(
                  controller: _heightCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'H (Ft)', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.tune_rounded, color: Color(0xFF7C3AED), size: 16),
              const SizedBox(width: 8),
              Text(
                '2. Architectural Style & Design Parameters',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 14 Room Types Dropdown
          Text('ROOM TYPE (14 TYPES)', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          DropdownButtonFormField<AiRoomType>(
            initialValue: _selectedRoomType,
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder()),
            items: AiRoomType.values.map((rt) {
              return DropdownMenuItem(
                value: rt,
                child: Row(
                  children: [
                    Icon(rt.icon, size: 14, color: const Color(0xFF7C3AED)),
                    const SizedBox(width: 6),
                    Text(rt.label, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedRoomType = v!),
          ),
          if (_selectedRoomType == AiRoomType.other) ...[
            const SizedBox(height: 6),
            TextFormField(
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), labelText: 'Specify Custom Room Type', border: OutlineInputBorder()),
              onChanged: (v) => _customRoomType = v,
            ),
          ],
          const SizedBox(height: 10),

          // 7 Lighting Modes
          Text('LIGHTING MOOD', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AiLightingMode.values.map((lm) {
              final isSel = _selectedLighting == lm;
              return ChoiceChip(
                selected: isSel,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                avatar: Icon(lm.icon, size: 12, color: isSel ? Colors.white : const Color(0xFF7C3AED)),
                label: Text(lm.label),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontSize: 10.5, fontWeight: FontWeight.bold),
                onSelected: (_) => setState(() => _selectedLighting = lm),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // 12 Design Styles
          Text('DESIGN STYLE & THEME (12 PRESETS)', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AiDesignStyle.values.map((st) {
              final isSel = _selectedStyle == st;
              return ChoiceChip(
                selected: isSel,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(st.label),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontSize: 10.5, fontWeight: FontWeight.bold),
                onSelected: (_) => setState(() => _selectedStyle = st),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // 7 Color Palettes
          Text('COLOR PALETTE', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AiColorPalette.values.map((cp) {
              final isSel = _selectedPalette == cp;
              return ChoiceChip(
                selected: isSel,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...cp.sampleColors.map((c) => Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 3), decoration: BoxDecoration(color: c, shape: BoxShape.circle))),
                    Text(cp.label),
                  ],
                ),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)), fontSize: 10.5, fontWeight: FontWeight.bold),
                onSelected: (_) => setState(() => _selectedPalette = cp),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Custom Requirements Prompt Textarea
          Text('CUSTOM REQUIREMENTS & INSTRUCTIONS', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          TextFormField(
            controller: _customRequirementsCtrl,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Keep the existing sofa, add concealed storage, use warm lighting and create a premium modern look.',
              hintStyle: TextStyle(fontSize: 11),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsSection(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        initiallyExpanded: _showAdvancedSettings,
        onExpansionChanged: (v) => setState(() => _showAdvancedSettings = v),
        leading: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF7C3AED), size: 18),
        title: Text(
          'Advanced AI Controls & Spatial Modifications',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
        subtitle: const Text('Control structural layout preservation, modular additions & false ceiling', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _buildToggle('Preserve existing layout', _preserveLayout, (v) => setState(() => _preserveLayout = v)),
                _buildToggle('Preserve existing furniture', _preserveFurniture, (v) => setState(() => _preserveFurniture = v)),
                _buildToggle('Change flooring material', _changeFlooring, (v) => setState(() => _changeFlooring = v)),
                _buildToggle('Add false ceiling & cove', _addFalseCeiling, (v) => setState(() => _addFalseCeiling = v)),
                _buildToggle('Add accent lighting & tracks', _addLighting, (v) => setState(() => _addLighting = v)),
                _buildToggle('Add biophilic indoor plants', _addPlants, (v) => setState(() => _addPlants = v)),
                _buildToggle('Add gallery artwork & mirrors', _addArtwork, (v) => setState(() => _addArtwork = v)),
                _buildToggle('Add concealed handleless storage', _addConcealedStorage, (v) => setState(() => _addConcealedStorage = v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.75,
          child: Switch.adaptive(value: value, onChanged: onChanged, activeTrackColor: const Color(0xFF7C3AED)),
        ),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildGenerationSummary(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final cost = repo.commercialConfig.roomDesignCreditCost;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generation Summary & Cost Audit',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF7C3AED)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                child: Text('SAFE CREDIT GATEWAY', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildSummaryItem('ROOM', _selectedRoomType.label),
              _buildSummaryItem('STYLE', _selectedStyle.label),
              _buildSummaryItem('LIGHTING', _selectedLighting.label),
              _buildSummaryItem('PALETTE', _selectedPalette.label),
              _buildSummaryItem('ESTIMATED AI COST', '$cost Credits'),
              _buildSummaryItem('AVAILABLE BALANCE', '${repo.totalCredits} Credits'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (_uploadedImagePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload a room photo first or click the dropzone to use the sample room.')),
                    );
                    return;
                  }

                  // Safe Credit Confirmation Modal
                  final confirmed = await CreditConfirmationDialog.show(
                    context,
                    actionTitle: 'Generate 4K Photorealistic Room Redesign',
                    actionDescription: 'Run neural rendering with ${_selectedStyle.label} style, ${_selectedLighting.label} lighting, and preliminary material BOQ calculation.',
                    creditsRequired: cost,
                    promptSummary: '${_selectedRoomType.label} • ${_selectedStyle.label} • ${_selectedLighting.label}',
                  );

                  if (!confirmed || !context.mounted) return;

                  final deducted = repo.deductCredits(
                    amount: cost,
                    title: 'Room Redesign - ${_roomNameCtrl.text}',
                    referenceId: 'DES-${DateTime.now().millisecondsSinceEpoch}',
                    type: WalletTransactionType.roomDebit,
                    rupeeEquivalent: cost * 5.0,
                  );

                  if (!deducted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient credit balance. Please top up your wallet.')),
                    );
                    return;
                  }

                  // Trigger asynchronous generation
                  setState(() {
                    _isGenerating = true;
                    _generationStage = 'Preparing Room Canvas';
                    _generationProgress = 0.15;
                  });

                  repo.enqueueJob(
                    productType: 'Room Designer',
                    title: '${_selectedStyle.label} ${_selectedRoomType.label}',
                    prompt: _customRequirementsCtrl.text,
                    creditsCharged: cost,
                  );

                  // Simulate stage transitions
                  await Future.delayed(const Duration(milliseconds: 700));
                  if (!mounted) return;
                  setState(() {
                    _generationStage = 'Analysing Structural Depth & Lighting Mesh';
                    _generationProgress = 0.45;
                  });

                  await Future.delayed(const Duration(milliseconds: 800));
                  if (!mounted) return;
                  setState(() {
                    _generationStage = 'Applying ${_selectedStyle.label} Aesthetics & Textures';
                    _generationProgress = 0.75;
                  });

                  await Future.delayed(const Duration(milliseconds: 800));
                  if (!mounted) return;
                  setState(() {
                    _generationStage = 'Finalizing 4K Neural Render & Material Specs';
                    _generationProgress = 0.95;
                  });

                  await Future.delayed(const Duration(milliseconds: 500));
                  if (!mounted) return;

                  final newDesign = AiRoomDesignEntity(
                    id: 'DES-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    title: '${_selectedStyle.label} ${_roomNameCtrl.text}',
                    projectName: _selectedProject,
                    roomType: _selectedRoomType,
                    customRoomType: _customRoomType,
                    lighting: _selectedLighting,
                    style: _selectedStyle,
                    colorPalette: _selectedPalette,
                    customRequirements: '${_customRequirementsCtrl.text} | Preferences: Seating: $_seatingPref, Storage: $_storagePref, Flooring: $_flooringPref, Wall: $_wallFinishPref',
                    carpetAreaSqFt: double.tryParse(_areaCtrl.text) ?? 300.0,
                    originalImageUrl: _uploadedImagePath!,
                    generatedImageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=1200&auto=format&fit=crop&q=80',
                    createdAt: DateTime.now(),
                    creditsUsed: cost,
                    isSaved: true,
                    preliminarySpecs: const [
                      AiMaterialSpecItem(category: 'Flooring', suggestedMaterial: 'Italian Statuario Marble', specification: 'Diamond buffed bookmatch slabs', quantity: 340, unit: 'Sq.Ft.'),
                      AiMaterialSpecItem(category: 'Wall Cladding', suggestedMaterial: 'Smoked Teak Wood Louvers', specification: '12mm calibrated marine plywood', quantity: 160, unit: 'Sq.Ft.'),
                      AiMaterialSpecItem(category: 'Ceiling Cove', suggestedMaterial: 'Concealed LED Warm Strip 3000K', specification: 'Cob profile extrusion channels', quantity: 52, unit: 'R.Ft.'),
                    ],
                  );

                  repo.saveRoomDesign(newDesign);
                  setState(() {
                    _isGenerating = false;
                    _currentResult = newDesign;
                  });
                  _tabController.animateTo(2); // Jump to Generated Results
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text('Generate Design ($cost Credits)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuration saved to draft designs.'), backgroundColor: Color(0xFF10B981)),
                  );
                },
                icon: const Icon(Icons.bookmark_border_rounded, size: 14),
                label: const Text('Save as Draft'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }

  // ==========================================================================
  // GENERATION STATE
  // ==========================================================================
  Widget _buildGeneratingState(BuildContext context, bool isDark) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED))),
            ),
            const SizedBox(height: 16),
            Text('Generating 4K Architectural Visual', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(_generationStage, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF7C3AED))),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: _generationProgress, minHeight: 6, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED))),
            ),
            const SizedBox(height: 10),
            Text('Asynchronous GPU processing in progress. You may leave this page; your design will appear in My Designs & History.', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // TAB 2: MY DESIGNS
  // ==========================================================================
  Widget _buildMyDesignsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    if (repo.roomDesigns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bedroom_parent_outlined, size: 44, color: Color(0xFF94A3B8)),
            const SizedBox(height: 8),
            Text('No saved designs yet', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            ElevatedButton(onPressed: () => _tabController.animateTo(0), child: const Text('Create Your First Design', style: TextStyle(fontSize: 12))),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: repo.roomDesigns.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 250,
      ),
      itemBuilder: (context, index) {
        final d = repo.roomDesigns[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(d.generatedImageUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Center(child: Icon(Icons.image))),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                        child: Text(d.style.label, style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${d.projectName} • ${d.carpetAreaSqFt.toInt()} Sq.Ft.', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _currentResult = d);
                            _tabController.animateTo(2);
                          },
                          icon: const Icon(Icons.open_in_full_rounded, size: 12),
                          label: const Text('Inspect'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 11)),
                        ),
                        IconButton(
                          onPressed: () => repo.deleteRoomDesign(d.id),
                          icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                          tooltip: 'Delete design',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 3: GENERATED RESULTS WORKSPACE
  // ==========================================================================
  Widget _buildGeneratedResultsTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final design = _currentResult ?? (repo.roomDesigns.isNotEmpty ? repo.roomDesigns.first : null);

    if (design == null) {
      return Center(
        child: Text('No generated design to inspect. Please generate a room concept first.', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Bar & Canvas Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(design.title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                  Text('${design.projectName} • Created ${design.createdAt.day}/${design.createdAt.month}/${design.createdAt.year}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
              Wrap(
                spacing: 6,
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Slider', label: Text('Slider', style: TextStyle(fontSize: 11))),
                      ButtonSegment(value: 'SideBySide', label: Text('Side-by-Side', style: TextStyle(fontSize: 11))),
                      ButtonSegment(value: 'AI Only', label: Text('4K Render', style: TextStyle(fontSize: 11))),
                    ],
                    selected: {_comparisonMode},
                    onSelectionChanged: (s) => setState(() => _comparisonMode = s.first),
                  ),
                  IconButton(
                    onPressed: () {
                      repo.createRoomDesignVariation(design.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Variation B generated and added to My Designs!'), backgroundColor: Color(0xFF10B981)),
                      );
                    },
                    icon: const Icon(Icons.dynamic_feed_rounded, size: 18),
                    tooltip: 'Create Variation',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Canvas
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _comparisonMode == 'Slider'
                  ? BeforeAfterSlider(
                      beforeImageUrl: design.originalImageUrl,
                      afterImageUrl: design.generatedImageUrl,
                    )
                  : _comparisonMode == 'SideBySide'
                      ? Row(
                          children: [
                            Expanded(child: Image.network(design.originalImageUrl, fit: BoxFit.cover)),
                            Container(width: 2, color: Colors.white30),
                            Expanded(child: Image.network(design.generatedImageUrl, fit: BoxFit.cover)),
                          ],
                        )
                      : Image.network(design.generatedImageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 14),

          // 5.9 Preliminary Material Specification Table
          Text('Preliminary Material Specification (AI Estimated)', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Generated based on visual textures, millwork layout and 3D depth analysis.', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0)),
            ),
            child: DataTable(
              headingRowHeight: 34,
              dataRowMinHeight: 30,
              dataRowMaxHeight: 34,
              columns: const [
                DataColumn(label: Text('Category', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Suggested Material', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Specification', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Qty', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Unit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              ],
              rows: design.preliminarySpecs.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    DataCell(Text(item.suggestedMaterial, style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.specification, style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.quantity.toInt().toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.unit, style: const TextStyle(fontSize: 11))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 4: DESIGN HISTORY
  // ==========================================================================
  Widget _buildDesignHistoryTab(BuildContext context, bool isDark, AiSuiteRepository repo) {
    final roomJobs = repo.jobs.where((j) => j.productType == 'Room Designer').toList();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: roomJobs.length,
      separatorBuilder: (_, _) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final job = roomJobs[index];
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
