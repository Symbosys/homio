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
import 'step1_room_type.dart';
import 'step2_architecture_style.dart';
import 'step3_materials_furniture.dart';
import 'step4_budget_constraints.dart';
import 'step5_render_result.dart';

class RoomDesignerPage extends StatefulWidget {
  const RoomDesignerPage({super.key});

  @override
  State<RoomDesignerPage> createState() => _RoomDesignerPageState();
}

class _RoomDesignerPageState extends State<RoomDesignerPage> {
  int _currentStep = 0; // 0 to 4
  bool _isGenerating = false;
  int _generationPhase = 0;

  // Wizard Form State
  RoomType _roomType = RoomType.masterBedroom;
  double _lengthFt = 16.0;
  double _widthFt = 13.0;
  double _ceilingHeightFt = 10.5;

  String _styleTheme = 'Japandi Warm Minimalist';
  String _paletteName = 'Japandi Warm Earth';
  List<String> _colorPaletteHex = ['#282624', '#F4F1EA', '#C2A383', '#7D7065'];
  String _lightingMood = 'Warm Ambient 3000K (Cozy Evening)';

  String _woodFinish = 'Smoked European Oak';
  String _metalAccent = 'Brushed Brass (Gold Satin)';
  final List<String> _selectedElements = [
    'Fluted Acoustic Rafter Headboard',
    'Indirect False Ceiling LED Profile Tracks',
    'Floating Marble/Fluted TV Console',
  ];

  String _budgetBand = 'Premium Modern (₹3.0L - ₹6.0L)';
  String _specialNotes = '';
  String? _uploadedPhotoName;

  RoomDesignSession? _completedSession;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      _startGeneration();
    }
  }

  void _prevStep() {
    if (_currentStep > 0 && !_isGenerating) {
      setState(() => _currentStep--);
    }
  }

  void _startGeneration() async {
    // Check credit balance
    if (!AiCreditService.instance.hasSufficientCredits(3)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationPhase = 0;
    });

    // Discrete realistic architectural pipeline progression
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _generationPhase = 1);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _generationPhase = 2);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _generationPhase = 3);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Deduct 3 credits
    AiCreditService.instance.deductCredits(
      amount: 3,
      toolName: '3D Room Designer',
      operationTitle: '3D Photorealistic Transformation (${_roomType.label})',
    );

    final session = RoomDesignSession(
      id: 'RMS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: '${_roomType.label} 3D Transformation',
      roomType: _roomType,
      lengthFt: _lengthFt,
      widthFt: _widthFt,
      ceilingHeightFt: _ceilingHeightFt,
      styleTheme: _styleTheme,
      colorPaletteHex: _colorPaletteHex,
      lightingMood: _lightingMood,
      woodFinish: _woodFinish,
      hardwareMetal: _metalAccent,
      mustHaveElements: List.from(_selectedElements),
      budgetBand: _budgetBand,
      baseUploadImageUrl:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=900&auto=format&fit=crop&q=80',
      renderedImageUrl:
          'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=900&auto=format&fit=crop&q=80',
      alternativeRenderUrls: const [
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=900&auto=format&fit=crop&q=80',
      ],
      specifiedMaterials: [
        'CenturyPly Club Prime 710 Marine Plywood for Wardrobe & Headboard',
        'Rehau 1.5mm Scratch-Resistant Acrylic Shutters (Alabaster White)',
        'Hettich Sensys 8645i Integrated Soft-Close Concealed Hinges',
        '3000K Architectural Profile LED Recessed Diffusers',
        'Asian Paints Royale Aspira Luxury Emulsion (Washable)',
      ],
      estimatedCostLow: 380000,
      estimatedCostHigh: 460000,
      vastuComplianceSummary: '94% Vastu Harmony: Headboard against South wall, optimal Agni zone balance',
      status: RoomDesignStatus.completed,
      createdAt: DateTime.now(),
    );

    // Save to unified history
    AiStudioService.instance.recordGeneration(
      type: AiArtifactType.roomRender,
      title: '${_roomType.label} 3D Design',
      subtitle: '$_styleTheme · ${_lengthFt.toInt()}ft x ${_widthFt.toInt()}ft (${session.floorAreaSqFt.toInt()} sq.ft)',
      previewImageUrl: session.renderedImageUrl,
      creditsUsed: 3,
      destinationRoute: RouteNames.clientAiRoomGenPath,
    );

    setState(() {
      _isGenerating = false;
      _completedSession = session;
      _currentStep = 4; // Step 5 (Result)
    });
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Insufficient AI Credits',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'You need 3 credits to generate a 3D room transformation. Would you like to top up your wallet?',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/client/ai-credits');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('View Credit Packs'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AiStudioPageScaffold(
      title: '3D Room Designer',
      subtitle: '5-Step Architectural Visualizer with 50/50 Dual View Renders',
      body: _isGenerating
          ? _buildGenerationProgressView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stepper Header
                _buildStepperHeader(context, isDark),
                const SizedBox(height: 24),

                // Active Step Content
                _buildCurrentStepContent(),
                const SizedBox(height: 32),

                // Wizard Navigation Bottom Bar (hidden on result step)
                if (_currentStep < 4) _buildStepNavigationBar(context, isDark),
              ],
            ),
    );
  }

  Widget _buildStepperHeader(BuildContext context, bool isDark) {
    final stepLabels = [
      '1. Room & Size',
      '2. Theme & Mood',
      '3. Materials & Specs',
      '4. Budget & Photo',
      '5. 3D Render',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(stepLabels.length, (index) {
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primaryLight.withValues(alpha: 0.15)
                        : (isCompleted
                            ? AppColors.success.withValues(alpha: 0.12)
                            : Colors.transparent),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : (isCurrent
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded),
                        size: 16,
                        color: isCompleted
                            ? AppColors.success
                            : (isCurrent
                                ? AppColors.primaryLight
                                : AppColors.getTextMuted(context)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        stepLabels[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: isCurrent
                              ? AppColors.primaryLight
                              : (isCompleted
                                  ? AppColors.getTextPrimary(context)
                                  : AppColors.getTextMuted(context)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < stepLabels.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.getTextMuted(context),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return Step1RoomType(
          selectedRoomType: _roomType,
          lengthFt: _lengthFt,
          widthFt: _widthFt,
          ceilingHeightFt: _ceilingHeightFt,
          onRoomTypeChanged: (val) => setState(() => _roomType = val),
          onLengthChanged: (val) => setState(() => _lengthFt = val),
          onWidthChanged: (val) => setState(() => _widthFt = val),
          onCeilingHeightChanged: (val) => setState(() => _ceilingHeightFt = val),
        );
      case 1:
        return Step2ArchitectureStyle(
          selectedTheme: _styleTheme,
          selectedLighting: _lightingMood,
          selectedPaletteName: _paletteName,
          onThemeChanged: (val) => setState(() => _styleTheme = val),
          onLightingChanged: (val) => setState(() => _lightingMood = val),
          onPaletteChanged: (val) => setState(() {
            _paletteName = val.name;
            _colorPaletteHex = val.hexColors;
          }),
        );
      case 2:
        return Step3MaterialsFurniture(
          selectedWood: _woodFinish,
          selectedMetal: _metalAccent,
          selectedElements: _selectedElements,
          onWoodChanged: (val) => setState(() => _woodFinish = val),
          onMetalChanged: (val) => setState(() => _metalAccent = val),
          onToggleElement: (element) => setState(() {
            if (_selectedElements.contains(element)) {
              _selectedElements.remove(element);
            } else {
              _selectedElements.add(element);
            }
          }),
        );
      case 3:
        return Step4BudgetConstraints(
          selectedBudgetBand: _budgetBand,
          specialNotes: _specialNotes,
          uploadedPhotoName: _uploadedPhotoName,
          onBudgetBandChanged: (val) => setState(() => _budgetBand = val),
          onSpecialNotesChanged: (val) => setState(() => _specialNotes = val),
          onUploadPhoto: () {
            setState(() {
              _uploadedPhotoName = 'site_room_facing_balcony.jpg (12.4 MB)';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Site photo attached for 50/50 dual view render.')),
            );
          },
        );
      case 4:
        return Step5RenderResult(
          session: _completedSession!,
          onSaveToMoodboard: () {
            final savedItem = SavedDesignItem(
              id: 'SAV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              title: _completedSession!.title,
              category: _completedSession!.roomType.label,
              imageUrl: _completedSession!.renderedImageUrl!,
              colorPalette: _completedSession!.colorPaletteHex,
              keyMaterials: _completedSession!.specifiedMaterials.take(3).toList(),
              personalNotes: 'Generated via 3D Room Designer wizard',
              isSharedWithDesigner: false,
              savedAt: DateTime.now(),
            );
            AiStudioService.instance.toggleBookmarkDesign(savedItem);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved to your AI Studio Vault!')),
            );
          },
          onAddMaterialsToBOQ: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All 5 material specifications synced to Project BOQ & Quotations.'),
              ),
            );
          },
          onBookDesignerConsultation: () => context.go(RouteNames.clientDesignerCallPath),
          onDownloadRender: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Starting high-resolution 4K render download...')),
            );
          },
          onResetAndNewDesign: () {
            setState(() {
              _currentStep = 0;
              _completedSession = null;
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepNavigationBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        if (_currentStep > 0)
          OutlinedButton.icon(
            onPressed: _prevStep,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: Text(
              'Previous Step',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
          ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _nextStep,
          icon: Icon(
            _currentStep == 3 ? Icons.auto_awesome_rounded : Icons.arrow_forward_rounded,
            size: 16,
          ),
          label: Text(
            _currentStep == 3 ? 'Generate 3D Room (3 Credits)' : 'Continue to Next Step',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerationProgressView() {
    final steps = [
      AiGenerationStep(
        title: 'Analyzing 3D spatial dimensions & camera perspective',
        description: 'Calibrating ${_lengthFt.toInt()}ft x ${_widthFt.toInt()}ft floor area and slab height...',
        isCompleted: _generationPhase > 0,
        isActive: _generationPhase == 0,
      ),
      AiGenerationStep(
        title: 'Applying $_styleTheme material shaders & lighting',
        description: 'Mapping $_woodFinish textures, $_lightingMood, and Kelvin ambient glows...',
        isCompleted: _generationPhase > 1,
        isActive: _generationPhase == 1,
      ),
      AiGenerationStep(
        title: 'Validating Indian IS Standards & Brand Specifications',
        description: 'Checking IS:710 BWP plywood tolerances, CenturyPly & Hettich fixtures...',
        isCompleted: _generationPhase > 2,
        isActive: _generationPhase == 2,
      ),
      AiGenerationStep(
        title: 'Rendering 4K photorealistic dual-view comparison',
        description: 'Compiling specular reflections, ambient occlusion, and 50/50 slider overlay...',
        isCompleted: _generationPhase > 3,
        isActive: _generationPhase == 3,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: AiGenerationStateView(
        toolTitle: '3D Room Designer',
        currentOperation: 'Synthesizing ${_roomType.label} Design',
        steps: steps,
        onCancel: () => setState(() => _isGenerating = false),
      ),
    );
  }
}
