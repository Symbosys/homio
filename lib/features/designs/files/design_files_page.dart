import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/admin_delete_lock_dialog.dart';
import '../widgets/cloud_share_link_modal.dart';
import '../widgets/design_header.dart';
import '../widgets/design_shared_widgets.dart';

/// Screen 2: Files & Folders (`/designs/files`).
/// Structured Cloud-Drive folder template (01 to 13), file browser, drag-and-drop upload simulator,
/// visibility tags, metadata inspector, and Super Admin deletion lock.
class DesignFilesPage extends StatefulWidget {
  const DesignFilesPage({super.key});

  @override
  State<DesignFilesPage> createState() => _DesignFilesPageState();
}

class _DesignFilesPageState extends State<DesignFilesPage> {
  final DesignsRepository _repo = DesignsRepository();

  String _selectedProjectCode = 'PRJ-104';
  CloudDriveFolder? _currentFolder;
  String _searchQuery = '';
  bool _isGridView = true;

  List<CloudDriveFolder> get _folders => _repo.getFoldersForProject(_selectedProjectCode);

  List<CloudDriveFile> get _filesInCurrentFolder {
    if (_currentFolder == null) return [];
    return _repo.getFilesForFolder(_selectedProjectCode, _currentFolder!.id).where((f) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return f.fileName.toLowerCase().contains(q) ||
          f.uploadedByName.toLowerCase().contains(q) ||
          f.fileType.extension.toLowerCase().contains(q);
    }).toList();
  }

  void _handleSelectFolder(CloudDriveFolder folder) {
    setState(() {
      _currentFolder = folder;
      _searchQuery = '';
    });
  }

  void _handleNavigateHome() {
    setState(() {
      _currentFolder = null;
      _searchQuery = '';
    });
  }

  void _handleCreateFolder() {
    final folderNameCtrl = TextEditingController();
    CloudFolderType selectedType = CloudFolderType.clientSubmissions;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              title: Text('Create Structured Project Folder', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Folder Name *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: folderNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. 14_Landscape_and_Exterior',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Text('Folder Category Classification', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<CloudFolderType>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: CloudFolderType.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDlgState(() => selectedType = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = folderNameCtrl.text.trim();
                    if (name.isNotEmpty) {
                      final newFolder = CloudDriveFolder(
                        id: 'fld-${DateTime.now().millisecondsSinceEpoch}',
                        projectCode: _selectedProjectCode,
                        folderName: name,
                        folderType: selectedType,
                        fileCount: 0,
                        totalSizeBytes: 0,
                        lastModified: DateTime.now(),
                      );
                      setState(() {
                        _repo.createFolder(newFolder);
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Folder "$name" created in $_selectedProjectCode'), backgroundColor: AppColors.success),
                      );
                    }
                  },
                  child: const Text('Create Folder'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleSimulateUpload() {
    if (_currentFolder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please open a destination folder first to upload files.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    final newFile = CloudDriveFile(
      id: 'file-${DateTime.now().millisecondsSinceEpoch}',
      folderId: _currentFolder!.id,
      projectCode: _selectedProjectCode,
      fileName: 'Upload_${DateTime.now().minute}${DateTime.now().second}_Drawing.dwg',
      fileType: DesignFileType.dwg,
      fileSizeBytes: 14200000,
      currentVersionTag: 'v1.0',
      uploadedByName: 'Senior Designer (Current User)',
      uploadedAt: DateTime.now(),
      visibility: FileVisibility.internalOnly,
      tags: ['New Upload', 'Auto-Indexed', _currentFolder!.folderName],
    );

    setState(() {
      _repo.uploadDriveFile(newFile);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File "${newFile.fileName}" uploaded to "${_currentFolder!.folderName}" with sha256 checksum recorded.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleDeleteFile(CloudDriveFile file) {
    AdminDeleteLockDialog.show(
      context: context,
      resourceType: 'File',
      resourceName: file.fileName,
      onConfirmSuperAdmin2FA: (superAdmin, otp, reason) {
        final success = _repo.deleteFileWithSuperAdmin2FA(file.id, superAdmin, otp, reason);
        if (success) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "${file.fileName}" DELETED under 2FA Audit Trail by $superAdmin.'),
              backgroundColor: AppColors.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Super Admin OTP! Action blocked by Security Audit Engine.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projects = _repo.projects;
    final folders = _folders;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Structured Files & Folder DAM',
              subtitle: '13-stage standard folder hierarchy, CAD/BIM blueprints, render previews & 2FA deletion lock',
              primaryActionLabel: _currentFolder != null ? 'Upload File Here' : 'New Project Folder',
              primaryActionIcon: _currentFolder != null ? Icons.upload_file_rounded : Icons.create_new_folder_outlined,
              onPrimaryAction: _currentFolder != null ? _handleSimulateUpload : _handleCreateFolder,
              searchHint: _currentFolder != null
                  ? 'Search files in ${_currentFolder!.folderName}...'
                  : 'Search structured folders...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                // Project Switcher
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.apartment, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedProjectCode,
                          items: projects.map((p) {
                            return DropdownMenuItem(
                              value: p.code,
                              child: Text('${p.code} (${p.name.split(' ').first})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedProjectCode = val;
                                _currentFolder = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Breadcrumb Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: _handleNavigateHome,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_queue_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          '$_selectedProjectCode Cloud Drive',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: _currentFolder == null ? FontWeight.w700 : FontWeight.w500,
                            color: _currentFolder == null ? AppColors.primary : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_currentFolder != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
                    ),
                    Icon(_currentFolder!.folderType.icon, size: 16, color: _currentFolder!.folderType.color),
                    const SizedBox(width: 6),
                    Text(
                      _currentFolder!.folderName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // View mode toggle
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.black12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.grid_view_rounded, size: 16, color: _isGridView ? AppColors.primary : Colors.grey),
                          onPressed: () => setState(() => _isGridView = true),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                          tooltip: 'Grid',
                        ),
                        IconButton(
                          icon: Icon(Icons.table_rows_rounded, size: 16, color: !_isGridView ? AppColors.primary : Colors.grey),
                          onPressed: () => setState(() => _isGridView = false),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                          tooltip: 'Table',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content Area: Folders Root OR Inside a Selected Folder
            if (_currentFolder == null)
              _buildFoldersGrid(folders, isDark)
            else
              _buildFilesInFolderView(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFoldersGrid(List<CloudDriveFolder> folders, bool isDark) {
    final filteredFolders = folders.where((f) {
      if (_searchQuery.isEmpty) return true;
      return f.folderName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.folderType.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredFolders.isEmpty) {
      return const DesignEmptyState(
        icon: Icons.folder_open_rounded,
        title: 'No Folders Found',
        message: 'Create a new template folder to start organizing digital assets.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 280).floor().clamp(1, 4);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 130,
          ),
          itemCount: filteredFolders.length,
          itemBuilder: (context, index) {
            final f = filteredFolders[index];

            return InkWell(
              onTap: () => _handleSelectFolder(f),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: f.folderType.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(f.folderType.icon, size: 20, color: f.folderType.color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            f.folderName,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${f.fileCount} files • ${f.totalSizeBytesFormatted}',
                          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilesInFolderView(bool isDark) {
    final files = _filesInCurrentFolder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag & Drop Upload Zone Simulator Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drag and Drop CAD Blueprints, 3D Renders, or BOQs Here',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Supported formats: .DWG, .RVT, .3DS, .SKP, .PDF, .XLSX, .PNG (Automatic version-control indexing)',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _handleSimulateUpload,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Browse Files'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (files.isEmpty)
          const DesignEmptyState(
            icon: Icons.insert_drive_file_outlined,
            title: 'No Files in this Folder',
            message: 'Upload or drop CAD drawings and digital assets into this folder.',
          )
        else if (_isGridView)
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 300).floor().clamp(1, 4);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 220,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return _buildFileCard(file, isDark);
                },
              );
            },
          )
        else
          _buildFilesTable(files, isDark),
      ],
    );
  }

  Widget _buildFileCard(CloudDriveFile file, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: file.fileType.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(file.fileType.icon, size: 22, color: file.fileType.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${file.currentVersionTag} • ${file.fileSizeBytesFormatted}',
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: file.tags.take(3).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(tag, style: GoogleFonts.inter(fontSize: 10)),
              );
            }).toList(),
          ),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By ${file.uploadedByName.split(' ').first}',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 16),
                    tooltip: 'Share Link',
                    onPressed: () {
                      CloudShareLinkModal.show(
                        context: context,
                        itemName: file.fileName,
                        itemType: 'File',
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                    tooltip: 'Super Admin 2FA Delete',
                    onPressed: () => _handleDeleteFile(file),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilesTable(List<CloudDriveFile> files, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 52,
          columns: const [
            DataColumn(label: Text('File Name')),
            DataColumn(label: Text('Version')),
            DataColumn(label: Text('Format')),
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Uploaded By')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Actions')),
          ],
          rows: files.map((f) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(f.fileType.icon, size: 16, color: f.fileType.color),
                      const SizedBox(width: 8),
                      Text(f.fileName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(f.currentVersionTag, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ),
                DataCell(Text('.${f.fileType.extension}', style: GoogleFonts.inter(fontSize: 12))),
                DataCell(Text(f.fileSizeBytesFormatted, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(Text(f.uploadedByName, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(Text('${f.uploadedAt.day}/${f.uploadedAt.month}/${f.uploadedAt.year}', style: GoogleFonts.inter(fontSize: 12))),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 16),
                        tooltip: 'Share Link',
                        onPressed: () {
                          CloudShareLinkModal.show(
                            context: context,
                            itemName: f.fileName,
                            itemType: 'File',
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                        tooltip: 'Super Admin 2FA Delete',
                        onPressed: () => _handleDeleteFile(f),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
