import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import 'design_shared_widgets.dart';

/// Modal to batch-select deliverables and dispatch them to the client for sign-off.
class SubmitToClientModal extends StatefulWidget {
  final List<DesignDeliverable> availableDeliverables;
  final String? initialProjectCode;
  final void Function(List<String> deliverableIds, String clientName, DateTime deadline, bool allowDownload) onSubmit;

  const SubmitToClientModal({
    super.key,
    required this.availableDeliverables,
    this.initialProjectCode,
    required this.onSubmit,
  });

  static void show({
    required BuildContext context,
    required List<DesignDeliverable> availableDeliverables,
    String? initialProjectCode,
    required void Function(List<String> deliverableIds, String clientName, DateTime deadline, bool allowDownload) onSubmit,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => SubmitToClientModal(
        availableDeliverables: availableDeliverables,
        initialProjectCode: initialProjectCode,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<SubmitToClientModal> createState() => _SubmitToClientModalState();
}

class _SubmitToClientModalState extends State<SubmitToClientModal> {
  final Set<String> _selectedIds = {};
  late TextEditingController _clientNameController;
  DateTime _reviewDeadline = DateTime.now().add(const Duration(days: 3));
  bool _allowDownload = true;
  bool _sendEmailSmsNotification = true;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(
      text: widget.availableDeliverables.isNotEmpty ? widget.availableDeliverables.first.clientName : 'Client',
    );

    // Preselect items eligible for review
    for (final d in widget.availableDeliverables) {
      if (d.status == DesignReviewStatus.draft || d.status == DesignReviewStatus.internalReview || d.status == DesignReviewStatus.revised) {
        _selectedIds.add(d.id);
      }
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one deliverable to submit.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final clientName = _clientNameController.text.trim();
    if (clientName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter client name.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onSubmit(_selectedIds.toList(), clientName, _reviewDeadline, _allowDownload);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedIds.length} deliverable(s) dispatched to $clientName for sign-off.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.send_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Submit Drawings to Client for Review',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Select design deliverables to initiate the client sign-off cycle and track SLA.',
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
            ),
            const Divider(height: 1),

            // Options Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _clientNameController,
                      decoration: InputDecoration(
                        labelText: 'Client Recipient Name *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _reviewDeadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 60)),
                        );
                        if (picked != null) {
                          setState(() => _reviewDeadline = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Review SLA Deadline *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          isDense: true,
                          suffixIcon: const Icon(Icons.calendar_today_rounded, size: 16),
                        ),
                        child: Text(
                          '${_reviewDeadline.day}/${_reviewDeadline.month}/${_reviewDeadline.year}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Toggles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Checkbox(
                    value: _allowDownload,
                    onChanged: (val) => setState(() => _allowDownload = val ?? true),
                  ),
                  Text('Allow file downloads in client portal', style: GoogleFonts.inter(fontSize: 12)),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: _sendEmailSmsNotification,
                    onChanged: (val) => setState(() => _sendEmailSmsNotification = val ?? true),
                  ),
                  Text('Dispatch Email & WhatsApp Notification', style: GoogleFonts.inter(fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Eligible Deliverables (${_selectedIds.length}/${widget.availableDeliverables.length} selected):',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedIds.length == widget.availableDeliverables.length) {
                          _selectedIds.clear();
                        } else {
                          _selectedIds.addAll(widget.availableDeliverables.map((d) => d.id));
                        }
                      });
                    },
                    child: Text(_selectedIds.length == widget.availableDeliverables.length ? 'Deselect All' : 'Select All'),
                  ),
                ],
              ),
            ),

            // Deliverables List
            Expanded(
              child: widget.availableDeliverables.isEmpty
                  ? const DesignEmptyState(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'No Deliverables Ready',
                      message: 'All deliverables are currently approved or already sent to the client.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: widget.availableDeliverables.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final d = widget.availableDeliverables[index];
                        final isSelected = _selectedIds.contains(d.id);

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : (isDark ? AppColors.darkCard : AppColors.lightCard),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedIds.add(d.id);
                                } else {
                                  _selectedIds.remove(d.id);
                                }
                              });
                            },
                            title: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    d.title,
                                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    d.currentVersion,
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${d.projectCode} • ${d.roomArea} • Lead: ${d.designerName}',
                              style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                            ),
                            secondary: DesignStatusBadge(status: d.status, fontSize: 10),
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        );
                      },
                    ),
            ),

            // Modal Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
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
                    label: Text('Send to Client (${_selectedIds.length})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
}
