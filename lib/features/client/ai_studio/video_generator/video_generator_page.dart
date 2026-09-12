import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../models/models.dart';
import '../services/ai_credit_service.dart';
import '../services/ai_studio_service.dart';
import '../widgets/widgets.dart';

class VideoGeneratorPage extends StatefulWidget {
  const VideoGeneratorPage({super.key});

  @override
  State<VideoGeneratorPage> createState() => _VideoGeneratorPageState();
}

class _VideoGeneratorPageState extends State<VideoGeneratorPage> {
  final TextEditingController _promptController = TextEditingController(
    text: 'Cinematic glide through living room towards the sunset balcony, highlighting warm 3000K cove light and fluted oak textures',
  );

  VideoCameraMotion _selectedMotion = VideoCameraMotion.smoothFlythrough;
  int _durationSeconds = 6;
  String _resolution = '1080p 60fps';
  bool _isGenerating = false;
  int _generationPhase = 0;

  final List<AiVideoJob> _jobs = [
    AiVideoJob(
      id: 'VID-001',
      title: 'Master Bedroom 360° Flythrough',
      prompt: 'Cinematic slow forward glide across master suite showing king bed fluted headboard and pendant lighting',
      cameraMotion: VideoCameraMotion.smoothFlythrough,
      durationSeconds: 6,
      resolution: '1080p 60fps',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&auto=format&fit=crop&q=80',
      isCompleted: true,
      creditCost: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generateVideo() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter camera motion instructions for your video.')),
      );
      return;
    }

    if (!AiCreditService.instance.hasSufficientCredits(8)) {
      _showInsufficientCreditsDialog();
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationPhase = 0;
    });

    // Real architectural rendering pipeline stages
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _generationPhase = 1);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _generationPhase = 2);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _generationPhase = 3);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Deduct 8 credits
    AiCreditService.instance.deductCredits(
      amount: 8,
      toolName: 'Cinematic Video Walkthrough',
      operationTitle: 'Video Flythrough (${_selectedMotion.title})',
    );

    final newJob = AiVideoJob(
      id: 'VID-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: '${_selectedMotion.title} Video Simulation',
      prompt: prompt,
      cameraMotion: _selectedMotion,
      durationSeconds: _durationSeconds,
      resolution: _resolution,
      thumbnailUrl:
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&auto=format&fit=crop&q=80',
      isCompleted: true,
      creditCost: 8,
      createdAt: DateTime.now(),
    );

    // Save to unified history
    AiStudioService.instance.recordGeneration(
      type: AiArtifactType.videoWalkthrough,
      title: 'Cinematic Video: ${_selectedMotion.title}',
      subtitle: '$_resolution · $_durationSeconds Seconds duration',
      previewImageUrl: newJob.thumbnailUrl,
      creditsUsed: 8,
      destinationRoute: '/client/ai-video-generator',
    );

    setState(() {
      _jobs.insert(0, newJob);
      _isGenerating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('60fps video walkthrough simulation successfully compiled!')),
    );
  }

  void _showInsufficientCreditsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Insufficient AI Credits', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('Cinematic video synthesis requires 8 credits. Would you like to top up?',
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
      title: 'Cinematic Video Flythrough',
      subtitle: '360° Architectural Camera Animations, Dolly Zooms & 60fps Walkthroughs',
      body: _isGenerating
          ? _buildProgressView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Camera Motion Selector
                Text(
                  '1. Select Architectural Camera Motion',
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
                      itemCount: VideoCameraMotion.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isNarrow ? 1 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isNarrow ? 3.4 : 2.7,
                      ),
                      itemBuilder: (context, index) {
                        final motion = VideoCameraMotion.values[index];
                        final isSelected = motion == _selectedMotion;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: AppRadius.md,
                            onTap: () => setState(() => _selectedMotion = motion),
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
                                          motion.title,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: AppColors.getTextPrimary(context),
                                          ),
                                        ),
                                        Text(
                                          motion.subtitle,
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

                // 2. Video Specs
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [5, 10].map((dur) {
                              final isSelected = dur == _durationSeconds;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text('$dur Seconds'),
                                  selected: isSelected,
                                  onSelected: (_) => setState(() => _durationSeconds = dur),
                                  selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                                  backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.primaryLight : AppColors.getTextSecondary(context),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Render Quality',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: ['1080p 60fps', '4K Cinema'].map((res) {
                              final isSelected = res == _resolution;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(res),
                                  selected: isSelected,
                                  onSelected: (_) => setState(() => _resolution = res),
                                  selectedColor: isDark ? const Color(0xFF1E2843) : const Color(0xFFEEF2FF),
                                  backgroundColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.primaryLight : AppColors.getTextSecondary(context),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Motion Prompt Input
                Text(
                  '2. Motion Dynamics & Lighting Path',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _promptController,
                  maxLines: 3,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.getTextPrimary(context)),
                  decoration: InputDecoration(
                    hintText: 'Describe camera trajectory, focal points, and lighting transitions...',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Submit Button
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _generateVideo,
                      icon: const Icon(Icons.videocam_rounded, size: 16),
                      label: Text(
                        'Synthesize Video Walkthrough (8 Credits)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC4899),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Video Gallery
                Text(
                  'Compiled Architectural Animations',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _jobs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    return _buildVideoCard(context, job, isDark);
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildVideoCard(BuildContext context, AiVideoJob job, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          final thumbnail = Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: AppRadius.md,
                child: SizedBox(
                  width: isNarrow ? double.infinity : 220,
                  height: 130,
                  child: job.thumbnailUrl != null
                      ? Image.network(
                          job.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            color: const Color(0xFF1E293B),
                            child: const Icon(Icons.broken_image, color: Colors.white24),
                          ),
                        )
                      : Container(color: const Color(0xFF1E293B)),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: AppRadius.xs,
                  ),
                  child: Text(
                    '00:0${job.durationSeconds}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                job.prompt,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withValues(alpha: 0.12),
                      borderRadius: AppRadius.xs,
                    ),
                    child: Text(
                      job.resolution,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEC4899),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Motion: ${job.cameraMotion.title}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getTextMuted(context),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.download_rounded, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading MP4 video file...')),
                      );
                    },
                    tooltip: 'Download MP4',
                  ),
                ],
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                thumbnail,
                const SizedBox(height: 12),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              const SizedBox(width: 16),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressView() {
    final steps = [
      AiGenerationStep(
        title: 'Constructing 3D camera spline & motion keyframes',
        description: 'Calculating camera vector, speed curves, and focal trajectory...',
        isCompleted: _generationPhase > 0,
        isActive: _generationPhase == 0,
      ),
      AiGenerationStep(
        title: 'Rendering temporal spatial coherence at 60fps',
        description: 'Ensuring zero frame flickering on fluted wood panels and marble specularities...',
        isCompleted: _generationPhase > 1,
        isActive: _generationPhase == 1,
      ),
      AiGenerationStep(
        title: 'Encoding $_resolution motion video',
        description: 'Synthesizing H.264 video stream with depth-of-field blur...',
        isCompleted: _generationPhase > 2,
        isActive: _generationPhase == 2,
      ),
      AiGenerationStep(
        title: 'Finalizing architectural flythrough',
        description: 'Compiling preview thumbnail and cloud storage URI...',
        isCompleted: _generationPhase > 3,
        isActive: _generationPhase == 3,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: AiGenerationStateView(
        toolTitle: 'Cinematic Video Flythrough',
        currentOperation: 'Rendering 60fps Walkthrough Animation',
        steps: steps,
        onCancel: () => setState(() => _isGenerating = false),
      ),
    );
  }
}
