import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/execution_models.dart';

/// Modal dialog to initialize a new project profile (PRD Section 8.1).
class ProjectFormModal extends StatefulWidget {
  final ValueChanged<ProjectMaster> onProjectCreated;

  const ProjectFormModal({
    super.key,
    required this.onProjectCreated,
  });

  static Future<void> show({
    required BuildContext context,
    ProjectMaster? initialProject,
    required ValueChanged<ProjectMaster> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProjectFormModal(
        onProjectCreated: onSubmit,
      ),
    );
  }

  @override
  State<ProjectFormModal> createState() => _ProjectFormModalState();
}

class _ProjectFormModalState extends State<ProjectFormModal> {
  final _titleController = TextEditingController(text: 'Ireo Grand Arch - 3BHK Smart Home');
  final _clientNameController = TextEditingController(text: 'Anand & Shalini Singhal');
  final _clientPhoneController = TextEditingController(text: '+91 98101 88299');
  final _clientEmailController = TextEditingController(text: 'anand.singhal@hdfcbank.com');
  final _addressController = TextEditingController(text: 'Tower 3, Flat 1802, Golf Course Ext Road');
  final _cityController = TextEditingController(text: 'Gurgaon, NCR');
  final _areaController = TextEditingController(text: '2800');
  final _pmController = TextEditingController(text: 'Rohit Deshmukh');
  final _supervisorController = TextEditingController(text: 'Sanjay Rawat');
  final _budgetController = TextEditingController(text: '2850000');

  ContractModel _selectedModel = ContractModel.turnkeyContract;
  DateTime _targetHandover = DateTime.now().add(const Duration(days: 75));

  @override
  void dispose() {
    _titleController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _pmController.dispose();
    _supervisorController.dispose();
    _budgetController.dispose();
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
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 780),
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
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: const Icon(Icons.domain_add_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Initialize New Execution Project',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
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

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Title & Location', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(controller: _titleController, decoration: _inputDecoration(isDark, 'Project Title')),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: TextField(controller: _addressController, decoration: _inputDecoration(isDark, 'Site Address'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _cityController, decoration: _inputDecoration(isDark, 'City'))),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text('Client Profile', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    TextField(controller: _clientNameController, decoration: _inputDecoration(isDark, 'Client Name(s)')),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _clientPhoneController, decoration: _inputDecoration(isDark, 'Mobile Phone'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _clientEmailController, decoration: _inputDecoration(isDark, 'Email Address'))),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text('Contract Commercials & Budget', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<ContractModel>(
                      initialValue: _selectedModel,
                      items: ContractModel.values.map((model) {
                        return DropdownMenuItem(value: model, child: Text(model.title, style: GoogleFonts.inter(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedModel = val);
                      },
                      decoration: _inputDecoration(isDark, ''),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(isDark, 'Total Contract Value (₹)'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _areaController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(isDark, 'Floor Area (Sq.Ft)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text('Project Team Assignment', style: _labelStyle(isDark)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _pmController, decoration: _inputDecoration(isDark, 'Project Manager'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _supervisorController, decoration: _inputDecoration(isDark, 'Site Supervisor'))),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Target Handover Date:', style: _labelStyle(isDark)),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _targetHandover,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => _targetHandover = picked);
                          },
                          icon: const Icon(Icons.event_available_rounded, size: 14),
                          label: Text('${_targetHandover.day}/${_targetHandover.month}/${_targetHandover.year}'),
                        ),
                      ],
                    ),
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Initialize Project & Generate WBS'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  InputDecoration _inputDecoration(bool isDark, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontSize: 11),
      filled: true,
      fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
      border: OutlineInputBorder(borderRadius: AppRadius.sm),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final budget = double.tryParse(_budgetController.text) ?? 2500000.0;
    final area = double.tryParse(_areaController.text) ?? 2000.0;

    final newProj = ProjectMaster(
      id: 'PRJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      projectCode: 'PRJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      projectTitle: title,
      clientName: _clientNameController.text.trim(),
      clientPhone: _clientPhoneController.text.trim(),
      clientEmail: _clientEmailController.text.trim(),
      siteAddress: _addressController.text.trim(),
      city: _cityController.text.trim(),
      floorAreaSqft: area,
      projectManagerName: _pmController.text.trim(),
      siteSupervisorName: _supervisorController.text.trim(),
      startDate: DateTime.now(),
      targetHandoverDate: _targetHandover,
      status: ProjectStatus.planning,
      timelineHealth: TimelineHealth.onTime,
      contractModel: _selectedModel,
      totalContractValue: budget,
      totalBilled: budget * 0.1, // 10% advance
      totalPaid: budget * 0.1,
      milestones: [
        MilestoneWorkStream(
          id: 'MS-NEW-01',
          projectId: 'PRJ-NEW',
          name: '1. Site Survey & 2D Layout Freeze',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          completionPercentage: 0.0,
          tasks: [],
        ),
        MilestoneWorkStream(
          id: 'MS-NEW-02',
          projectId: 'PRJ-NEW',
          name: '2. 3D Renders & Material Approval',
          startDate: DateTime.now().add(const Duration(days: 8)),
          endDate: DateTime.now().add(const Duration(days: 18)),
          completionPercentage: 0.0,
          tasks: [],
        ),
        MilestoneWorkStream(
          id: 'MS-NEW-03',
          projectId: 'PRJ-NEW',
          name: '3. Civil & Core MEP Rough-in',
          startDate: DateTime.now().add(const Duration(days: 19)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          completionPercentage: 0.0,
          tasks: [],
        ),
      ],
    );

    widget.onProjectCreated(newProj);
    Navigator.of(context).pop();
  }
}
