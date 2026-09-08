import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import 'design_shared_widgets.dart';

/// Multi-format preview dialog for CAD drawings, 3D renders, mood boards, and BOQs.
/// Supports version switching, visual annotation markers, and technical spec inspections.
class FilePreviewModal extends StatefulWidget {
  final DesignDeliverable deliverable;
  final VoidCallback? onDownload;
  final ValueChanged<DesignDeliverable>? onUpdate;

  const FilePreviewModal({
    super.key,
    required this.deliverable,
    this.onDownload,
    this.onUpdate,
  });

  static void show({
    required BuildContext context,
    required DesignDeliverable deliverable,
    VoidCallback? onDownload,
    ValueChanged<DesignDeliverable>? onUpdate,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => FilePreviewModal(
        deliverable: deliverable,
        onDownload: onDownload,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<FilePreviewModal> createState() => _FilePreviewModalState();
}

class _FilePreviewModalState extends State<FilePreviewModal> {
  late String _selectedVersion;
  int _activeTabIndex = 0; // 0: Preview, 1: Annotations, 2: Version History, 3: Metadata
  final _newCommentController = TextEditingController();
  final List<DesignAnnotation> _localAnnotations = [];

  @override
  void initState() {
    super.initState();
    _selectedVersion = widget.deliverable.currentVersion;
    _localAnnotations.addAll(widget.deliverable.annotations);
  }

  @override
  void dispose() {
    _newCommentController.dispose();
    super.dispose();
  }

  void _addAnnotation(double x, double y) {
    showDialog(
      context: context,
      builder: (ctx) {
        final commentCtrl = TextEditingController();
        AnnotationType selectedType = AnnotationType.comment;

        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              title: Text('Add Visual Pin at (${(x * 100).toInt()}%, ${(y * 100).toInt()}%)', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Annotation Type:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AnnotationType.values.map((type) {
                      final isSelected = selectedType == type;
                      return ChoiceChip(
                        label: Text(type.label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : null)),
                        selected: isSelected,
                        selectedColor: type.color,
                        onSelected: (val) {
                          if (val) setDlgState(() => selectedType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: commentCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'e.g., Increase island counter clearance to 1100mm...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (commentCtrl.text.trim().isNotEmpty) {
                      final newAnn = DesignAnnotation(
                        id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
                        authorName: 'Current User (Architect)',
                        authorRole: DesignRole.seniorArchitect,
                        comment: commentCtrl.text.trim(),
                        normalizedX: x,
                        normalizedY: y,
                        type: selectedType,
                        createdAt: DateTime.now(),
                      );
                      setState(() {
                        _localAnnotations.add(newAnn);
                      });
                      widget.onUpdate?.call(
                        widget.deliverable.copyWith(annotations: _localAnnotations),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add Pin'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final d = widget.deliverable;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050, maxHeight: 760),
        child: Column(
          children: [
            // Top Modal Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: d.category.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(d.category.icon, color: d.category.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                d.title,
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DesignFileTypeBadge(fileType: d.fileType),
                            const SizedBox(width: 6),
                            DesignStatusBadge(status: d.status),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${d.projectCode} — ${d.projectName} • ${d.roomArea}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Version selector pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedVersion,
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black),
                        items: d.versionHistory.map((v) {
                          return DropdownMenuItem<String>(
                            value: v.versionTag,
                            child: Text('${v.versionTag} (${v.reviewStatus.label})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedVersion = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Download File',
                    icon: const Icon(Icons.download_rounded),
                    onPressed: () {
                      widget.onDownload?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading ${d.title} ($_selectedVersion)...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab bar for view switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2430) : const Color(0xFFF8FAFC),
                border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
                children: [
                  _buildTab(0, 'Visual Canvas & Pins', Icons.visibility_rounded),
                  _buildTab(1, 'Pins & Annotations (${_localAnnotations.length})', Icons.push_pin_outlined),
                  _buildTab(2, 'Version History (${d.versionHistory.length})', Icons.history_rounded),
                  _buildTab(3, 'Technical Specs & Audit', Icons.info_outline_rounded),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: _buildTabContent(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title, IconData icon) {
    final isSelected = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColors.primary : Colors.grey),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(bool isDark) {
    switch (_activeTabIndex) {
      case 0:
        return _buildVisualCanvas(isDark);
      case 1:
        return _buildAnnotationsList(isDark);
      case 2:
        return _buildVersionHistoryList(isDark);
      case 3:
      default:
        return _buildTechnicalSpecs(isDark);
    }
  }

  Widget _buildVisualCanvas(bool isDark) {
    final d = widget.deliverable;
    final isCadOr3d = d.fileType == DesignFileType.dwg ||
        d.fileType == DesignFileType.rvt ||
        d.fileType == DesignFileType.max3ds;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Interactive canvas area where user can click to pin annotations
            GestureDetector(
              onTapUp: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localOffset = details.localPosition;
                final normX = (localOffset.dx / box.size.width).clamp(0.05, 0.95);
                final normY = (localOffset.dy / box.size.height).clamp(0.05, 0.95);
                _addAnnotation(normX, normY);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: isDark ? const Color(0xFF0F141C) : const Color(0xFFE2E8F0),
                child: Center(
                  child: isCadOr3d
                      ? _buildCad3dViewer(isDark, d)
                      : _buildImageMockViewer(isDark, d),
                ),
              ),
            ),

            // Visual Annotation Markers on canvas
            ..._localAnnotations.map((ann) {
              return Positioned(
                left: constraints.maxWidth * ann.normalizedX - 14,
                top: constraints.maxHeight * ann.normalizedY - 14,
                child: Tooltip(
                  message: '${ann.authorName} (${ann.type.label}): ${ann.comment}',
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ann.type.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ann.type.color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.push_pin, size: 14, color: Colors.white),
                  ),
                ),
              );
            }),

            // Canvas Floating Instructions
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_rounded, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      'Click anywhere on the preview to add a revision pin',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCad3dViewer(bool isDark, DesignDeliverable d) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(d.fileType.icon, size: 64, color: d.fileType.color),
          const SizedBox(height: 16),
          Text(
            '${d.fileType.name.toUpperCase()} Multi-layer Model Engine',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'DWG/RVT/3DS Spec: ${d.fileSizeBytesFormatted} • Version: $_selectedVersion • Layers: 18 active',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Chip(avatar: const Icon(Icons.layers_outlined, size: 14), label: const Text('Structural Grid')),
              Chip(avatar: const Icon(Icons.electrical_services_outlined, size: 14), label: const Text('MEP Conduit')),
              Chip(avatar: const Icon(Icons.chair_outlined, size: 14), label: const Text('Millwork Schedule')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageMockViewer(bool isDark, DesignDeliverable d) {
    return Container(
      margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A202C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: d.category.color.withValues(alpha: 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(d.category.icon, size: 48, color: d.category.color),
                const SizedBox(height: 12),
                Text(
                  d.title,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  'High-Resolution Texture & Lighting Render ($_selectedVersion)',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnotationsList(bool isDark) {
    if (_localAnnotations.isEmpty) {
      return const DesignEmptyState(
        icon: Icons.push_pin_outlined,
        title: 'No Annotations Placed',
        message: 'Switch to the "Visual Canvas" tab and click anywhere to place revision markers.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _localAnnotations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ann = _localAnnotations[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ann.type.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ann.type.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.push_pin, size: 16, color: ann.type.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ann.authorName,
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ann.type.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ann.type.label,
                            style: GoogleFonts.inter(fontSize: 10, color: ann.type.color, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '(${((ann.normalizedX) * 100).toInt()}%, ${((ann.normalizedY) * 100).toInt()}%)',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(ann.comment, style: GoogleFonts.inter(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionHistoryList(bool isDark) {
    final history = widget.deliverable.versionHistory;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final v = history[index];
        final isSelected = v.versionTag == _selectedVersion;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  v.versionTag,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.changelogNote,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Uploaded by ${v.uploadedByName} on ${v.uploadedAt.day}/${v.uploadedAt.month}/${v.uploadedAt.year} • ${v.fileSizeBytesFormatted}',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              DesignStatusBadge(status: v.reviewStatus),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTechnicalSpecs(bool isDark) {
    final d = widget.deliverable;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Specifications', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildSpecRow('Project Code & Name', '${d.projectCode} — ${d.projectName}', isDark),
          _buildSpecRow('Design Stage', d.stage.label, isDark),
          _buildSpecRow('Room / Zone Area', d.roomArea, isDark),
          _buildSpecRow('Deliverable Category', d.category.label, isDark),
          _buildSpecRow('File Format & Extension', '.${d.fileType.extension} (${d.fileType.name})', isDark),
          _buildSpecRow('File Size', d.fileSizeBytesFormatted, isDark),
          _buildSpecRow('Lead Designer', '${d.designerName} (${d.designerRole.label})', isDark),
          _buildSpecRow('Total Revisions Logged', '${d.revisionCount} revisions', isDark),
          _buildSpecRow('Client Review Deadline', d.clientReviewSlaDeadline != null ? '${d.clientReviewSlaDeadline!.day}/${d.clientReviewSlaDeadline!.month}/${d.clientReviewSlaDeadline!.year}' : 'N/A', isDark),
          _buildSpecRow('Execution Handover Webhook', d.executionWebhookTriggeredAt ?? 'Pending Approval', isDark),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
