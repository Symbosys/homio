import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/execution_models.dart';
import '../models/execution_mock_data.dart';
import '../widgets/execution_header.dart';
import '../widgets/execution_metric_card.dart';
import '../widgets/site_media_upload_modal.dart';
import '../widgets/site_video_player_modal.dart';

class ExecutionSiteProgressPage extends StatefulWidget {
  const ExecutionSiteProgressPage({super.key});

  @override
  State<ExecutionSiteProgressPage> createState() => _ExecutionSiteProgressPageState();
}

class _ExecutionSiteProgressPageState extends State<ExecutionSiteProgressPage> {
  late List<ProjectMaster> _projects;
  String? _selectedProjectId;
  String? _selectedWorkStream;
  bool _clientVisibleOnly = false;
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _projects = List.from(ExecutionMockData.projects);
    if (_projects.isNotEmpty) {
      _selectedProjectId = _projects.first.id;
    }
  }

  ProjectMaster? get _currentProject {
    if (_projects.isEmpty) return null;
    return _projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => _projects.first,
    );
  }

  List<SiteMediaLog> get _filteredLogs {
    final proj = _currentProject;
    if (proj == null) return [];

    return proj.mediaLogs.where((log) {
      if (_clientVisibleOnly && !log.clientVisible) return false;
      if (_selectedWorkStream != null && log.workStream != _selectedWorkStream) return false;
      if (_filterDate != null) {
        if (log.capturedAt.year != _filterDate!.year ||
            log.capturedAt.month != _filterDate!.month ||
            log.capturedAt.day != _filterDate!.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _handleUploadMedia() {
    final proj = _currentProject;
    if (proj == null) return;

    SiteMediaUploadModal.show(
      context: context,
      project: proj,
      onUpload: (newLog) {
        setState(() {
          proj.mediaLogs.insert(0, newLog);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('4K Site Media "${newLog.title}" uploaded with GPS verification!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handlePlayVideo(SiteMediaLog log) {
    SiteVideoPlayerModal.show(
      context: context,
      mediaLog: log,
      project: _currentProject,
    );
  }

  void _toggleClientVisibility(SiteMediaLog log) {
    setState(() {
      final idx = _currentProject?.mediaLogs.indexWhere((l) => l.id == log.id) ?? -1;
      if (idx != -1) {
        final current = _currentProject!.mediaLogs[idx];
        _currentProject!.mediaLogs[idx] = current.copyWith(
          clientVisible: !current.clientVisible,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !log.clientVisible
              ? 'Log is now visible on Client WhatsApp & Portal.'
              : 'Log is now internal-only.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final proj = _currentProject;
    final logs = _filteredLogs;

    // Metrics
    final totalLogs = proj?.mediaLogs.length ?? 0;
    final gpsVerified = proj?.mediaLogs.where((l) => l.isGpsVerified).length ?? 0;
    final clientShared = proj?.mediaLogs.where((l) => l.clientVisible).length ?? 0;
    final labourActiveToday = logs.isNotEmpty ? logs.first.labourCountOnSite : 14;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Execution Header
            ExecutionHeader(
              title: 'Daily Site Progress & 4K Video Logs',
              subtitle: 'GPS geofence verified daily logs, 4K video surveillance & client transparency',
              primaryActionLabel: 'Upload 4K Site Media',
              primaryActionIcon: Icons.videocam_outlined,
              onPrimaryAction: _handleUploadMedia,
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting site progress report with geotags...')),
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share Digest'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Metric Cards
            Row(
              children: [
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Total Site Logs',
                    value: '$totalLogs',
                    subtitle: 'Recorded by Supervisor',
                    icon: Icons.video_library_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'GPS Geofence Verified',
                    value: '$gpsVerified',
                    subtitle: '100% within 50m radius',
                    icon: Icons.verified_user_outlined,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'Client Portal Visible',
                    value: '$clientShared',
                    subtitle: 'Shared on client dashboard',
                    icon: Icons.remove_red_eye_outlined,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ExecutionMetricCard(
                    title: 'On-Site Labour Force',
                    value: '$labourActiveToday',
                    subtitle: 'Active today on site',
                    icon: Icons.groups_outlined,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Project Selector
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedProjectId,
                        underline: const SizedBox(),
                        items: _projects.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              '${p.projectName} (${p.projectCode})',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedProjectId = v);
                        },
                      ),
                    ],
                  ),
                  // Stream filter
                  DropdownButton<String?>(
                    value: _selectedWorkStream,
                    hint: const Text('All Work Streams'),
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Work Streams')),
                      const DropdownMenuItem(value: 'Civil & Masonry', child: Text('Civil & Masonry')),
                      const DropdownMenuItem(value: 'Carpentry & Woodwork', child: Text('Carpentry & Woodwork')),
                      const DropdownMenuItem(value: 'Electrical & Automation', child: Text('Electrical & Automation')),
                      const DropdownMenuItem(value: 'Painting & Finishing', child: Text('Painting & Finishing')),
                    ],
                    onChanged: (v) => setState(() => _selectedWorkStream = v),
                  ),
                  // Client visibility switch
                  FilterChip(
                    label: const Text('Client-Visible Only'),
                    selected: _clientVisibleOnly,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    onSelected: (val) => setState(() => _clientVisibleOnly = val),
                  ),
                  // Date Filter
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month, size: 16),
                    label: Text(
                      _filterDate != null
                          ? '${_filterDate!.day}/${_filterDate!.month}/${_filterDate!.year}'
                          : 'Filter Date',
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _filterDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      setState(() => _filterDate = picked);
                    },
                  ),
                  if (_filterDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () => setState(() => _filterDate = null),
                      tooltip: 'Clear date filter',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Video / Media Grid
            if (logs.isEmpty)
              Container(
                padding: const EdgeInsets.all(48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.videocam_off_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'No site progress logs found matching criteria.',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('Click "Upload 4K Site Media" to log today\'s supervisor site feed.'),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1100
                      ? 3
                      : (constraints.maxWidth > 700 ? 2 : 1);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 440,
                    ),
                    itemCount: logs.length,
                    itemBuilder: (context, idx) {
                      final log = logs[idx];
                      return _buildMediaCard(log, isDark, theme);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCard(SiteMediaLog log, bool isDark, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with play button overlay & Geotag chip
          Stack(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                  image: log.thumbnailUrl != null
                      ? DecorationImage(
                          image: NetworkImage(log.thumbnailUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: log.thumbnailUrl == null
                    ? Center(
                        child: Icon(
                          log.isVideo ? Icons.movie_creation : Icons.photo_library,
                          color: Colors.white38,
                          size: 48,
                        ),
                      )
                    : null,
              ),
              // Play button overlay
              Positioned.fill(
                child: Center(
                  child: InkWell(
                    onTap: () => _handlePlayVideo(log),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 2),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              // Top Badges (Resolution & Geotag)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.resolution,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              if (log.isGpsVerified)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gps_fixed, size: 10, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'GPS Verified (<50m)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Duration bottom right
              if (log.duration != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.duration!,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log.workStream,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      '${log.capturedAt.day}/${log.capturedAt.month} • ${log.capturedAt.hour.toString().padLeft(2, '0')}:${log.capturedAt.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  log.title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  log.workDoneSummary,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Tomorrow's plan & labour
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${log.labourCountOnSite} workers on site',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_pin, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'By: ${log.uploadedBy}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),

                // Bottom actions: Client visibility toggle & Play button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: log.clientVisible,
                          activeThumbColor: AppColors.primary,
                          onChanged: (_) => _toggleClientVisibility(log),
                        ),
                        Text(
                          log.clientVisible ? 'Client Visible' : 'Internal Only',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: log.clientVisible ? AppColors.success : AppColors.lightMutedText,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _handlePlayVideo(log),
                      icon: const Icon(Icons.play_circle_outline, size: 16),
                      label: const Text('Watch 4K', style: TextStyle(fontSize: 12)),
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
}
