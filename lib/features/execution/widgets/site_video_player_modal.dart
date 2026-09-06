import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Simulated 4K Site Video Player Modal with GPS Verification Badge and Before/After inspection tabs.
class SiteVideoPlayerModal extends StatefulWidget {
  final SiteMediaLog mediaLog;

  const SiteVideoPlayerModal({
    super.key,
    required this.mediaLog,
  });

  static Future<void> show({
    required BuildContext context,
    required SiteMediaLog mediaLog,
    ProjectMaster? project,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => SiteVideoPlayerModal(
        mediaLog: mediaLog,
      ),
    );
  }

  @override
  State<SiteVideoPlayerModal> createState() => _SiteVideoPlayerModalState();
}

class _SiteVideoPlayerModalState extends State<SiteVideoPlayerModal> {
  bool _isPlaying = true;
  double _scrubPosition = 0.45;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final log = widget.mediaLog;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.videocam_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.title,
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${log.projectTitle} • ${log.milestoneName}',
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Video Player Viewport
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  child: Image.network(
                    log.mediaUrl,
                    height: 420,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 420,
                      color: Colors.black87,
                      child: const Center(child: Icon(Icons.videocam_off_rounded, size: 64, color: Colors.white54)),
                    ),
                  ),
                ),
                // Play / Pause Overlay
                IconButton(
                  iconSize: 56,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
                // 4K Quality Badge
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('4K 60FPS HDR', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
                // Verified Geotag Badge
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'GPS Verified: ${log.gpsCoordinates}',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                // Player Control Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('00:48 / ${log.durationText}', style: GoogleFonts.inter(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Slider(
                            value: _scrubPosition,
                            activeColor: AppColors.primary,
                            inactiveColor: Colors.white30,
                            onChanged: (val) => setState(() => _scrubPosition = val),
                          ),
                        ),
                        const Icon(Icons.fullscreen_rounded, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Metadata Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.description, style: GoogleFonts.inter(fontSize: 12, height: 1.4)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildDetailItem(Icons.person_outline_rounded, 'Supervisor: ${log.supervisorName}'),
                      _buildDetailItem(Icons.group_outlined, 'Manpower on site: ${log.workerCountOnSite} Workers'),
                      _buildDetailItem(Icons.wb_sunny_outlined, 'Weather: ${log.weatherCondition}'),
                      _buildDetailItem(Icons.access_time_rounded, 'Recorded: ${_formatDateTime(log.recordedAt)}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
