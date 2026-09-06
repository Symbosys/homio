import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/design_models.dart';

/// Modal for uploading new 2D CAD drawings or 3D photorealistic renders.
class UploadDeliverableModal extends StatefulWidget {
  final ValueChanged<DesignDeliverable> onUpload;
  final String? initialProjectCode;

  const UploadDeliverableModal({
    super.key,
    required this.onUpload,
    this.initialProjectCode,
  });

  static void show({
    required BuildContext context,
    required ValueChanged<DesignDeliverable> onUpload,
    String? initialProjectCode,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => UploadDeliverableModal(
        onUpload: onUpload,
        initialProjectCode: initialProjectCode,
      ),
    );
  }

  @override
  State<UploadDeliverableModal> createState() => _UploadDeliverableModalState();
}

class _UploadDeliverableModalState extends State<UploadDeliverableModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _roomAreaController = TextEditingController(text: 'Master Suite Bedroom');
  final _changelogController = TextEditingController(text: 'Initial design release for client review');
  final _versionController = TextEditingController(text: 'v1.0');

  String _selectedProject = 'PRJ-104';
  DesignCategory _selectedCategory = DesignCategory.twoDCad;
  DesignFileType _selectedFileType = DesignFileType.dwg;
  String _designerName = 'Ananya Roy (Lead Architect)';
  final bool _isFileSimulated = true;
  String _simulatedFileName = 'Master_Bedroom_Layout_v1.0.dwg';
  final int _simulatedFileSize = 14200000;

  @override
  void initState() {
    super.initState();
    if (widget.initialProjectCode != null) {
      _selectedProject = widget.initialProjectCode!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _roomAreaController.dispose();
    _changelogController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newDeliverable = DesignDeliverable(
      id: 'DES-${DateTime.now().millisecondsSinceEpoch}',
      projectCode: _selectedProject,
      projectName: _selectedProject == 'PRJ-104'
          ? 'DLF The Camellias - 4BHK Penthouse'
          : (_selectedProject == 'PRJ-105'
              ? 'Godrej Woods Tower B - 3BHK'
              : (_selectedProject == 'PRJ-106'
                  ? 'Prestige Golfshire Villa #42'
                  : 'Oberoi Sky City Tower E')),
      title: _titleController.text.trim(),
      roomArea: _roomAreaController.text.trim(),
      category: _selectedCategory,
      fileType: _selectedFileType,
      currentVersion: _versionController.text.trim(),
      status: DesignReviewStatus.submitted,
      designerName: _designerName,
      designerAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
      clientName: _selectedProject == 'PRJ-104'
          ? 'Vikram Malhotra'
          : (_selectedProject == 'PRJ-105'
              ? 'Radhika Singhania'
              : (_selectedProject == 'PRJ-106'
                  ? 'Col. K.S. Rathore'
                  : 'Siddharth Shroff')),
      createdAt: DateTime.now(),
      clientReviewSlaDeadline: DateTime.now().add(const Duration(hours: 48)),
      revisionCount: 1,
      fileSizeBytes: _simulatedFileSize,
      thumbnailUrl: _selectedCategory == DesignCategory.threeDRender
          ? 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=600&q=80'
          : 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&q=80',
      fileUrl: 'https://storage.homio.internal/designs/$_selectedProject/$_simulatedFileName',
      tags: [_selectedFileType.extension.replaceAll('.', '').toUpperCase(), _selectedCategory.label],
      versionHistory: [
        DesignVersionRecord(
          versionTag: _versionController.text.trim(),
          fileName: _simulatedFileName,
          fileUrl: 'https://storage.homio.internal/designs/$_selectedProject/$_simulatedFileName',
          fileSizeBytes: _simulatedFileSize,
          uploadedAt: DateTime.now(),
          uploadedByName: _designerName,
          changelogNote: _changelogController.text.trim(),
          reviewStatus: DesignReviewStatus.submitted,
          turnaroundHours: 24,
        ),
      ],
    );

    widget.onUpload(newDeliverable);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Design Deliverable',
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Submit 2D CAD blueprints, 3D renders, or BOQ specs',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // Drag & Drop simulated dropzone
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.drive_folder_upload_outlined, size: 36, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        _isFileSimulated ? _simulatedFileName : 'Drag & Drop DWG, SKP, MAX, PDF, JPG here',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Supports files up to 500 MB with automatic versioning',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Row: Project & Category
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedProject,
                        decoration: const InputDecoration(labelText: 'Project *'),
                        items: const [
                          DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 (Camellias)')),
                          DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 (Godrej Woods)')),
                          DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 (Prestige Golfshire)')),
                          DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 (Oberoi Sky City)')),
                        ],
                        onChanged: (v) => setState(() => _selectedProject = v!),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<DesignCategory>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(labelText: 'Category *'),
                        items: DesignCategory.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.label));
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Deliverable Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Drawing / Deliverable Title *',
                    hintText: 'e.g. Living Room False Ceiling Level Alignment CAD',
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),

                // Room Area & Version
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _roomAreaController,
                        decoration: const InputDecoration(
                          labelText: 'Room / Area *',
                          hintText: 'e.g. Master Bedroom, Kitchen',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Area required' : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        controller: _versionController,
                        decoration: const InputDecoration(
                          labelText: 'Version Tag *',
                          hintText: 'v1.0',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Version required' : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<DesignFileType>(
                        initialValue: _selectedFileType,
                        decoration: const InputDecoration(labelText: 'Format *'),
                        items: DesignFileType.values.map((f) {
                          return DropdownMenuItem(value: f, child: Text(f.extension));
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedFileType = v!;
                            _simulatedFileName = 'Deliverable_${_versionController.text}${v.extension}';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Changelog / Designer Notes
                TextFormField(
                  controller: _changelogController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Revision Changelog / Designer Note',
                    hintText: 'Detail layers added, material tags, or client feedback changes...',
                  ),
                ),
                const SizedBox(height: 14),

                // Assigned Designer
                DropdownButtonFormField<String>(
                  initialValue: _designerName,
                  decoration: const InputDecoration(labelText: 'Lead Designer Attribution'),
                  items: const [
                    DropdownMenuItem(value: 'Ananya Roy (Lead Architect)', child: Text('Ananya Roy (Lead Architect)')),
                    DropdownMenuItem(value: 'Praveen Kumar (MEP Lead)', child: Text('Praveen Kumar (MEP Lead)')),
                    DropdownMenuItem(value: 'Rohit Deshmukh (Project Manager)', child: Text('Rohit Deshmukh (PM)')),
                    DropdownMenuItem(value: 'Arjun Swaminathan (Design Lead)', child: Text('Arjun Swaminathan (Design Lead)')),
                  ],
                  onChanged: (v) => setState(() => _designerName = v!),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: const Text('Submit Deliverable'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
