import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_phase2_models.dart';
import '../models/admin_phase2_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class BackupRecoveryPage extends StatefulWidget {
  const BackupRecoveryPage({super.key});

  @override
  State<BackupRecoveryPage> createState() => _BackupRecoveryPageState();
}

class _BackupRecoveryPageState extends State<BackupRecoveryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<BackupRecord> _backups = List.from(AdminPhase2MockData.backups);
  final List<RestoreTestLog> _restoreTests = List.from(AdminPhase2MockData.restoreTests);
  BackupConfiguration _config = const BackupConfiguration();

  bool _isCreatingBackup = false;
  BackupRecord? _selectedBackupForRestore;
  int _restoreStep = 1; // 1 to 5
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _triggerAdHocBackup() {
    setState(() => _isCreatingBackup = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 12),
            CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            SizedBox(height: 16),
            Text('Creating Ad-Hoc Disaster Snapshot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            Text('Exporting PostgreSQL tables, MongoDB collections, applying AES-256 encryption, and dispatching to S3 vault...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pop();

      final newBck = BackupRecord(
        id: 'bck_${DateTime.now().millisecondsSinceEpoch}',
        backupCode: 'HOMIO-DB-MANUAL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        type: BackupType.manual,
        startedAt: DateTime.now().subtract(const Duration(minutes: 2)),
        completedAt: DateTime.now(),
        durationFormatted: '1m 45s',
        sizeMb: 172.4,
        status: BackupJobStatus.completed,
        storageLocation: 'AWS S3 Vault (ap-south-1 Mumbai)',
        retentionUntil: DateTime.now().add(const Duration(days: 90)),
        sha256Checksum: '9a87f1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0',
        destinationEmail: _config.emailRecipients,
        createdBy: 'Amit Verma (Admin)',
      );

      setState(() {
        _backups.insert(0, newBck);
        _isCreatingBackup = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disaster snapshot ${newBck.backupCode} compiled (172.4 MB) & verified successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header
                AdminHeader(
                  title: 'Disaster Backup & Safe Recovery',
                  description: 'Enterprise data resilience, automated weekly encrypted snapshots, AWS S3 cold vault storage, and guided recovery drills.',
                  icon: Icons.cloud_done_rounded,
                  breadcrumbs: const ['Homio Administration', 'Platform Configuration', 'Backup & Recovery'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verification drill completed. 100% S3 snapshot checksums match production ledger.')),
                        );
                      },
                      icon: const Icon(Icons.fact_check_outlined, size: 16),
                      label: const Text('Verify Checksums', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isCreatingBackup ? null : _triggerAdHocBackup,
                      icon: const Icon(Icons.backup_rounded, size: 16),
                      label: const Text('Take Ad-Hoc Snapshot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                // 2. Metrics Summary
                AdminSummaryCards(
                  metrics: [
                    AdminMetricItem(
                      label: 'Disaster System Health',
                      value: '100% Healthy',
                      subtitle: 'Weekly schedule active',
                      icon: Icons.shield_rounded,
                      color: AppColors.success,
                      trendText: 'Encrypted',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Last Successful Snapshot',
                      value: _backups.first.backupCode.split('-').last,
                      subtitle: '${_backups.first.sizeMb} MB • Completed in ${_backups.first.durationFormatted}',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Next Scheduled Backup',
                      value: 'Sun 02:00 AM',
                      subtitle: '${_config.timezone} • Weekly Cron',
                      icon: Icons.schedule_rounded,
                      color: AppColors.secondary,
                    ),
                    AdminMetricItem(
                      label: 'Retention & Encryption',
                      value: '${_config.retentionDays} Days Retention',
                      subtitle: 'AES-256 GCM Cloud Storage',
                      icon: Icons.lock_outline_rounded,
                      color: AppColors.info,
                    ),
                  ],
                ),

                // 3. Navigation Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border(
                      bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) => setState(() {}),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(icon: Icon(Icons.history_rounded, size: 18), text: 'Snapshot Archives & History'),
                      Tab(icon: Icon(Icons.settings_suggest_rounded, size: 18), text: 'Backup & Email Schedule Config'),
                      Tab(icon: Icon(Icons.verified_user_outlined, size: 18), text: 'Sandbox Recovery Testing Logs'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0)
                  _buildHistoryTab(isDark, isMobile),
                if (_tabController.index == 1)
                  _buildConfigTab(isDark, isMobile),
                if (_tabController.index == 2)
                  _buildRecoveryTestingTab(isDark, isMobile),
              ],
            ),
          ),

          // Guided 5-Step Recovery Workflow Modal
          if (_selectedBackupForRestore != null)
            _buildGuidedRestoreModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: SNAPSHOT ARCHIVES & HISTORY
  // ==========================================================================
  Widget _buildHistoryTab(bool isDark, bool isMobile) {
    return Column(
      children: [
        if (isMobile)
          _buildMobileHistoryCards(_backups, isDark)
        else
          _buildDesktopHistoryTable(_backups, isDark),
      ],
    );
  }

  Widget _buildDesktopHistoryTable(List<BackupRecord> list, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
            ),
            dataRowMinHeight: 50,
            dataRowMaxHeight: 58,
            columns: const [
              DataColumn(label: Text('Snapshot Code & Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Completed (IST)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Size & Duration', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Storage Vault', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Encryption & Integrity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Retention Until', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Triggered By', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Recovery Action', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ],
            rows: list.map((b) {
              return DataRow(
                cells: [
                  // Code & Type
                  DataCell(
                    Row(
                      children: [
                        Icon(b.type.icon, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(b.backupCode, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            Text(b.type.label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Completed
                  DataCell(
                    Text('${b.completedAt.day}/${b.completedAt.month}/${b.completedAt.year} ${b.completedAt.hour.toString().padLeft(2, '0')}:${b.completedAt.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12)),
                  ),
                  // Size & Duration
                  DataCell(
                    Text('${b.sizeMb} MB (${b.durationFormatted})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  // Vault
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 180),
                      child: Text(b.storageLocation, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5)),
                    ),
                  ),
                  // Encryption
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded, size: 13, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(b.encryptionStandard, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  // Retention
                  DataCell(
                    Text('${b.retentionUntil.day}/${b.retentionUntil.month}/${b.retentionUntil.year}', style: const TextStyle(fontSize: 12)),
                  ),
                  // Triggered By
                  DataCell(
                    Text(b.createdBy, style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ),
                  // Recovery Action
                  DataCell(
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedBackupForRestore = b;
                          _restoreStep = 1;
                        });
                      },
                      icon: const Icon(Icons.restore_page_rounded, size: 15),
                      label: const Text('Restore...', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHistoryCards(List<BackupRecord> list, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final b = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b.backupCode, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    AdminStatusBadge(label: b.status.label, color: b.status.color),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${b.type.label} • ${b.sizeMb} MB • Duration: ${b.durationFormatted}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const SizedBox(height: 4),
                Text('Storage: ${b.storageLocation}', style: const TextStyle(fontSize: 11.5)),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Retained until: ${b.retentionUntil.day}/${b.retentionUntil.month}/${b.retentionUntil.year}', style: const TextStyle(fontSize: 11)),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedBackupForRestore = b;
                          _restoreStep = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Restore Backup', style: TextStyle(fontSize: 11.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TAB 2: BACKUP & EMAIL SCHEDULE CONFIGURATION
  // ==========================================================================
  Widget _buildConfigTab(bool isDark, bool isMobile) {
    final emailCtrl = TextEditingController(text: _config.emailRecipients);
    final bucketCtrl = TextEditingController(text: _config.storageBucket);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Automated Disaster Recovery Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          Text('Configure weekly archive dispatch, cold storage retention, and email notifications.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Automated Weekly Disaster Snapshot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Switch(
                        value: _config.automatedEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) => setState(() => _config = _config.copyWith(automatedEnabled: val)),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text('Frequency: ${_config.frequency} (Every ${_config.scheduledDay} at ${_config.scheduledTime})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Archive Email Dispatch Recipients *',
                      helperText: 'Designated Super Admins receiving weekly encrypted snapshot token and manifest.',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: bucketCtrl,
                    decoration: InputDecoration(
                      labelText: 'Primary Cloud Storage S3 Destination URI',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.security_rounded, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      const Text('AES-256 GCM Zero-Knowledge Encryption Enforced', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _config = _config.copyWith(
                          emailRecipients: emailCtrl.text,
                          storageBucket: bucketCtrl.text,
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Disaster recovery configuration updated and verified.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Save Configuration'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 3: RECOVERY TESTING LOGS
  // ==========================================================================
  Widget _buildRecoveryTestingTab(bool isDark, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sandbox Disaster Recovery Verification Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  Text('ISO-27001 proof that backups are fully restorable into an isolated staging sandbox.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sandbox restore simulation running in isolated Docker environment...')),
                  );
                },
                icon: const Icon(Icons.science_outlined, size: 16),
                label: const Text('Trigger Sandbox Drill', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _restoreTests.length,
            itemBuilder: (context, index) {
              final t = _restoreTests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tested: ${t.backupTestedCode}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, fontFamily: 'monospace')),
                          AdminStatusBadge(label: t.isSuccessful ? 'Restorable (100% Schema Match)' : 'Failed', color: t.isSuccessful ? AppColors.success : AppColors.error),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Test Run Date: ${t.testDate.day}/${t.testDate.month}/${t.testDate.year} • Duration: ${t.durationFormatted}', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 8),
                      Text(t.testNotes, style: const TextStyle(fontSize: 12, height: 1.4)),
                      const SizedBox(height: 6),
                      Text('Validated By: ${t.validatedBy}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // GUIDED 5-STEP RECOVERY WORKFLOW MODAL
  // ==========================================================================
  Widget _buildGuidedRestoreModal(bool isDark) {
    final bck = _selectedBackupForRestore!;

    return Center(
      child: Container(
        width: 580,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.warning, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Disaster Recovery Guided Workflow', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Step $_restoreStep of 5: ${_getStepTitle(_restoreStep)}', style: const TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _selectedBackupForRestore = null),
                ),
              ],
            ),
            const Divider(height: 20),

            // Step Content
            if (_restoreStep == 1) ...[
              const Text('Selected Recovery Snapshot:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(bck.backupCode, style: const TextStyle(fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
              Text('Size: ${bck.sizeMb} MB • Completed: ${bck.completedAt}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              const SizedBox(height: 14),
              const Text('Included Scopes: PostgreSQL Relational DB, Mongo Documents, Quotation Rates, Lead Ledgers, User Directory.', style: TextStyle(fontSize: 12)),
            ] else if (_restoreStep == 2) ...[
              const Text('Checksum & Integrity Verification:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle, borderRadius: BorderRadius.circular(8)),
                child: Text('SHA-256: ${bck.sha256Checksum}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  SizedBox(width: 6),
                  Text('Cryptographic signature valid. No bit rot detected.', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
                ],
              ),
            ] else if (_restoreStep == 3) ...[
              const Text('Recovery Operational Impact:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error)),
              const SizedBox(height: 8),
              const Text(
                '1. All active transactions created after this snapshot will be rolled back.\n'
                '2. Active user sessions will be automatically invalidated.\n'
                '3. A pre-restore safety snapshot will be taken automatically before overwrite begins.',
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ] else if (_restoreStep == 4) ...[
              const Text('High-Friction Destructive Confirmation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
              const SizedBox(height: 8),
              const Text(
                'Type "RESTORE" below to initiate emergency database roll-forward:',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Type RESTORE here',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ] else if (_restoreStep == 5) ...[
              if (_isRestoring) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 14),
                        Text('Rebuilding schemas & indexes from snapshot...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle_rounded, size: 44, color: AppColors.success),
                      SizedBox(height: 10),
                      Text('Database Restoration Completed Successfully', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success)),
                      SizedBox(height: 4),
                      Text('System baseline operational. All data tables restored.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_restoreStep > 1 && _restoreStep < 5)
                  OutlinedButton(
                    onPressed: () => setState(() => _restoreStep--),
                    child: const Text('Back'),
                  ),
                const SizedBox(width: 8),
                if (_restoreStep < 4)
                  ElevatedButton(
                    onPressed: () => setState(() => _restoreStep++),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Next Step'),
                  )
                else if (_restoreStep == 4)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _restoreStep = 5;
                        _isRestoring = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() => _isRestoring = false);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                    child: const Text('Confirm Restore'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedBackupForRestore = null),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                    child: const Text('Dismiss'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Select & Review Scope';
      case 2:
        return 'Verify SHA-256 Checksum';
      case 3:
        return 'Assess Rollback Impact';
      case 4:
        return 'Destructive Confirmation';
      case 5:
        return 'Executing Database Restore';
      default:
        return '';
    }
  }
}
