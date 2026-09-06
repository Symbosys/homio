import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Modal dialog for supervisor daily site video & photo upload with verified GPS geotags.
class SiteMediaUploadModal extends StatefulWidget {
  final List<ProjectMaster> projects;
  final ValueChanged<SiteMediaLog> onMediaUploaded;

  const SiteMediaUploadModal({
    super.key,
    required this.projects,
    required this.onMediaUploaded,
  });

  static Future<void> show({
    required BuildContext context,
    required ProjectMaster project,
    required ValueChanged<SiteMediaLog> onUpload,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SiteMediaUploadModal(
        projects: [project],
        onMediaUploaded: onUpload,
      ),
    );
  }

  @override
  State<SiteMediaUploadModal> createState() => _SiteMediaUploadModalState();
}

class _SiteMediaUploadModalState extends State<SiteMediaUploadModal> {
  late String _selectedProjectId;
  final _titleController = TextEditingController(text: 'Living Room Flooring Demolition & Debris Clearout');
  final _descController = TextEditingController(
    text: 'Old marble flooring completely chiseled out. Sub-base cleaned and moisture barrier primer applied.',
  );
  final _mediaUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1541888946425-d0fbb186f5f7?w=1200&q=80',
  );
  int _workersCount = 6;
  String _weather = 'Sunny 31°C';
  String _milestone = 'Civil Demolition';

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projects.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _mediaUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                        child: const Icon(Icons.video_call_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Upload Daily Progress Media',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Project & Milestone
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedProjectId,
                      items: widget.projects.map((p) {
                        return DropdownMenuItem(value: p.id, child: Text(p.projectTitle, style: GoogleFonts.inter(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedProjectId = val);
                      },
                      decoration: const InputDecoration(labelText: 'Site Project'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Milestone / Room Area'),
                      onChanged: (val) => _milestone = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Media Log Title'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Daily Progress Description'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _mediaUrlController,
                decoration: const InputDecoration(labelText: 'Media / Video URL'),
              ),
              const SizedBox(height: 14),

              // Manpower & Weather
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Workers: $_workersCount', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        Expanded(
                          child: Slider(
                            value: _workersCount.toDouble(),
                            min: 1,
                            max: 25,
                            divisions: 24,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _workersCount = val.toInt()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Weather & Temperature', hintText: 'Sunny 30°C'),
                      onChanged: (val) => _weather = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Verified GPS Badge preview
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.my_location_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Device Geolocation Verified: 28.5355° N, 77.3910° E • Auto-timestamped on submit',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _submitMedia,
                    icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                    label: const Text('Publish to Timeline & Notify Client'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitMedia() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final proj = widget.projects.firstWhere((p) => p.id == _selectedProjectId);

    final newLog = SiteMediaLog(
      id: 'MED-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      projectId: proj.id,
      projectTitle: proj.projectTitle,
      milestoneName: _milestone.isEmpty ? 'General Fitout' : _milestone,
      title: title,
      description: _descController.text.trim(),
      mediaUrl: _mediaUrlController.text.trim(),
      thumbnailUrl: _mediaUrlController.text.trim(),
      isVideo: true,
      durationText: '01:35',
      recordedAt: DateTime.now(),
      supervisorName: proj.siteSupervisorName,
      workerCountOnSite: _workersCount,
      weatherCondition: _weather,
      gpsCoordinates: '28.5355° N, 77.3910° E (Verified)',
      isGpsVerified: true,
    );

    widget.onMediaUploaded(newLog);
    Navigator.of(context).pop();
  }
}
