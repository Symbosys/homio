import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/design_models.dart';

/// Modal for client review, visual annotation, and execution trigger webhook.
class ClientReviewModal extends StatefulWidget {
  final DesignDeliverable deliverable;
  final ValueChanged<DesignDeliverable> onUpdate;

  const ClientReviewModal({
    super.key,
    required this.deliverable,
    required this.onUpdate,
  });

  static void show({
    required BuildContext context,
    required DesignDeliverable deliverable,
    required ValueChanged<DesignDeliverable> onUpdate,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ClientReviewModal(
        deliverable: deliverable,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<ClientReviewModal> createState() => _ClientReviewModalState();
}

class _ClientReviewModalState extends State<ClientReviewModal> {
  final _commentController = TextEditingController();
  bool _isRequestingRevision = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleApprove() {
    final updated = widget.deliverable.copyWith(
      status: DesignReviewStatus.approved,
      executionWebhookTriggeredAt: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} IST (Automated Webhook to Project Execution Module)',
    );

    widget.onUpdate(updated);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deliverable "${widget.deliverable.title}" APPROVED! Automated webhook triggered: Sent to Execution WBS.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleRejectAndRequestChanges() {
    final note = _commentController.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter specific client revision feedback/annotations.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newRev = widget.deliverable.revisionCount + 1;
    final updatedHistory = List<DesignVersionRecord>.from(widget.deliverable.versionHistory)
      ..add(
        DesignVersionRecord(
          versionTag: 'v$newRev.0',
          fileName: 'Revision_${newRev}_Pending.dwg',
          fileUrl: widget.deliverable.fileUrl,
          fileSizeBytes: widget.deliverable.fileSizeBytes,
          uploadedAt: DateTime.now(),
          uploadedByName: widget.deliverable.designerName,
          changelogNote: 'Revision triggered by client feedback',
          reviewStatus: DesignReviewStatus.changesRequested,
          clientFeedback: note,
          turnaroundHours: 24,
        ),
      );

    final updated = widget.deliverable.copyWith(
      status: DesignReviewStatus.changesRequested,
      revisionCount: newRev,
      versionHistory: updatedHistory,
    );

    widget.onUpdate(updated);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Revision #$newRev requested. Notification dispatched to ${widget.deliverable.designerName}.'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final d = widget.deliverable;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850, maxHeight: 720),
        child: Column(
          children: [
            // Modal Top Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: d.category.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(d.category.icon, color: d.category.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              d.title,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: d.fileType.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                d.fileType.extension.toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${d.projectCode} • ${d.roomArea} • Designer: ${d.designerName}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Modal Body: Media Preview & Review Panel
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Area: Drawing Viewer
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            panEnabled: true,
                            minScale: 0.8,
                            maxScale: 3.5,
                            child: Image.network(
                              d.thumbnailUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Pinch / Scroll to zoom • CAD High-Res Vector View',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Area: Lifecycle Review Actions & Audit
                  SizedBox(
                    width: 320,
                    child: Container(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Current Status Card
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: d.status.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: d.status.color.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(d.status.icon, color: d.status.color, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Review Status',
                                          style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                                        ),
                                        Text(
                                          d.status.label,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: d.status.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Meta details
                            _buildInfoRow('Current Version', d.currentVersion),
                            _buildInfoRow('Total Revisions', 'Rev #${d.revisionCount}'),
                            _buildInfoRow('File Size', d.fileSizeFormatted),
                            _buildInfoRow('Client Approver', d.clientName),
                            if (d.executionWebhookTriggeredAt != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '🚀 Execution Webhook Active:\n${d.executionWebhookTriggeredAt}',
                                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 12),

                            // Actions
                            if (!_isRequestingRevision) ...[
                              Text(
                                'CLIENT APPROVAL LOOP',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                                onPressed: _handleApprove,
                                icon: const Icon(Icons.check_circle_outline, size: 18),
                                label: const Text('Approve & Send to Execution'),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                                ),
                                onPressed: () => setState(() => _isRequestingRevision = true),
                                icon: const Icon(Icons.published_with_changes_rounded, size: 18),
                                label: const Text('Request Revisions / Changes'),
                              ),
                            ] else ...[
                              Text(
                                'REQUEST REVISION (REV #${d.revisionCount + 1})',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: AppColors.warning,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _commentController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText: 'Enter specific client change requests, layer modifications or material tweaks...',
                                  hintStyle: TextStyle(fontSize: 12),
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => setState(() => _isRequestingRevision = false),
                                    child: const Text('Cancel'),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.warning,
                                    ),
                                    onPressed: _handleRejectAndRequestChanges,
                                    child: const Text('Dispatch Revision'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
          Text(val, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
