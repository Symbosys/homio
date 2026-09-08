import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/system_admin_models.dart';
import '../models/system_admin_mock_data.dart';

class DisasterBackupPage extends StatefulWidget {
  const DisasterBackupPage({super.key});

  @override
  State<DisasterBackupPage> createState() => _DisasterBackupPageState();
}

class _DisasterBackupPageState extends State<DisasterBackupPage> {
  final List<DisasterBackupLog> _backupLogs = List.from(SystemAdminMockData.disasterBackupLogs);
  bool _isBackingUp = false;

  void _triggerAdHocBackup() {
    setState(() => _isBackingUp = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCardBg : AppColors.pureWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.gold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Executing Ad-Hoc Disaster Recovery Snapshot',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Querying PostgreSQL tables & MongoDB collections...\n'
                      '2. Generating Multi-Tab Formatted Excel Workbook (.xlsx)...\n'
                      '3. Applying AES-256 archive encryption...\n'
                      '4. Dispatching backup to superadmin@homio.in...',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final newSnapshot = DisasterBackupLog(
        id: 'BCK-${DateTime.now().millisecondsSinceEpoch}',
        backupCode: 'HOMIO-DB-MANUAL-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}',
        timestamp: DateTime.now(),
        triggerType: 'Ad-Hoc Manual Trigger',
        sizeMb: 168.4,
        includedFormats: ['Excel (.xlsx)', 'SQL Dump (.sql.gz)', 'Media Manifest (.json)'],
        sha256Checksum: '7fa0c98fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852e128',
        destinationEmail: 'superadmin@homio.in, compliance@homio.in',
        status: BackupStatus.completed,
        durationFormatted: '1m 45s',
      );

      setState(() {
        _backupLogs.insert(0, newSnapshot);
        _isBackingUp = false;
      });

      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Disaster Snapshot ${newSnapshot.backupCode} compiled (168.4 MB) and delivered to designated Super Admin.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF0F9D58),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  void _simulateRestoreTest(DisasterBackupLog log) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sandbox Integrity Test Succeeded for ${log.backupCode}: SHA-256 verified with 0 corrupted tables.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildMetricsRow(isDark, width),
            const SizedBox(height: 24),
            _buildWeeklyScheduleBanner(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildBundleArtifactCards(isDark, width),
            const SizedBox(height: 24),
            _buildHistoricalArchivesTable(isDark, isDesktop),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.backup_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Automated Disaster Recovery & Email Backups',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'PRD Module 14.4: Automated Sunday 00:00 UTC multi-tab Excel (.xlsx) and encrypted SQL/JSON database dumps dispatched to Super Admin.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _isBackingUp ? null : _triggerAdHocBackup,
          icon: const Icon(Icons.flash_on_rounded, size: 16),
          label: const Text('Trigger Ad-Hoc Snapshot'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(bool isDark, double width) {
    final isDesktop = width >= Breakpoints.medium;

    final cards = [
      _buildMetricCard(
        title: 'Weekly Automated Cron',
        value: 'ACTIVE (Sunday 00:00 UTC)',
        subtitle: 'Next run in 6 days 7 hours',
        icon: Icons.schedule_rounded,
        color: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Mean Backup Size',
        value: '158.2 MB / Snapshot',
        subtitle: 'Multi-tab Excel + SQL gz',
        icon: Icons.storage_rounded,
        color: AppColors.gold,
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Integrity Checksum',
        value: 'SHA-256 Tamper-Proof',
        subtitle: 'Zero data corruption detected',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Dispatched Destination',
        value: 'Super Admin Email',
        subtitle: 'superadmin@homio.in',
        icon: Icons.mark_email_read_rounded,
        color: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((c) => SizedBox(width: (width - 44) / 2, child: c)).toList(),
      );
    }
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyScheduleBanner(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cloud_done_rounded, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Automated Cron: Every Sunday at 00:00 UTC (05:30 IST)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '100% HEALTHY',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'The automated recovery daemon dumps all platform tables into an encrypted zip archive. It compiles human-readable Multi-Tab Excel spreadsheets for offline financial auditing, creates a raw PostgreSQL dump, and emails download tokens directly to designated executive addresses.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBundleArtifactCards(bool isDark, double width) {
    final isDesktop = width >= Breakpoints.medium;

    final cards = [
      _buildArtifactCard(
        title: 'Formatted Excel (.xlsx)',
        desc: '12-Tab Workbook covering CRM Leads, Quotation Items, Material RFQs, Vendor Ratings, HRMS Staff, and Client Financial Ledgers.',
        icon: Icons.table_chart_rounded,
        accentColor: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildArtifactCard(
        title: 'Database Dump (.sql.gz)',
        desc: 'Full relational schema & table record dump with AES-256 compression. Suitable for cold recovery in standalone database instances.',
        icon: Icons.terminal_rounded,
        accentColor: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildArtifactCard(
        title: 'Media Asset CDN Manifest (.json)',
        desc: 'Index of all 3D CAD blueprints, client progress video URLs, and signed inspection handover certificates stored in S3 object storage.',
        icon: Icons.video_collection_rounded,
        accentColor: AppColors.gold,
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList(),
      );
    }
  }

  Widget _buildArtifactCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalArchivesTable(bool isDark, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.gold, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Historical Weekly Snapshots & Delivery Audit Logs',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _backupLogs.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            itemBuilder: (context, index) {
              final log = _backupLogs[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.archive_outlined, color: AppColors.gold, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                log.backupCode,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log.status.label.toUpperCase(),
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DateFormat('dd MMM yyyy, HH:mm').format(log.timestamp)} • Trigger: ${log.triggerType} • Time: ${log.durationFormatted}',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SHA-256: ${log.sha256Checksum}',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isDesktop) ...[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dispatched to:',
                              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              log.destinationEmail,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${log.sizeMb.toStringAsFixed(1)} MB',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.gold),
                      ),
                      const SizedBox(width: 16),
                    ],
                    OutlinedButton.icon(
                      onPressed: () => _simulateRestoreTest(log),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                      label: const Text('Verify'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
