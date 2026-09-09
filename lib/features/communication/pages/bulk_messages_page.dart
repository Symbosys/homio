// Homio CRM — Enterprise Bulk Messaging & Import Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/comm_data_table.dart';

class BulkMessagesPage extends StatefulWidget {
  const BulkMessagesPage({super.key});

  @override
  State<BulkMessagesPage> createState() => _BulkMessagesPageState();
}

class _BulkMessagesPageState extends State<BulkMessagesPage> {
  late List<BulkMessageJob> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = List.from(CommunicationMockData.bulkJobs);
  }

  void _showImportWizard() {
    int step = 1;
    String fileName = 'bangalore_sobha_homeowners_sep26.xlsx';
    int totalRows = 280;
    int validRows = 274;
    int invalidRows = 4;
    int duplicateRows = 2;
    String selectedTemplate = CommunicationMockData.templates.first.name;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setWizardState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.upload_file, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Bulk Contact Import Wizard — Step $step of 3', style: const TextStyle(fontSize: 15)),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (step == 1) ...[
                        const Text('Upload Contact Spreadsheet (CSV or Excel)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        const Text(
                          'Upload homeowner contact list with Name, Phone, City & Property type columns for bulk WhatsApp/SMS outreach.',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
                                const SizedBox(height: 8),
                                Text(
                                  fileName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                const Text('File verified • 280 contacts detected (142 KB)', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ] else if (step == 2) ...[
                        const Text('Validation & Data Quality Audit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildValidationCard('Total Rows', '$totalRows', const Color(0xFF3B82F6), isDark),
                            const SizedBox(width: 10),
                            _buildValidationCard('Valid Numbers', '$validRows', const Color(0xFF10B981), isDark),
                            const SizedBox(width: 10),
                            _buildValidationCard('Invalid Numbers', '$invalidRows', const Color(0xFFEF4444), isDark),
                            const SizedBox(width: 10),
                            _buildValidationCard('Duplicates', '$duplicateRows', const Color(0xFFF59E0B), isDark),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Select WhatsApp Approved Template', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: selectedTemplate,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: CommunicationMockData.templates.map((t) {
                            return DropdownMenuItem(value: t.name, child: Text(t.name));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setWizardState(() => selectedTemplate = val);
                          },
                        ),
                      ] else ...[
                        const Text('Confirmation & Dispatch Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ready to Queue for Broadcast Delivery',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$validRows validated numbers will receive the "$selectedTemplate" template. Estimated delivery time is 6 minutes.',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                if (step > 1)
                  TextButton(
                    onPressed: () => setWizardState(() => step--),
                    child: const Text('Back'),
                  ),
                if (step < 3)
                  ElevatedButton(
                    onPressed: () => setWizardState(() => step++),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Continue'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      final newJob = BulkMessageJob(
                        id: 'bulk_${DateTime.now().millisecondsSinceEpoch}',
                        title: 'Sobha Homeowners Sept Outreach',
                        fileName: fileName,
                        totalRows: totalRows,
                        validRows: validRows,
                        invalidRows: invalidRows,
                        duplicateRows: duplicateRows,
                        templateId: 'tpl_welcome_01',
                        status: 'Processing',
                        createdAt: DateTime.now(),
                        processedCount: 0,
                        successCount: 0,
                        failureCount: 0,
                      );
                      setState(() {
                        _jobs.insert(0, newJob);
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bulk messaging job queued and processing.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Dispatch Bulk Job'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildValidationCard(String title, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // Header
          CommPageHeader(
            title: 'Bulk Messaging & Spreadsheet Uploads',
            subtitle: 'Import CSV/Excel files to send automated verified WhatsApp & SMS batches with data cleansing',
            icon: Icons.mark_email_read_rounded,
            primaryActionLabel: 'Import Spreadsheet',
            primaryActionIcon: Icons.upload_file,
            onPrimaryAction: _showImportWizard,
            customActions: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading standard Homio Contact Import Template (.csv)...')),
                  );
                },
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Download Sample CSV', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // KPI Cards
                Row(
                  children: [
                    Expanded(
                      child: CommKpiCard(
                        title: 'Total Bulk Jobs',
                        value: '${_jobs.length}',
                        subtitle: 'All file imports',
                        icon: Icons.receipt_long,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Contacts Processed',
                        value: '1,345',
                        subtitle: 'Across all files',
                        icon: Icons.people_outline,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Data Hygiene Rate',
                        value: '97.2%',
                        subtitle: 'Valid phone numbers',
                        icon: Icons.cleaning_services_outlined,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Active Processing',
                        value: '${_jobs.where((j) => j.status == "Processing").length}',
                        subtitle: 'Currently throttling',
                        icon: Icons.sync,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Table
                _buildJobsTable(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsTable(bool isDark) {
    final columns = [
      const CommDataColumn(label: 'Job Title & File', width: 260),
      const CommDataColumn(label: 'Channel', width: 110),
      const CommDataColumn(label: 'Total Rows', width: 100),
      const CommDataColumn(label: 'Valid / Invalid', width: 130),
      const CommDataColumn(label: 'Status', width: 120),
      const CommDataColumn(label: 'Dispatched', width: 110),
      const CommDataColumn(label: 'Created Date', width: 140),
    ];

    final rows = _jobs.map((job) {
      return CommDataRow(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing bulk job report for: ${job.title}')),
          );
        },
        cells: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(
                job.fileName,
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
          CommStatusBadge.fromChannel(job.channel),
          Text('${job.totalRows} contacts', style: const TextStyle(fontSize: 12)),
          Row(
            children: [
              Text('${job.validRows}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              const Text(' / ', style: TextStyle(fontSize: 12)),
              Text('${job.invalidRows}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: job.status == 'Completed'
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              job.status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: job.status == 'Completed' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              ),
            ),
          ),
          Text('${job.successCount} sent', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(
            job.createdAt.toString().substring(0, 16),
            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ],
      );
    }).toList();

    return CommDataTable(
      columns: columns,
      rows: rows,
      totalItems: rows.length,
      totalPages: 1,
      currentPage: 1,
    );
  }
}
