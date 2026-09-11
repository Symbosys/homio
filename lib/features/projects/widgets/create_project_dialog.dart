import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../data/projects_repository.dart';
import '../domain/projects_enums.dart';
import '../domain/projects_models.dart';

class CreateProjectDialog extends StatefulWidget {
  final ValueChanged<Project>? onProjectCreated;

  const CreateProjectDialog({
    super.key,
    this.onProjectCreated,
  });

  static Future<Project?> show(BuildContext context) {
    return showDialog<Project>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const CreateProjectDialog(),
    );
  }

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _clientNameCtrl;
  late final TextEditingController _clientPhoneCtrl;
  late final TextEditingController _clientEmailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _contractAmountCtrl;
  late final TextEditingController _pmCtrl;
  late final TextEditingController _designerCtrl;
  late final TextEditingController _descCtrl;

  ProjectType _selectedType = ProjectType.turnkey;
  ProjectStage _selectedStage = ProjectStage.planning;
  final ProjectStatus _selectedStatus = ProjectStatus.planned;
  DateTime _expectedCompletion = DateTime.now().add(const Duration(days: 90));

  @override
  void initState() {
    super.initState();
    final randomSuffix = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    _nameCtrl = TextEditingController(text: 'Oberoi Sky City - Luxury Penthouse');
    _codeCtrl = TextEditingController(text: 'HOM-PRJ-$randomSuffix');
    _categoryCtrl = TextEditingController(text: 'Luxury Residential');
    _clientNameCtrl = TextEditingController(text: 'Vikram & Priya Singhal');
    _clientPhoneCtrl = TextEditingController(text: '+91 98201 55432');
    _clientEmailCtrl = TextEditingController(text: 'vikram.singhal@outlook.com');
    _addressCtrl = TextEditingController(text: 'Tower B, Penthouse 4201, Western Express Highway');
    _cityCtrl = TextEditingController(text: 'Mumbai');
    _areaCtrl = TextEditingController(text: '3200');
    _contractAmountCtrl = TextEditingController(text: '58.5');
    _pmCtrl = TextEditingController(text: 'Neha Deshmukh');
    _designerCtrl = TextEditingController(text: 'Ar. Anya Sen');
    _descCtrl = TextEditingController(
      text: 'Full architectural interior fit-out, Italian marble flooring, custom fluted millwork, and smart automation.',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _categoryCtrl.dispose();
    _clientNameCtrl.dispose();
    _clientPhoneCtrl.dispose();
    _clientEmailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    _contractAmountCtrl.dispose();
    _pmCtrl.dispose();
    _designerCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedCompletion,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _expectedCompletion = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final areaSqFt = double.tryParse(_areaCtrl.text.trim()) ?? 2500.0;
    final contractLakhs = double.tryParse(_contractAmountCtrl.text.trim()) ?? 50.0;

    final newProject = Project(
      id: 'HOM-PRJ-${now.millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim().isNotEmpty
          ? _codeCtrl.text.trim()
          : 'PRJ-${now.millisecondsSinceEpoch.toString().substring(8)}',
      type: _selectedType,
      status: _selectedStatus,
      health: ProjectHealth.healthy,
      currentStage: _selectedStage,
      description: _descCtrl.text.trim(),
      category: _categoryCtrl.text.trim().isNotEmpty
          ? _categoryCtrl.text.trim()
          : 'Residential Turnkey',
      clientId: 'HOM-CUST-${now.millisecondsSinceEpoch.toString().substring(8)}',
      clientName: _clientNameCtrl.text.trim(),
      clientPhone: _clientPhoneCtrl.text.trim(),
      clientEmail: _clientEmailCtrl.text.trim(),
      siteName: _nameCtrl.text.trim(),
      siteAddress: _addressCtrl.text.trim(),
      siteCity: _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : 'Mumbai',
      siteState: 'Maharashtra',
      sitePincode: '400066',
      siteContactPerson: _clientNameCtrl.text.trim(),
      siteContactNumber: _clientPhoneCtrl.text.trim(),
      totalAreaSqFt: areaSqFt,
      areas: [
        ProjectArea(
          id: 'A1',
          name: 'Living & Dining Area',
          areaSqFt: areaSqFt * 0.45,
          roomType: 'Living',
        ),
        ProjectArea(
          id: 'A2',
          name: 'Master Suite',
          areaSqFt: areaSqFt * 0.30,
          roomType: 'Bedroom',
        ),
        ProjectArea(
          id: 'A3',
          name: 'Gourmet Kitchen',
          areaSqFt: areaSqFt * 0.25,
          roomType: 'Kitchen',
        ),
      ],
      team: [
        ProjectTeamMember(
          userId: 'PM-01',
          name: _pmCtrl.text.trim().isNotEmpty ? _pmCtrl.text.trim() : 'Neha Deshmukh',
          role: 'Project Manager',
          assignmentDate: now,
          responsibilities: 'Overall timeline, client coordination, site governance',
        ),
        ProjectTeamMember(
          userId: 'DES-01',
          name: _designerCtrl.text.trim().isNotEmpty ? _designerCtrl.text.trim() : 'Ar. Anya Sen',
          role: 'Lead Architect',
          assignmentDate: now,
          responsibilities: 'BIM drawings, 3D visualizations, material schedule',
        ),
        ProjectTeamMember(
          userId: 'SUP-01',
          name: 'Arun Kumar',
          role: 'Site Supervisor',
          assignmentDate: now,
          responsibilities: 'Daily site checks, contractor management, quality checks',
        ),
      ],
      projectManager: _pmCtrl.text.trim().isNotEmpty ? _pmCtrl.text.trim() : 'Neha Deshmukh',
      designer: _designerCtrl.text.trim().isNotEmpty ? _designerCtrl.text.trim() : 'Ar. Anya Sen',
      siteSupervisor: 'Arun Kumar',
      salesOwner: 'Ananya Verma',
      createdDate: now,
      plannedStartDate: now,
      expectedCompletion: _expectedCompletion,
      lastUpdated: now,
      progressPercent: 0,
      designProgress: 0,
      executionProgress: 0,
      procurementProgress: 0,
      paymentProgress: 0,
      contractAmountLakhs: contractLakhs,
      totalReceivedLakhs: 0.0,
      totalOutstandingLakhs: contractLakhs,
      totalMilestones: 4,
      completedMilestones: 0,
      totalTasks: 8,
      completedTasks: 0,
      pendingTasks: 8,
      overdueTasks: 0,
      pendingApprovals: 1,
      openComplaints: 0,
    );

    ProjectsRepository().addProject(newProject);
    widget.onProjectCreated?.call(newProject);
    Navigator.of(context).pop(newProject);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Project "${newProject.name}" created successfully!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 820),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.domain_add_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Initialize project profile, client details, site parameters & commercials',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Scrollable Form Body
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: PROJECT ESSENTIALS
                      _sectionTitle('Project Essentials', Icons.info_outline_rounded, isDark),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Project Title *',
                          hintText: 'e.g. DLF Camellias 4BHK Turnkey',
                          prefixIcon: Icon(Icons.apartment_rounded, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Project title is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codeCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Project Code',
                                hintText: 'e.g. CAM-1402',
                                prefixIcon: Icon(Icons.tag_rounded, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<ProjectType>(
                              initialValue: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Project Type',
                                prefixIcon: Icon(Icons.category_outlined, size: 18),
                              ),
                              items: ProjectType.values
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _selectedType = v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _categoryCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                hintText: 'e.g. Luxury Residential',
                                prefixIcon: Icon(Icons.layers_outlined, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<ProjectStage>(
                              initialValue: _selectedStage,
                              decoration: const InputDecoration(
                                labelText: 'Initial Stage',
                                prefixIcon: Icon(Icons.stairs_outlined, size: 18),
                              ),
                              items: ProjectStage.values
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _selectedStage = v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description & Scope Overview',
                          hintText: 'Key deliverables, architectural styles, or special instructions',
                        ),
                      ),

                      const SizedBox(height: 24),

                      // SECTION 2: CLIENT DETAILS
                      _sectionTitle('Client Details', Icons.person_outline_rounded, isDark),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _clientNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Client Name *',
                          hintText: 'e.g. Rahul & Neha Sharma',
                          prefixIcon: Icon(Icons.badge_outlined, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Client name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _clientPhoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Contact Phone',
                                hintText: '+91 98101 23456',
                                prefixIcon: Icon(Icons.phone_outlined, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _clientEmailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'rahul.sharma@gmail.com',
                                prefixIcon: Icon(Icons.email_outlined, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // SECTION 3: SITE & COMMERCIALS
                      _sectionTitle('Site Coordinates & Commercials', Icons.location_on_outlined, isDark),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Site Address',
                          hintText: 'e.g. Flat 1402, DLF The Camellias, Golf Course Road',
                          prefixIcon: Icon(Icons.map_outlined, size: 18),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityCtrl,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                hintText: 'Mumbai, Gurugram, etc.',
                                prefixIcon: Icon(Icons.location_city_rounded, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _areaCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Total Area (Sq.Ft)',
                                hintText: '3200',
                                prefixIcon: Icon(Icons.square_foot_rounded, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contractAmountCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Contract Amount (₹ Lakhs)',
                                hintText: '58.5',
                                prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: InkWell(
                              onTap: _pickDate,
                              borderRadius: BorderRadius.circular(8),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Target Handover',
                                  prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                                ),
                                child: Text(
                                  DateFormat('dd MMM yyyy').format(_expectedCompletion),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // SECTION 4: TEAM ASSIGNMENT
                      _sectionTitle('Team Assignment', Icons.group_outlined, isDark),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pmCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Project Manager',
                                hintText: 'Neha Deshmukh',
                                prefixIcon: Icon(Icons.manage_accounts_outlined, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _designerCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Lead Designer',
                                hintText: 'Ar. Anya Sen',
                                prefixIcon: Icon(Icons.design_services_outlined, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add_task_rounded, size: 18),
                    label: const Text('Create Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 1,
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

  Widget _sectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
