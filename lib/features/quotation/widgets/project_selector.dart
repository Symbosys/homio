import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';

/// Searchable project selector with project details and creation.
class ProjectSelector extends StatefulWidget {
  final ProjectInfo? selectedProject;
  final ValueChanged<ProjectInfo> onProjectSelected;

  const ProjectSelector({
    super.key,
    this.selectedProject,
    required this.onProjectSelected,
  });

  @override
  State<ProjectSelector> createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  final List<ProjectInfo> _allProjects = [
    ProjectInfo(
      id: 'PRJ-001',
      name: 'The Camellias Penthouse 2401',
      code: 'PRJ-GUR-2401',
      type: 'Turnkey Luxury Villa',
      location: 'DLF Phase 5',
      city: 'Gurgaon',
      projectManager: 'Rajesh Sharma',
      designer: 'Ananya Roy',
      totalBudget: 4500000.0,
    ),
    ProjectInfo(
      id: 'PRJ-002',
      name: 'Oberoi Sky City, Tower B-1804',
      code: 'PRJ-MUM-1804',
      type: 'Full Residential Interior',
      location: 'Borivali East',
      city: 'Mumbai',
      projectManager: 'Amitabh Joshi',
      designer: 'Devika Nair',
      totalBudget: 2200000.0,
    ),
    ProjectInfo(
      id: 'PRJ-003',
      name: 'Prestige Falcon City, Flat 1204',
      code: 'PRJ-BLR-1204',
      type: 'Residential Interior',
      location: 'Kanakapura Road',
      city: 'Bangalore',
      projectManager: 'Rajesh Sharma',
      designer: 'Rahul Sen',
      totalBudget: 1600000.0,
    ),
  ];

  ProjectInfo? _selected;
  bool _isCreatingNew = false;

  final _titleCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _designerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  @override
  void didUpdateWidget(ProjectSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProject != oldWidget.selectedProject) {
      _initSelection();
    }
  }

  void _initSelection() {
    if (widget.selectedProject != null) {
      final matchIndex = _allProjects.indexWhere((p) => p.id == widget.selectedProject!.id);
      if (matchIndex >= 0) {
        _selected = _allProjects[matchIndex];
      } else {
        _allProjects.insert(0, widget.selectedProject!);
        _selected = widget.selectedProject;
      }
    } else {
      _selected = _allProjects.isNotEmpty ? _allProjects.first : null;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locCtrl.dispose();
    _designerCtrl.dispose();
    super.dispose();
  }

  void _saveNewProject() {
    if (_titleCtrl.text.isEmpty || _locCtrl.text.isEmpty) return;
    final newPrj = ProjectInfo(
      id: 'PRJ-${DateTime.now().millisecondsSinceEpoch}',
      name: _titleCtrl.text,
      code: 'PRJ-NEW-${DateTime.now().millisecond}',
      location: _locCtrl.text,
      projectManager: 'Rajesh Sharma',
      designer: _designerCtrl.text.isNotEmpty ? _designerCtrl.text : 'Ananya Roy',
    );
    setState(() {
      _allProjects.insert(0, newPrj);
      _selected = newPrj;
      _isCreatingNew = false;
    });
    widget.onProjectSelected(newPrj);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.home_work_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Project Association',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() => _isCreatingNew = !_isCreatingNew);
                },
                icon: Icon(_isCreatingNew ? Icons.search_rounded : Icons.add_business_rounded, size: 14),
                label: Text(
                  _isCreatingNew ? 'Select Existing' : '+ New Project',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_isCreatingNew) ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Project Title *',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _locCtrl,
                    decoration: InputDecoration(
                      labelText: 'Site Location / Society *',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _designerCtrl,
                    decoration: InputDecoration(
                      labelText: 'Lead Designer',
                      hintText: 'e.g. Ananya Roy',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saveNewProject,
              icon: const Icon(Icons.check_rounded, size: 14),
              label: const Text('Add & Associate Project'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
              ),
            ),
          ] else ...[
            DropdownButtonFormField<String>(
              initialValue: _selected?.id,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Select project...',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(borderRadius: AppRadius.sm),
              ),
              items: _allProjects.map((prj) {
                return DropdownMenuItem<String>(
                  value: prj.id,
                  child: Text(
                    '${prj.name} (${prj.code}) • ${prj.designer}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  final found = _allProjects.firstWhere((p) => p.id == id);
                  setState(() => _selected = found);
                  widget.onProjectSelected(found);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
