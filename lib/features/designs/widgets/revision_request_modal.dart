import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';

/// Modal dialog to trigger a formal design revision request.
class RevisionRequestModal extends StatefulWidget {
  final DesignDeliverable deliverable;
  final ValueChanged<DesignRevision> onSubmitRevision;

  const RevisionRequestModal({
    super.key,
    required this.deliverable,
    required this.onSubmitRevision,
  });

  static void show({
    required BuildContext context,
    required DesignDeliverable deliverable,
    required ValueChanged<DesignRevision> onSubmitRevision,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => RevisionRequestModal(
        deliverable: deliverable,
        onSubmitRevision: onSubmitRevision,
      ),
    );
  }

  @override
  State<RevisionRequestModal> createState() => _RevisionRequestModalState();
}

class _RevisionRequestModalState extends State<RevisionRequestModal> {
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomAreaController = TextEditingController();
  DesignPriority _priority = DesignPriority.high;
  int _turnaroundDays = 3;

  @override
  void initState() {
    super.initState();
    _roomAreaController.text = widget.deliverable.roomArea;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    _roomAreaController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final reason = _reasonController.text.trim();
    final description = _descriptionController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a revision reason or title.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final d = widget.deliverable;
    final revision = DesignRevision(
      id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
      deliverableId: d.id,
      projectCode: d.projectCode,
      deliverableTitle: d.title,
      currentVersion: d.currentVersion,
      revisionNumber: d.revisionCount + 1,
      requestedBy: '${d.clientName} (Client)',
      requestedAt: DateTime.now(),
      reason: reason,
      description: description.isNotEmpty ? description : 'Revision requested through Design Revision Management System.',
      specificArea: _roomAreaController.text.trim(),
      assignedDesigner: d.designerName,
      dueDate: DateTime.now().add(Duration(days: _turnaroundDays)),
      status: RevisionStatus.requested,
      priority: _priority,
      annotations: d.annotations,
    );

    widget.onSubmitRevision(revision);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Revision #${revision.revisionNumber} logged and assigned to ${d.designerName}.'),
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
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.published_with_changes_rounded, color: AppColors.warning, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Design Revision',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Target: ${d.title} (Current: ${d.currentVersion})',
                          style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reason field
              Text('Revision Reason / Core Subject *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'e.g. Expand Master Bath vanity dimensions, change wood veneer to walnut...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),

              // Description / Detailed remarks
              Text('Detailed Remarks & Client Instructions', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Provide specific instructions for ${d.designerName}...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),

              // Room area & Turnaround days
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room / Zone Area', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _roomAreaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SLA Turnaround (Days)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _turnaroundDays,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1 Day (Urgent Fast-track)')),
                            DropdownMenuItem(value: 2, child: Text('2 Days (Expedited)')),
                            DropdownMenuItem(value: 3, child: Text('3 Days (Standard SLA)')),
                            DropdownMenuItem(value: 5, child: Text('5 Days (Comprehensive)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _turnaroundDays = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Priority Selector
              Text('Priority Level', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: DesignPriority.values.map((p) {
                  final isSelected = _priority == p;
                  return ChoiceChip(
                    label: Text(p.label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),
                    selected: isSelected,
                    selectedColor: p.color,
                    onSelected: (val) {
                      if (val) setState(() => _priority = p);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Dispatch Revision Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
