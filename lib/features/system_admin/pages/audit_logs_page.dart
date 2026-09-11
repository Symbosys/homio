import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_phase2_models.dart';
import '../models/admin_phase2_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  final List<AuditLogEntry> _auditLogs = List.from(AdminPhase2MockData.auditLogs);

  String _searchQuery = '';
  AuditSeverity? _severityFilter;
  AuditChangeType? _changeTypeFilter;
  AuditLogEntry? _selectedLogDetail;

  List<AuditLogEntry> get _filteredLogs {
    return _auditLogs.where((log) {
      if (_severityFilter != null && log.severity != _severityFilter) return false;
      if (_changeTypeFilter != null && log.changeType != _changeTypeFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = log.userName.toLowerCase().contains(q) ||
            log.actionTitle.toLowerCase().contains(q) ||
            log.moduleName.toLowerCase().contains(q) ||
            log.recordId.toLowerCase().contains(q) ||
            log.recordTitle.toLowerCase().contains(q) ||
            log.ipAddress.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    final totalEvents = _auditLogs.length;
    final criticalCount = _auditLogs.where((a) => a.severity == AuditSeverity.critical).length;
    final permissionChanges = _auditLogs.where((a) => a.changeType == AuditChangeType.permissionChange).length;
    final financialActions = _auditLogs.where((a) => a.changeType == AuditChangeType.financialAction).length;

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
                  title: 'System Activity & Audit Ledgers',
                  description: 'Cryptographically sealed audit trail proving who modified records, updated pricing rates, or altered permissions.',
                  icon: Icons.security_update_good_rounded,
                  breadcrumbs: const ['Homio Administration', 'Compliance & Security', 'Audit Logs'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Audit ledger export dispatched to compliance officer archive.')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Export Forensic CSV', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Integrity Check: SHA-256 ledger hashes verified. 0 tampering detected.')),
                        );
                      },
                      icon: const Icon(Icons.verified_outlined, size: 16),
                      label: const Text('Verify Ledger Integrity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                      label: 'Total Audit Events',
                      value: '$totalEvents Logged Today',
                      subtitle: '100% Immutable write-once',
                      icon: Icons.history_edu_rounded,
                      color: AppColors.primary,
                    ),
                    AdminMetricItem(
                      label: 'Critical / Sensitive Actions',
                      value: '$criticalCount Flagged',
                      subtitle: 'Direct supervisor alerted',
                      icon: Icons.shield_rounded,
                      color: AppColors.error,
                      trendText: 'Compliance active',
                      isPositiveTrend: false,
                    ),
                    AdminMetricItem(
                      label: 'Permission Changes',
                      value: '$permissionChanges Role Edits',
                      subtitle: 'RBAC boundary modifications',
                      icon: Icons.admin_panel_settings_outlined,
                      color: AppColors.warning,
                    ),
                    AdminMetricItem(
                      label: 'Financial & Rate Edits',
                      value: '$financialActions Rate Updates',
                      subtitle: 'Protected by historical lock',
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.success,
                    ),
                  ],
                ),

                // 3. Filter Bar
                AdminFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (q) => setState(() => _searchQuery = q),
                  searchHint: 'Search by operator, record ID, IP address, or action...',
                  filterControls: [
                    DropdownButton<AuditSeverity?>(
                      value: _severityFilter,
                      hint: const Text('All Severities', style: TextStyle(fontSize: 12)),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Severities', style: TextStyle(fontSize: 12))),
                        for (final s in AuditSeverity.values)
                          DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) => setState(() => _severityFilter = val),
                    ),
                    DropdownButton<AuditChangeType?>(
                      value: _changeTypeFilter,
                      hint: const Text('All Action Types', style: TextStyle(fontSize: 12)),
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Action Types', style: TextStyle(fontSize: 12))),
                        for (final t in AuditChangeType.values)
                          DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) => setState(() => _changeTypeFilter = val),
                    ),
                  ],
                ),

                // 4. Audit Table or Mobile Cards
                if (_filteredLogs.isEmpty)
                  _buildEmptyState(isDark)
                else if (isMobile)
                  _buildMobileAuditCards(_filteredLogs, isDark)
                else
                  _buildDesktopAuditTable(_filteredLogs, isDark),
              ],
            ),
          ),

          // Detail Slideover Drawer (Investigation View)
          if (_selectedLogDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildInvestigationDrawer(isDark),
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DESKTOP AUDIT TABLE
  // ==========================================================================
  Widget _buildDesktopAuditTable(List<AuditLogEntry> list, bool isDark) {
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
            dataRowMinHeight: 48,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('Timestamp (IST)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('User / Operator', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Action Performed', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Module & Record', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Action Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('IP / Origin', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Severity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Investigate', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ],
            rows: list.map((log) {
              return DataRow(
                cells: [
                  // Timestamp
                  DataCell(
                    Text(
                      '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')} IST',
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  // User
                  DataCell(
                    InkWell(
                      onTap: () => setState(() => _selectedLogDetail = log),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(log.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(log.userRole, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ),
                  // Action Title
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: Text(log.actionTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  // Module & Record
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(log.moduleName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('${log.recordType}: ${log.recordId}', style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  // Change Type
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(log.changeType.icon, size: 15, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(log.changeType.label, style: const TextStyle(fontSize: 11.5)),
                      ],
                    ),
                  ),
                  // IP / Origin
                  DataCell(
                    Text(log.ipAddress, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  ),
                  // Severity
                  DataCell(
                    AdminStatusBadge(label: log.severity.label, color: log.severity.color),
                  ),
                  // Investigate button
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.manage_search_rounded, size: 18),
                      tooltip: 'Inspect Before/After Diff & Timeline',
                      onPressed: () => setState(() => _selectedLogDetail = log),
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

  // ==========================================================================
  // MOBILE AUDIT CARDS
  // ==========================================================================
  Widget _buildMobileAuditCards(List<AuditLogEntry> list, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final log = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(log.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    AdminStatusBadge(label: log.severity.label, color: log.severity.color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(log.actionTitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${log.moduleName} • IP: ${log.ipAddress}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(log.recordId, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    OutlinedButton(
                      onPressed: () => setState(() => _selectedLogDetail = log),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('View Diff & Context', style: TextStyle(fontSize: 11.5)),
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
  // INVESTIGATION SLIDE-OVER DRAWER (Visual Diff: Field | Previous | New)
  // ==========================================================================
  Widget _buildInvestigationDrawer(bool isDark) {
    final log = _selectedLogDetail!;

    return AdminDrawerLayout(
      title: 'Forensic Audit Record',
      subtitle: '${log.id} • ${log.actionTitle}',
      onClose: () => setState(() => _selectedLogDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () => setState(() => _selectedLogDetail = null),
          child: const Text('Close'),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Severity Badge
            Row(
              children: [
                Icon(log.changeType.icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(log.changeType.label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
                const Spacer(),
                AdminStatusBadge(label: log.severity.label, color: log.severity.color),
              ],
            ),
            const Divider(height: 24),

            _infoItem('Operator Identity', '${log.userName} (${log.userRole})', isDark),
            _infoItem('Account Email', log.userEmail, isDark),
            _infoItem('Network IP & Session', '${log.ipAddress} • ${log.sessionLocation}', isDark),
            _infoItem('Timestamp', '${log.timestamp.toIso8601String().replaceFirst('T', ' ').substring(0, 19)} IST', isDark),
            _infoItem('Target Record', '${log.recordType}: ${log.recordId} (${log.recordTitle})', isDark),
            _infoItem('Operational Context', log.contextSummary, isDark),

            const SizedBox(height: 16),
            Text('Field-Level Change Diff', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
            const SizedBox(height: 8),

            if (log.diffs.isEmpty)
              Text('No field mutations recorded (Action: Read / Execution Trigger).', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))
            else
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: log.diffs.map((diff) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(diff.fieldName, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                              if (diff.isSensitiveMasked) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Masked Hash', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.error)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Previous Value', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error)),
                                      const SizedBox(height: 2),
                                      Text(diff.previousValue, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('New Value', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                                      const SizedBox(height: 2),
                                      Text(diff.newValue, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),
            Text('Security Seal & Cryptographic Immutability', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            const SizedBox(height: 4),
            Text('Entry ID: ${log.id} • Sealed via SHA-256 HMAC on Homio Compliance Node.', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text('No Audit Records Match Query', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Try clearing the search query or adjusting filter parameters.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ],
        ),
      ),
    );
  }
}
