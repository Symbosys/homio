import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/blueprint_models.dart';

class BlueprintsDamFilesPage extends StatefulWidget {
  const BlueprintsDamFilesPage({super.key});

  @override
  State<BlueprintsDamFilesPage> createState() => _BlueprintsDamFilesPageState();
}

class _BlueprintsDamFilesPageState extends State<BlueprintsDamFilesPage> {
  BlueprintCategory _selectedCategory = BlueprintCategory.all;
  String _searchQuery = '';
  DocApprovalStatus? _statusFilter;

  List<BlueprintDocument> get _filteredDocs {
    return BlueprintMockData.documents.where((doc) {
      final matchesSearch = doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.clientName.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedCategory != BlueprintCategory.all && doc.category != _selectedCategory) {
        return false;
      }

      if (_statusFilter != null && doc.approvalStatus != _statusFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          _buildFilterBar(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          Expanded(
            child: _filteredDocs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded, size: 48, color: textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No blueprints or DAM files matched', style: TextStyle(color: textSecondary)),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 3;
                      if (constraints.maxWidth < 750) {
                        crossAxisCount = 1;
                      } else if (constraints.maxWidth < 1150) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 310,
                        ),
                        itemCount: _filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = _filteredDocs[index];
                          return _buildDocCard(doc, isDark, surfaceColor, borderColor, textPrimary, textSecondary);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.folder_shared_rounded, color: Color(0xFFF59E0B), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Blueprints & DAM Files Hub',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${BlueprintMockData.documents.length} deliverables',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Quick-dispatch CAD drawings, 3D elevation renders, contracts & invoices straight to client WhatsApp',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showUploadModal(context, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
            icon: const Icon(Icons.cloud_upload_rounded, size: 18),
            label: const Text('Upload Deliverable'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(
                width: 240,
                height: 36,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search title, client, project...',
                    hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All Files', BlueprintCategory.all, isDark, textSecondary),
                      _buildCategoryChip('2D CAD', BlueprintCategory.cad2d, isDark, textSecondary),
                      _buildCategoryChip('3D Renders', BlueprintCategory.render3d, isDark, textSecondary),
                      _buildCategoryChip('Contracts', BlueprintCategory.contract, isDark, textSecondary),
                      _buildCategoryChip('Invoices', BlueprintCategory.invoice, isDark, textSecondary),
                      _buildCategoryChip('Spec Sheets', BlueprintCategory.specSheet, isDark, textSecondary),
                      _buildCategoryChip('Site Reports', BlueprintCategory.siteReport, isDark, textSecondary),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, BlueprintCategory category, bool isDark, Color textSecondary) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = category),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Colors.white : textSecondary,
        ),
        selectedColor: const Color(0xFFF59E0B),
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDocCard(
    BlueprintDocument doc,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Preview / File Type Banner
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: doc.previewThumbnailUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          doc.previewThumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: _buildApprovalBadge(doc.approvalStatus),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 10,
                          child: Row(
                            children: [
                              _buildFormatBadge(doc.fileFormat),
                              const SizedBox(width: 6),
                              Text(doc.version, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Icon(_getCategoryIcon(doc.category), size: 44, color: _getCategoryColor(doc.category).withValues(alpha: 0.6)),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildApprovalBadge(doc.approvalStatus),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        child: Row(
                          children: [
                            _buildFormatBadge(doc.fileFormat),
                            const SizedBox(width: 6),
                            Text(doc.version, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${doc.projectTitle} • ${doc.clientName}',
                  style: TextStyle(fontSize: 11, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(doc.fileSizeFormatted, style: TextStyle(fontSize: 11, color: textSecondary)),
                    Text('Shared ${doc.whatsappShareCount}x via WA', style: const TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),
          Divider(height: 1, color: borderColor),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showWhatsAppSendDialog(doc),
                    icon: const Icon(Icons.send_rounded, size: 14, color: Color(0xFF10B981)),
                    label: const Text(
                      'Send WA',
                      style: TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF10B981)),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<DocApprovalStatus>(
                  tooltip: 'Update Approval',
                  onSelected: (status) {
                    setState(() {
                      doc.approvalStatus = status;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Approval status updated to ${_getApprovalLabel(status)}'),
                        backgroundColor: const Color(0xFF3B82F6),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.more_vert_rounded, size: 16),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: DocApprovalStatus.approved,
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                          SizedBox(width: 8),
                          Text('Mark Approved'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: DocApprovalStatus.pendingReview,
                      child: Row(
                        children: [
                          Icon(Icons.hourglass_top_rounded, color: Color(0xFFF59E0B), size: 16),
                          SizedBox(width: 8),
                          Text('Mark Pending Review'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: DocApprovalStatus.revisionRequested,
                      child: Row(
                        children: [
                          Icon(Icons.edit_note_rounded, color: Color(0xFFEF4444), size: 16),
                          SizedBox(width: 8),
                          Text('Request Revisions'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalBadge(DocApprovalStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case DocApprovalStatus.approved:
        bg = const Color(0xFF10B981);
        fg = Colors.white;
        label = 'Approved';
        break;
      case DocApprovalStatus.pendingReview:
        bg = const Color(0xFFF59E0B);
        fg = Colors.white;
        label = 'Pending Signoff';
        break;
      case DocApprovalStatus.revisionRequested:
        bg = const Color(0xFFEF4444);
        fg = Colors.white;
        label = 'Revision Req.';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  Widget _buildFormatBadge(String format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  void _showWhatsAppSendDialog(BlueprintDocument doc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.send_rounded, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Send Deliverable on WhatsApp', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Deliver to: ${doc.clientName} (${doc.clientPhone})', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Project: ${doc.projectTitle}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📄 ${doc.title}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Format: ${doc.fileFormat} • Version: ${doc.version} • Size: ${doc.fileSizeFormatted}', style: const TextStyle(fontSize: 11)),
                    const SizedBox(height: 8),
                    const Text(
                      'Message text:\n"Hello! Please find attached the updated architectural deliverable for your review and signoff. You can approve directly via WhatsApp response."',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  doc.whatsappShareCount += 1;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Delivered ${doc.title} to ${doc.clientName} via WhatsApp!'),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Send WhatsApp Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUploadModal(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final titleCtrl = TextEditingController();
    BlueprintCategory cat = BlueprintCategory.cad2d;
    String version = 'v1.0';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upload Blueprint / DAM File',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Document / Drawing Title',
                      hintText: 'e.g. Master Bedroom Wardrobe Detail Drawing',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<BlueprintCategory>(
                    initialValue: cat,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: const [
                      DropdownMenuItem(value: BlueprintCategory.cad2d, child: Text('2D CAD Layout')),
                      DropdownMenuItem(value: BlueprintCategory.render3d, child: Text('3D Photorealistic Render')),
                      DropdownMenuItem(value: BlueprintCategory.contract, child: Text('Contract / Agreement')),
                      DropdownMenuItem(value: BlueprintCategory.invoice, child: Text('Invoice / Billing')),
                      DropdownMenuItem(value: BlueprintCategory.specSheet, child: Text('Material Spec Sheet')),
                      DropdownMenuItem(value: BlueprintCategory.siteReport, child: Text('Site Audit Report')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => cat = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (val) => version = val,
                    decoration: InputDecoration(
                      labelText: 'Version Tag',
                      hintText: 'e.g. v1.0, Rev-2.1',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropzone area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_upload_outlined, size: 36, color: Color(0xFFF59E0B)),
                        const SizedBox(height: 6),
                        Text('Select PDF, DWG, FBX, or JPG Render', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                        const SizedBox(height: 2),
                        Text('Supports up to 50MB files', style: TextStyle(fontSize: 11, color: textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        setState(() {
                          BlueprintMockData.documents.insert(
                            0,
                            BlueprintDocument(
                              id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
                              title: titleCtrl.text.trim(),
                              projectTitle: 'Villa #42 - Palm Meadows',
                              clientName: 'Vikram Malhotra',
                              clientPhone: '+91 98201 44521',
                              category: cat,
                              fileFormat: cat == BlueprintCategory.cad2d ? 'DWG' : (cat == BlueprintCategory.render3d ? 'JPG' : 'PDF'),
                              fileSizeBytes: 8 * 1024 * 1024,
                              version: version.isEmpty ? 'v1.0' : version,
                              approvalStatus: DocApprovalStatus.pendingReview,
                              uploadedBy: 'Team Admin',
                              uploadedAt: DateTime.now(),
                            ),
                          );
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Document uploaded and indexed successfully!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save Deliverable'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(BlueprintCategory cat) {
    switch (cat) {
      case BlueprintCategory.cad2d:
        return Icons.architecture_rounded;
      case BlueprintCategory.render3d:
        return Icons.view_in_ar_rounded;
      case BlueprintCategory.contract:
        return Icons.gavel_rounded;
      case BlueprintCategory.invoice:
        return Icons.receipt_long_rounded;
      case BlueprintCategory.siteReport:
        return Icons.assessment_rounded;
      case BlueprintCategory.specSheet:
        return Icons.description_rounded;
      case BlueprintCategory.all:
        return Icons.folder_rounded;
    }
  }

  Color _getCategoryColor(BlueprintCategory cat) {
    switch (cat) {
      case BlueprintCategory.cad2d:
        return const Color(0xFF3B82F6);
      case BlueprintCategory.render3d:
        return const Color(0xFF8B5CF6);
      case BlueprintCategory.contract:
        return const Color(0xFF10B981);
      case BlueprintCategory.invoice:
        return const Color(0xFFF59E0B);
      case BlueprintCategory.siteReport:
        return const Color(0xFFEC4899);
      case BlueprintCategory.specSheet:
        return const Color(0xFF06B6D4);
      case BlueprintCategory.all:
        return Colors.grey;
    }
  }

  String _getApprovalLabel(DocApprovalStatus status) {
    switch (status) {
      case DocApprovalStatus.approved:
        return 'Approved';
      case DocApprovalStatus.pendingReview:
        return 'Pending Review';
      case DocApprovalStatus.revisionRequested:
        return 'Revision Requested';
    }
  }
}
