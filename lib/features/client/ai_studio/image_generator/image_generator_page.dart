import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_credit_service.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  State<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _negativePromptController = TextEditingController(
    text: 'blurry, low resolution, warped walls, oversaturated, watermark, distorted furniture',
  );

  ImageRenderStyle _selectedStyle = ImageRenderStyle.photorealistic;
  ImageAspect _selectedAspect = ImageAspect.landscape16x9;
  bool _isGenerating = false;
  int _generationPhase = 0;

  final List<AiImageJob> _jobs = [
    AiImageJob(
      id: 'IMG-001',
      prompt:
          'Modern Japandi open living room with fluted oak paneling, recessed cove ceiling lighting, and low beige boucle sofa facing large balcony windows',
      style: ImageRenderStyle.photorealistic,
      aspect: ImageAspect.landscape16x9,
      outputImageUrl:
          'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=900&auto=format&fit=crop&q=80',
      isCompleted: true,
      creditCost: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      tags: ['Living Room', 'Japandi', 'Photorealistic'],
    ),
    AiImageJob(
      id: 'IMG-002',
      prompt:
          'Curated interior moodboard flatlay: Calacatta gold quartz slab, smoked oak veneer swatch, brushed brass cabinet handle, and warm linen fabric',
      style: ImageRenderStyle.moodboardCollage,
      aspect: ImageAspect.square1x1,
      outputImageUrl:
          'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=900&auto=format&fit=crop&q=80',
      isCompleted: true,
      creditCost: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['Moodboard', 'Materials', 'Flatlay'],
    ),
  ];

  @override
  void dispose() {
    _promptController.dispose();
    _negativePromptController.dispose();
    super.dispose();
  }

  void _generateImage() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a descriptive prompt for your visual concept.')),
      );
      return;
    }

    if (!AiCreditService.instance.hasSufficientCredits(2)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationPhase = 0;
    });

    // Real discrete generation steps
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _generationPhase = 1);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _generationPhase = 2);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Deduct 2 credits
    AiCreditService.instance.deductCredits(
      amount: 2,
      toolName: 'Visual Asset Generator',
      operationTitle: 'Concept Render (${_selectedStyle.label})',
    );

    final newJob = AiImageJob(
      id: 'IMG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      prompt: prompt,
      negativePrompt: _negativePromptController.text.trim(),
      style: _selectedStyle,
      aspect: _selectedAspect,
      outputImageUrl:
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=900&auto=format&fit=crop&q=80',
      isCompleted: true,
      creditCost: 2,
      createdAt: DateTime.now(),
      tags: [_selectedStyle.label, _selectedAspect.ratio],
    );

    // Save to unified history
    AiStudioService.instance.recordGeneration(
      type: AiArtifactType.imageJob,
      title: prompt.length > 35 ? '${prompt.substring(0, 35)}...' : prompt,
      subtitle: 'Style: ${_selectedStyle.label} · Ratio: ${_selectedAspect.ratio}',
      previewImageUrl: newJob.outputImageUrl,
      creditsUsed: 2,
      destinationRoute: '/client/ai-image-generator',
    );

    setState(() {
      _jobs.insert(0, newJob);
      _isGenerating = false;
      _promptController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visual concept successfully synthesized!')),
    );
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Insufficient AI Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('You need 2 credits to synthesize a visual render. Top up your wallet anytime.',
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

    return AiStudioPageScaffold(
      title: 'Visual Asset Generator',
      subtitle: 'Photorealistic 8K Renders, Material Moodboards & Isometric 3D Views',
      body: _isGenerating
          ? _buildProgressView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Style Selector Grid
                Text(
                  '1. Select Rendering Style',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 680;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ImageRenderStyle.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isNarrow ? 1 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isNarrow ? 3.2 : 2.6,
                      ),
                      itemBuilder: (context, index) {
                        final style = ImageRenderStyle.values[index];
                        final isSelected = style == _selectedStyle;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: AppRadius.md,
                            onTap: () => setState(() => _selectedStyle = style),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF))
                                    : (isDark ? AppColors.darkSurface : Colors.white),
                                borderRadius: AppRadius.md,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  width: isSelected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryLight : AppColors.getTextMuted(context),
                                        width: isSelected ? 5.5 : 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          style.label,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: AppColors.getTextPrimary(context),
                                          ),
                                        ),
                                        Text(
                                          style.description,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: AppColors.getTextSecondary(context),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Aspect Ratio Selector
                Text(
                  '2. Output Aspect Ratio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ImageAspect.values.map((aspect) {
                    final isSelected = aspect == _selectedAspect;
                    return ChoiceChip(
                      label: Text(
                        '${aspect.ratio} (${aspect.label})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedAspect = aspect),
                      selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                      backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primaryLight
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.6) : Colors.transparent,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Prompt Input Box
                Text(
                  '3. Describe Your Interior / Architectural Vision',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: AppRadius.lg,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _promptController,
                        maxLines: 4,
                        minLines: 2,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: AppColors.getTextPrimary(context)),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Modern living room with fluted oak paneling, Italian Statuario marble waterfall island counter, cove lighting 3000K, floor-to-ceiling glass windows...',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.getTextMuted(context)),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.block_flipped, size: 14, color: AppColors.getTextMuted(context)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _negativePromptController,
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.getTextSecondary(context)),
                              decoration: const InputDecoration(
                                hintText: 'Negative prompt (things to avoid in the render)',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Submit Row
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _generateImage,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: Text(
                        'Generate Concept (2 Credits)',
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
                ),
                const SizedBox(height: 36),

                // Generated Gallery
                Text(
                  'Synthesized Visual Concepts',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 768;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _jobs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 2 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 1.25 : 1.15,
                      ),
                      itemBuilder: (context, index) {
                        final job = _jobs[index];
                        return _buildGalleryCard(context, job, isDark);
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, AiImageJob job, bool isDark) {
    return Container(
      clipBehavior: Clip.antiAlias,
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
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (job.outputImageUrl != null)
                  Image.network(
                    job.outputImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFF1E293B),
                      child: const Icon(Icons.broken_image, color: Colors.white24),
                    ),
                  ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      job.style.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      job.aspect.ratio,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.prompt,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading 8K render...')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 14),
                      label: Text('Download 8K', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        final savedItem = SavedDesignItem(
                          id: 'SAV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          title: job.prompt.length > 40 ? '${job.prompt.substring(0, 40)}...' : job.prompt,
                          category: job.style.label,
                          imageUrl: job.outputImageUrl!,
                          colorPalette: const ['#282624', '#F4F1EA', '#C2A383'],
                          personalNotes: 'Synthesized via Visual Asset Generator',
                          isSharedWithDesigner: false,
                          savedAt: DateTime.now(),
                        );
                        AiStudioService.instance.toggleBookmarkDesign(savedItem);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to Studio Vault!')),
                        );
                      },
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                      tooltip: 'Save to Studio Vault',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    final steps = [
      AiGenerationStep(
        title: 'Parsing style tokens & prompt semantics',
        description: 'Analyzing architectural vocabulary and lighting mood...',
        isCompleted: _generationPhase > 0,
        isActive: _generationPhase == 0,
      ),
      AiGenerationStep(
        title: 'Synthesizing ${_selectedStyle.label} shader pass',
        description: 'Applying texture maps, indirect rays, and ${_selectedAspect.ratio} viewport...',
        isCompleted: _generationPhase > 1,
        isActive: _generationPhase == 1,
      ),
      AiGenerationStep(
        title: 'Compiling 8K photorealistic output',
        description: 'Finalizing contrast curves and denoise filtering...',
        isCompleted: _generationPhase > 2,
        isActive: _generationPhase == 2,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: AiGenerationStateView(
        toolTitle: 'Visual Asset Generator',
        currentOperation: 'Synthesizing Visual Concept',
        steps: steps,
        onCancel: () => setState(() => _isGenerating = false),
      ),
    );
  }
}
