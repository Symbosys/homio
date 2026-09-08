import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import 'design_shared_widgets.dart';

/// Modal dialog to assemble and issue a Good-For-Construction (GFC) Execution Handover package.
class HandoverPackageModal extends StatefulWidget {
  final List<DesignDeliverable> approvedDeliverables;
  final String projectCode;
  final String projectName;
  final ValueChanged<DesignHandover> onCreateHandover;

  const HandoverPackageModal({
    super.key,
    required this.approvedDeliverables,
    required this.projectCode,
    required this.projectName,
    required this.onCreateHandover,
  });

  static void show({
    required BuildContext context,
    required List<DesignDeliverable> approvedDeliverables,
    required String projectCode,
    required String projectName,
    required ValueChanged<DesignHandover> onCreateHandover,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => HandoverPackageModal(
        approvedDeliverables: approvedDeliverables,
        projectCode: projectCode,
        projectName: projectName,
        onCreateHandover: onCreateHandover,
      ),
    );
  }

  @override
  State<HandoverPackageModal> createState() => _HandoverPackageModalState();
}

class _HandoverPackageModalState extends State<HandoverPackageModal> {
  final _packageNameController = TextEditingController();
  final _packageVersionController = TextEditingController(text: 'PKG-GFC-v1.0');
  final _executionManagerController = TextEditingController(text: 'Suresh Raina (Site Lead PM)');
  final Set<String> _selectedDeliverableIds = {};

  final List<HandoverChecklistItem> _checklist = [
    const HandoverChecklistItem(
      id: 'chk-1',
      title: 'Architectural Approval & Wet Stamping',
      description: 'Senior Project Architect has verified wall dimensions and clearance tolerances.',
      isSatisfied: true,
      category: 'Architecture',
    ),
    const HandoverChecklistItem(
      id: 'chk-2',
      title: 'MEP Conflict Matrix Cleared',
      description: 'Electrical conduits, plumbing drains, and HVAC ducts do not clash in ceiling plenum.',
      isSatisfied: true,
      category: 'MEP',
    ),
    const HandoverChecklistItem(
      id: 'chk-3',
      title: 'Bill of Quantities (BOQ) Reconciled',
      description: 'Vendor codes, millwork veneer codes, and finishes match latest cost sheet.',
      isSatisfied: false,
      category: 'Procurement',
    ),
    const HandoverChecklistItem(
      id: 'chk-4',
      title: 'Client Formal Sign-Off Verified',
      description: 'Client written or digital signature received on final revision layout.',
      isSatisfied: true,
      category: 'Governance',
    ),
    const HandoverChecklistItem(
      id: 'chk-5',
      title: 'Site PM Kick-off Readiness',
      description: 'Site supervisor received preliminary prints and access permissions.',
      isSatisfied: false,
      category: 'Execution',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _packageNameController.text = '${widget.projectName} — GFC Package';
    // Select all passed approved deliverables
    for (final d in widget.approvedDeliverables) {
      _selectedDeliverableIds.add(d.id);
    }
  }

  @override
  void dispose() {
    _packageNameController.dispose();
    _packageVersionController.dispose();
    _executionManagerController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _packageNameController.text.trim();
    final version = _packageVersionController.text.trim();
    final manager = _executionManagerController.text.trim();

    if (name.isEmpty || version.isEmpty || manager.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all mandatory package fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedDeliverableIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one approved deliverable.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newPackage = DesignHandover(
      id: 'hnd-${DateTime.now().millisecondsSinceEpoch}',
      projectCode: widget.projectCode,
      projectName: widget.projectName,
      handoverName: name,
      packageVersion: version,
      includedDeliverableIds: _selectedDeliverableIds.toList(),
      checklist: _checklist,
      status: HandoverStatus.draft,
      submittedDate: DateTime.now(),
      executionManager: manager,
    );

    widget.onCreateHandover(newPackage);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Handover Package "$version" created successfully!'),
        backgroundColor: AppColors.success,
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
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 760),
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
                      color: const Color(0xFF059669).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.handshake_outlined, color: Color(0xFF059669), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Execution Handover Package',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Generate verified Good-for-Construction (GFC) asset bundle for site execution.',
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Name & Version
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Package Name *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _packageNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Package Version Tag *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _packageVersionController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row 2: Assigned Execution Lead PM
                    Text('Assigned Execution Lead PM *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _executionManagerController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Suresh Raina (Site Lead PM)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // Section: Checklist Validation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GFC Verification Checklist', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text(
                          '${_checklist.where((c) => c.isSatisfied).length}/${_checklist.length} satisfied',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _checklist.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;

                          return CheckboxListTile(
                            value: item.isSatisfied,
                            onChanged: (val) {
                              setState(() {
                                _checklist[idx] = item.copyWith(isSatisfied: val ?? false);
                              });
                            },
                            title: Text(item.title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              '${item.category} • ${item.description}',
                              style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section: Approved Deliverables to Include
                    Text(
                      'Approved Deliverables Included (${_selectedDeliverableIds.length}/${widget.approvedDeliverables.length}):',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    if (widget.approvedDeliverables.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'No approved deliverables available for ${widget.projectCode}. Approve deliverables in the Approval Loop first.',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.warning),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: widget.approvedDeliverables.map((d) {
                            final isIncluded = _selectedDeliverableIds.contains(d.id);

                            return CheckboxListTile(
                              value: isIncluded,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedDeliverableIds.add(d.id);
                                  } else {
                                    _selectedDeliverableIds.remove(d.id);
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
                                  DesignFileTypeBadge(fileType: d.fileType, fontSize: 10),
                                ],
                              ),
                              subtitle: Text(
                                '${d.roomArea} • Ver: ${d.currentVersion} • Size: ${d.fileSizeBytesFormatted}',
                                style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                              ),
                              dense: true,
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Modal Actions
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
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                    label: const Text('Publish & Handover Package'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
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
