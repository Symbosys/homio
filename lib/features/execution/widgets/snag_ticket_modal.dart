import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Modal dialog for raising a new snag or reviewing/resolving an existing ticket.
class SnagTicketModal extends StatefulWidget {
  final SnagTicket? initialTicket;
  final List<ProjectMaster> projects;
  final ValueChanged<SnagTicket> onSave;

  const SnagTicketModal({
    super.key,
    this.initialTicket,
    required this.projects,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required ProjectMaster project,
    SnagTicket? initialTicket,
    required ValueChanged<SnagTicket> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SnagTicketModal(
        projects: [project],
        initialTicket: initialTicket,
        onSave: onSave,
      ),
    );
  }

  @override
  State<SnagTicketModal> createState() => _SnagTicketModalState();
}

class _SnagTicketModalState extends State<SnagTicketModal> {
  late String _selectedProjectId;
  late SnagCategory _selectedCategory;
  late TaskPriority _selectedPriority;
  late SnagStatus _selectedStatus;

  final _roomController = TextEditingController(text: 'Master Bedroom Wardrobe');
  final _descController = TextEditingController(
    text: 'Drawer front gap uneven by 3mm on the right side. Soft-close runner jamming.',
  );
  final _resolutionNotesController = TextEditingController();
  final _assignedController = TextEditingController(text: 'Sanjay Rawat (Supervisor)');
  final List<String> _checklist = [
    'Inspect runner alignment with spirit level',
    'Re-adjust hinge depth screws',
    'Test soft-close rebound 10 times',
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.initialTicket;
    _selectedProjectId = t?.projectId ?? widget.projects.first.id;
    _selectedCategory = t?.category ?? SnagCategory.qualityDefect;
    _selectedPriority = t?.priority ?? TaskPriority.high;
    _selectedStatus = t?.status ?? SnagStatus.open;
    if (t != null) {
      _roomController.text = t.roomArea;
      _descController.text = t.description;
      _assignedController.text = t.assignedTo;
      if (t.resolutionNotes != null) _resolutionNotesController.text = t.resolutionNotes!;
    }
  }

  @override
  void dispose() {
    _roomController.dispose();
    _descController.dispose();
    _resolutionNotesController.dispose();
    _assignedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNew = widget.initialTicket == null;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lg,
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.8),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Column(
          children: [
            // Header
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
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.report_problem_rounded, size: 18, color: AppColors.error),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isNew ? 'Raise New Snag / Client Complaint' : 'Inspect & Resolve Snag Ticket',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Priority
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<SnagCategory>(
                            initialValue: _selectedCategory,
                            items: SnagCategory.values.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat.label, style: GoogleFonts.inter(fontSize: 12)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                            decoration: const InputDecoration(labelText: 'Complaint Category'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<TaskPriority>(
                            initialValue: _selectedPriority,
                            items: TaskPriority.values.map((p) {
                              return DropdownMenuItem(value: p, child: Text(p.label, style: GoogleFonts.inter(fontSize: 12)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPriority = val);
                            },
                            decoration: const InputDecoration(labelText: 'Severity Priority'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
                            decoration: const InputDecoration(labelText: 'Associated Project'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _roomController,
                            decoration: const InputDecoration(labelText: 'Room / Area Location'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Detailed Defect Description'),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _assignedController,
                      decoration: const InputDecoration(labelText: 'Assignee Contractor / Supervisor'),
                    ),
                    const SizedBox(height: 14),

                    // Corrective Action Checklist
                    Text('Corrective Action Checklist:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    ..._checklist.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check_box_outline_blank_rounded, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item, style: GoogleFonts.inter(fontSize: 11))),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 14),

                    // Status & Resolution Section
                    if (!isNew) ...[
                      const Divider(height: 20),
                      Text('Ticket Resolution & Client Acceptance', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<SnagStatus>(
                        initialValue: _selectedStatus,
                        items: SnagStatus.values.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s.label, style: GoogleFonts.inter(fontSize: 12)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                        decoration: const InputDecoration(labelText: 'Current Resolution Status'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _resolutionNotesController,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Supervisor Rectification Notes'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitSnag,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: Text(isNew ? 'Submit Snag Ticket' : 'Update & Log Resolution'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSnag() {
    final proj = widget.projects.firstWhere((p) => p.id == _selectedProjectId);

    final ticket = SnagTicket(
      id: widget.initialTicket?.id ?? 'SNG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      ticketNumber: widget.initialTicket?.ticketNumber ?? 'SNG-${proj.projectCode.split('-').last}-0${widget.projects.length + 1}',
      projectId: proj.id,
      projectTitle: proj.projectTitle,
      roomArea: _roomController.text.trim(),
      category: _selectedCategory,
      description: _descController.text.trim(),
      priority: _selectedPriority,
      status: _selectedStatus,
      raisedAt: widget.initialTicket?.raisedAt ?? DateTime.now(),
      slaDeadline: widget.initialTicket?.slaDeadline ?? DateTime.now().add(const Duration(hours: 48)),
      raisedBy: widget.initialTicket?.raisedBy ?? 'Site Inspector',
      assignedTo: _assignedController.text.trim(),
      correctiveChecklist: _checklist,
      checklistDone: _checklist.map((_) => _selectedStatus == SnagStatus.resolvedOnTime).toList(),
      resolutionNotes: _resolutionNotesController.text.trim().isEmpty ? null : _resolutionNotesController.text.trim(),
      resolvedAt: _selectedStatus == SnagStatus.resolvedOnTime ? DateTime.now() : null,
    );

    widget.onSave(ticket);
    Navigator.of(context).pop();
  }
}
