import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/designs_repository.dart';
import '../domain/design_enums.dart';
import '../domain/design_models.dart';
import '../widgets/admin_delete_lock_dialog.dart';
import '../widgets/cloud_share_link_modal.dart';
import '../widgets/design_header.dart';
import '../widgets/design_metric_card.dart';
import '../widgets/design_shared_widgets.dart';

/// Screen 6: Cloud Drive & Central DAM (`/designs/drive` / `/designs/cloud-drive`).
/// Centralized enterprise asset repository with 13-stage folder structure,
/// encrypted storage governance, and mandatory Super Admin 2FA deletion authorization.
class DesignCloudDrivePage extends StatefulWidget {
  const DesignCloudDrivePage({super.key});

  @override
  State<DesignCloudDrivePage> createState() => _DesignCloudDrivePageState();
}

class _DesignCloudDrivePageState extends State<DesignCloudDrivePage> {
  final DesignsRepository _repo = DesignsRepository();

  String _selectedProjectCode = 'PRJ-104';
  CloudDriveFolder? _activeFolder;
  String _searchQuery = '';
  bool _isGridView = true;
  bool _showAuditLogs = false;

  List<CloudDriveFolder> get _folders => _repo.getFoldersForProject(_selectedProjectCode);

  List<CloudDriveFile> get _files {
    if (_activeFolder == null) return [];
    return _repo.getFilesForFolder(_selectedProjectCode, _activeFolder!.id).where((file) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = file.fileName.toLowerCase().contains(q) ||
            file.uploadedByName.toLowerCase().contains(q) ||
            file.fileType.extension.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
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
              content: Text('Invalid Super Admin OTP code! Action blocked.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  void _handleDeleteFolder(CloudDriveFolder folder) {
    AdminDeleteLockDialog.show(
      context: context,
      resourceType: 'Folder',
      resourceName: folder.folderName,
      onConfirmSuperAdmin2FA: (superAdmin, otp, reason) {
        final success = _repo.deleteFolderWithSuperAdmin2FA(folder.id, superAdmin, otp, reason);
        if (success) {
          setState(() {
            if (_activeFolder?.id == folder.id) {
              _activeFolder = null;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "${folder.folderName}" DELETED under 2FA Audit Trail by $superAdmin.'),
              backgroundColor: AppColors.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Super Admin OTP code! Action blocked.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  void _handleCreateFolder() {
    final folderNameCtrl = TextEditingController();
    CloudFolderType selectedType = CloudFolderType.cadDrawings;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              title: Text('Create Structured Cloud Folder', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Folder Name *', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: folderNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. 14_Façade_Engineering',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Text('Folder Type Classification', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<CloudFolderType>(
                    initialValue: selectedType,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
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
                      final newF = CloudDriveFolder(
                        id: 'fld-${DateTime.now().millisecondsSinceEpoch}',
                        projectCode: _selectedProjectCode,
                        folderName: name,
                        folderType: selectedType,
                        fileCount: 0,
                        totalSizeBytes: 0,
                        lastModified: DateTime.now(),
                      );
                      setState(() {
                        _repo.createFolder(newF);
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

  void _handleUploadSimulation() {
    if (_activeFolder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please open a folder first to upload files.'), backgroundColor: AppColors.warning),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Simulated file uploaded to ${_activeFolder!.folderName}. Checksum logged.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projects = _repo.projects;
    final folders = _folders;
    final files = _files;
    final auditLogs = _repo.deletionAuditLogs;

    // Computed drive metrics
    int totalBytes = 0;
    for (final f in _repo.driveFiles) {
      totalBytes += f.fileSizeBytes;
    }
    final totalMB = (totalBytes / (1024 * 1024)).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            DesignHeader(
              title: 'Central Cloud Drive & Digital Asset Management',
              subtitle: 'Enterprise CAD/BIM repository, folder access governance & 2FA Super Admin deletion audit trail',
              primaryActionLabel: _activeFolder != null ? 'Upload File' : 'New Folder',
              primaryActionIcon: _activeFolder != null ? Icons.cloud_upload_outlined : Icons.create_new_folder_outlined,
              onPrimaryAction: _activeFolder != null ? _handleUploadSimulation : _handleCreateFolder,
              searchHint: _activeFolder != null ? 'Search files in ${_activeFolder!.folderName}...' : 'Search cloud drive folders...',
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              actions: [
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showAuditLogs = !_showAuditLogs),
                  icon: Icon(_showAuditLogs ? Icons.folder_rounded : Icons.security_rounded, size: 16),
                  label: Text(_showAuditLogs ? 'Back to Drive' : '2FA Deletion Audit Log (${auditLogs.length})'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
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
                                _activeFolder = null;
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

            // Governance Security Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Strict DAM Deletion Policy Active: Dual-Custody 2FA Authorization Required',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Text(
                          'Project folders and CAD assets cannot be deleted by general staff. Deletions require Super Admin identity verification and cryptographic OTP entry.',
                          style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Top KPI Row
            Row(
              children: [
                Expanded(
                  child: DesignMetricCard(
                    title: 'Total Cloud Files',
                    value: '${_repo.driveFiles.length}',
                    subtitle: 'Indexed in repository',
                    icon: Icons.folder_shared_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Storage Consumed',
                    value: '$totalMB MB',
                    subtitle: 'AWS S3 encrypted vault',
                    icon: Icons.cloud_done_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: 'Project Folders',
                    value: '${folders.length}',
                    subtitle: 'In $_selectedProjectCode tree',
                    icon: Icons.create_new_folder_rounded,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: DesignMetricCard(
                    title: '2FA Audit Logs',
                    value: '${auditLogs.length}',
                    subtitle: 'Immutable security events',
                    icon: Icons.lock_outline_rounded,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Show Audit Logs OR Drive Explorer
            if (_showAuditLogs)
              _buildAuditLogsView(auditLogs, isDark)
            else ...[
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
                      onTap: () => setState(() => _activeFolder = null),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_queue_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '$_selectedProjectCode Root',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: _activeFolder == null ? FontWeight.w700 : FontWeight.w500,
                              color: _activeFolder == null ? AppColors.primary : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_activeFolder != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
                      ),
                      Icon(_activeFolder!.folderType.icon, size: 16, color: _activeFolder!.folderType.color),
                      const SizedBox(width: 6),
                      Text(
                        _activeFolder!.folderName,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                    const Spacer(),
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
                          ),
                          IconButton(
                            icon: Icon(Icons.table_rows_rounded, size: 16, color: !_isGridView ? AppColors.primary : Colors.grey),
                            onPressed: () => setState(() => _isGridView = false),
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Folders List or Files in active folder
              if (_activeFolder == null)
                _buildFolderHierarchy(folders, isDark)
              else
                _buildFilesView(files, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFolderHierarchy(List<CloudDriveFolder> folders, bool isDark) {
    if (folders.isEmpty) {
      return const DesignEmptyState(
        icon: Icons.folder_open_rounded,
        title: 'No Folders in this Project',
        message: 'Create a new folder to begin organizing project blueprints and assets.',
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
            mainAxisExtent: 140,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final f = folders[index];

            return InkWell(
              onTap: () => setState(() => _activeFolder = f),
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
                        Expanded(
                          child: Text(
                            '${f.fileCount} files • ${f.totalSizeBytesFormatted}',
                            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_outlined, size: 16),
                              tooltip: 'Share Folder Link',
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                CloudShareLinkModal.show(
                                  context: context,
                                  itemName: f.folderName,
                                  itemType: 'Folder',
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                              tooltip: 'Super Admin 2FA Delete',
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: () => _handleDeleteFolder(f),
                            ),
                          ],
                        ),
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

  Widget _buildFilesView(List<CloudDriveFile> files, bool isDark) {
    if (files.isEmpty) {
      return const DesignEmptyState(
        icon: Icons.insert_drive_file_outlined,
        title: 'Empty Folder',
        message: 'No files uploaded to this folder yet. Click "Upload File" above.',
      );
    }

    if (_isGridView) {
      return LayoutBuilder(
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
                          child: Icon(file.fileType.icon, size: 20, color: file.fileType.color),
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
                    Wrap(
                      spacing: 6,
                      children: file.tags.take(3).map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(t, style: GoogleFonts.inter(fontSize: 10)),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('By ${file.uploadedByName.split(' ').first}', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_outlined, size: 16),
                              tooltip: 'Share File',
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
            },
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
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
                DataCell(Text(f.fileName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text(f.currentVersionTag, style: GoogleFonts.inter(fontSize: 12))),
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
                        onPressed: () => CloudShareLinkModal.show(context: context, itemName: f.fileName, itemType: 'File'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
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

  Widget _buildAuditLogsView(List<DeletionAuditLog> logs, bool isDark) {
    if (logs.isEmpty) {
      return const DesignEmptyState(
        icon: Icons.security_rounded,
        title: 'Zero Deletion Events Logged',
        message: 'No digital assets have been authorized for deletion under the Super Admin 2FA policy.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Resource Name')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Super Admin Approver')),
            DataColumn(label: Text('2FA OTP')),
            DataColumn(label: Text('Reason for Deletion')),
            DataColumn(label: Text('Timestamp')),
            DataColumn(label: Text('Status')),
          ],
          rows: logs.map((log) {
            return DataRow(
              cells: [
                DataCell(Text(log.itemName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                DataCell(Text(log.itemType, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(Text(log.superAdminApprover, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('VERIFIED', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                  ),
                ),
                DataCell(Text(log.reason, style: GoogleFonts.inter(fontSize: 12))),
                DataCell(Text('${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year} ${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}', style: GoogleFonts.inter(fontSize: 12))),
                DataCell(
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
