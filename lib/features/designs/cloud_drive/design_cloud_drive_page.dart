import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/design_models.dart';
import '../models/design_mock_data.dart';
import '../widgets/design_header.dart';
import '../widgets/admin_delete_lock_dialog.dart';
import '../widgets/cloud_share_link_modal.dart';

/// Secure Digital Asset Management (DAM) Cloud Drive (PRD Section 15.2, Sidebar 6.3).
/// Features auto-generated project folder trees and Super Admin 2FA deletion locks.
class DesignCloudDrivePage extends StatefulWidget {
  const DesignCloudDrivePage({super.key});

  @override
  State<DesignCloudDrivePage> createState() => _DesignCloudDrivePageState();
}

class _DesignCloudDrivePageState extends State<DesignCloudDrivePage> {
  late List<CloudDriveFolder> _folders;
  late List<CloudDriveFile> _files;
  String _selectedProject = 'PRJ-104';
  CloudDriveFolder? _activeFolder;
  String _searchQuery = '';
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _folders = List.from(DesignMockData.cloudFolders);
    _files = List.from(DesignMockData.cloudFiles);
  }

  List<CloudDriveFolder> get _filteredFolders {
    return _folders.where((f) => f.projectCode == _selectedProject).toList();
  }

  List<CloudDriveFile> get _filteredFiles {
    return _files.where((file) {
      if (file.projectCode != _selectedProject) return false;
      if (_activeFolder != null && file.folderId != _activeFolder!.id) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!file.fileName.toLowerCase().contains(q)) return false;
      }
      return true;
    }).toList();
  }

  void _handleDeleteAttempt(String itemName, VoidCallback onAuthorizedDelete) {
    AdminDeleteLockDialog.show(
      context: context,
      itemName: itemName,
      onAuthorizedDelete: onAuthorizedDelete,
    );
  }

  void _handleShare(String itemName, {bool isFolder = false}) {
    CloudShareLinkModal.show(
      context: context,
      itemName: itemName,
      isFolder: isFolder,
    );
  }

  void _handleCreateFolder() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create New Cloud Folder'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Folder Name',
            hintText: 'e.g. 07_Site_Inspection_Dossiers',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _folders.add(
                    CloudDriveFolder(
                      id: 'FLD-${DateTime.now().millisecondsSinceEpoch}',
                      projectCode: _selectedProject,
                      name: nameController.text.trim(),
                      folderType: CloudFolderType.cadDrawings,
                      itemCount: 0,
                      totalSizeBytes: 0,
                      lastModified: DateTime.now(),
                    ),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Folder "${nameController.text.trim()}" created in $_selectedProject.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Create Folder'),
          ),
        ],
      ),
    );
  }

  void _handleUploadFile() {
    final fileNameController = TextEditingController(text: 'Revision_Blueprint_${DateTime.now().millisecond}.dwg');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Upload File to Cloud Drive'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(labelText: 'File Name'),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.file_present_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(child: Text('Simulated file size: 18.4 MB (AutoCAD 2026 format)')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (fileNameController.text.trim().isNotEmpty) {
                final targetFolderId = _activeFolder?.id ?? (_filteredFolders.isNotEmpty ? _filteredFolders.first.id : 'FLD-ROOT');
                setState(() {
                  _files.insert(
                    0,
                    CloudDriveFile(
                      id: 'FIL-${DateTime.now().millisecondsSinceEpoch}',
                      projectCode: _selectedProject,
                      folderId: targetFolderId,
                      fileName: fileNameController.text.trim(),
                      fileType: DesignFileType.dwg,
                      fileSizeBytes: 18400000,
                      uploadedAt: DateTime.now(),
                      uploadedBy: 'Ananya Roy (Lead Architect)',
                      downloadUrl: 'https://storage.homio.internal/designs/$_selectedProject/${fileNameController.text.trim()}',
                      thumbnailUrl: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=400&q=80',
                      versionTag: 'v1.0',
                      tags: ['DWG', 'Uploaded'],
                    ),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File "${fileNameController.text.trim()}" securely uploaded and encrypted.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            icon: const Icon(Icons.cloud_upload_rounded, size: 16),
            label: const Text('Upload File'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final folders = _filteredFolders;
    final files = _filteredFiles;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Secure Cloud Drive (DAM)',
              subtitle: 'Centralized project vault, immutable drawing repository & Super Admin 2FA deletion locks',
              primaryActionLabel: 'Upload File',
              primaryActionIcon: Icons.cloud_upload_outlined,
              onPrimaryAction: _handleUploadFile,
              searchHint: 'Search files in cloud drive...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: _handleCreateFolder,
                  icon: const Icon(Icons.create_new_folder_outlined, size: 18),
                  label: const Text('New Folder'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleShare('$_selectedProject Master Vault', isFolder: true),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share Vault'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Storage Quota & Metric Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_done_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Cloud Drive Vault Storage Quota',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '12.4 GB of 100 GB Used (12.4%)',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.124,
                      minHeight: 8,
                      backgroundColor: Colors.grey,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      _buildQuotaCategory('2D CAD Blueprints', '2.8 GB', AppColors.primary),
                      _buildQuotaCategory('3D Renders & 4K', '5.6 GB', const Color(0xFF8B5CF6)),
                      _buildQuotaCategory('Site Surveillance 4K', '3.2 GB', AppColors.success),
                      _buildQuotaCategory('BOQs & Documents', '0.8 GB', AppColors.warning),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Controls Bar with Project Selector & Breadcrumbs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  // Select Project
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedProject,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'PRJ-104', child: Text('PRJ-104 (DLF Camellias)')),
                          DropdownMenuItem(value: 'PRJ-105', child: Text('PRJ-105 (Godrej Woods)')),
                          DropdownMenuItem(value: 'PRJ-106', child: Text('PRJ-106 (Prestige Golfshire)')),
                          DropdownMenuItem(value: 'PRJ-107', child: Text('PRJ-107 (Oberoi Sky City)')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _selectedProject = v;
                              _activeFolder = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Breadcrumb Path
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _activeFolder = null),
                            child: Text(
                              'Vault Root',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _activeFolder == null ? AppColors.primary : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (_activeFolder != null) ...[
                            const Text('  /  ', style: TextStyle(color: Colors.grey)),
                            Text(
                              _activeFolder!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // View Toggle
                  IconButton(
                    icon: Icon(Icons.grid_view_rounded, color: _isGridView ? AppColors.primary : Colors.grey, size: 20),
                    tooltip: 'Grid View',
                    onPressed: () => setState(() => _isGridView = true),
                  ),
                  IconButton(
                    icon: Icon(Icons.view_list_rounded, color: !_isGridView ? AppColors.primary : Colors.grey, size: 20),
                    tooltip: 'List View',
                    onPressed: () => setState(() => _isGridView = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Folders Section (Only when in Vault Root)
            if (_activeFolder == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROJECT FOLDERS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    ),
                  ),
                  Text(
                    '${folders.length} auto-generated folders',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 2.4,
                ),
                itemCount: folders.length,
                itemBuilder: (context, idx) {
                  final f = folders[idx];
                  return InkWell(
                    onTap: () => setState(() => _activeFolder = f),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(f.folderType.icon, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  f.name,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${f.itemCount} items • ${f.totalSizeFormatted}',
                                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 18),
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'open', child: Text('Open Folder')),
                              const PopupMenuItem(value: 'share', child: Text('Share Folder Link')),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete (Admin 2FA Lock)', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                            onSelected: (val) {
                              if (val == 'open') {
                                setState(() => _activeFolder = f);
                              } else if (val == 'share') {
                                _handleShare(f.name, isFolder: true);
                              } else if (val == 'delete') {
                                _handleDeleteAttempt(f.name, () {
                                  setState(() => _folders.removeWhere((item) => item.id == f.id));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Folder "${f.name}" purged under Super Admin 2FA authorization.')),
                                  );
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
            ],

            // Files Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _activeFolder == null ? 'ALL PROJECT DRAWINGS & ASSETS' : 'FILES IN: ${_activeFolder!.name}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                Text(
                  '${files.length} design files',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (files.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.folder_open_rounded, size: 40, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      'No files in this folder yet',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('Click "Upload File" to add 2D CAD or 3D render deliverables.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              )
            else if (_isGridView)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.88,
                ),
                itemCount: files.length,
                itemBuilder: (context, idx) {
                  final file = files[idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(file.thumbnailUrl, fit: BoxFit.cover),
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: file.fileType.color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    file.fileType.extension.toUpperCase(),
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.lock_rounded, size: 12, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                file.fileName,
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${file.fileSizeFormatted} • ${file.versionTag}',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share_outlined, size: 14),
                                    tooltip: 'Share Link',
                                    onPressed: () => _handleShare(file.fileName),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download_rounded, size: 14),
                                    tooltip: 'Download File',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Downloading "${file.fileName}"...')),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 14, color: AppColors.error),
                                    tooltip: 'Delete File (Admin 2FA Locked)',
                                    onPressed: () {
                                      _handleDeleteAttempt(file.fileName, () {
                                        setState(() => _files.removeWhere((item) => item.id == file.id));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('File "${file.fileName}" purged under Super Admin 2FA authorization.')),
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: files.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final file = files[idx];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: file.fileType.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(file.fileType.icon, color: file.fileType.color, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(file.fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                '${file.fileSizeFormatted} • ${file.versionTag} • Uploaded by ${file.uploadedBy}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 16),
                          tooltip: 'Share',
                          onPressed: () => _handleShare(file.fileName),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded, size: 16),
                          tooltip: 'Download',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Downloading "${file.fileName}"...')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                          tooltip: 'Delete (Locked)',
                          onPressed: () {
                            _handleDeleteAttempt(file.fileName, () {
                              setState(() => _files.removeWhere((item) => item.id == file.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('File "${file.fileName}" purged under Super Admin 2FA authorization.')),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaCategory(String label, String used, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label: ', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
        Text(used, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
