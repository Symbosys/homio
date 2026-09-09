// Homio CRM — Enterprise Communication Audit Trail & History Workspace

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';
import '../models/communication_mock_data.dart';
import '../widgets/comm_page_header.dart';
import '../widgets/comm_kpi_card.dart';
import '../widgets/comm_status_badge.dart';
import '../widgets/comm_filter_bar.dart';
import '../widgets/comm_data_table.dart';

class CommunicationHistoryPage extends StatefulWidget {
  const CommunicationHistoryPage({super.key});

  @override
  State<CommunicationHistoryPage> createState() => _CommunicationHistoryPageState();
}

class _CommunicationHistoryPageState extends State<CommunicationHistoryPage> {
  late List<CommunicationRecord> _records;
  String _searchQuery = '';
  CommunicationChannel? _channelFilter;
  String _sourceFilter = 'All';

  @override
  void initState() {
    super.initState();
    _records = List.from(CommunicationMockData.auditHistory);
  }

  List<CommunicationRecord> get _filteredRecords {
    return _records.where((r) {
      final q = _searchQuery.toLowerCase();
      if (q.isNotEmpty &&
          !r.customerName.toLowerCase().contains(q) &&
          !r.customerPhone.toLowerCase().contains(q) &&
          !r.previewText.toLowerCase().contains(q)) {
        return false;
      }
      if (_channelFilter != null && r.channel != _channelFilter) {
        return false;
      }
      if (_sourceFilter != 'All' && r.sourceModule.toLowerCase() != _sourceFilter.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showRecordDetail(CommunicationRecord rec) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: rec.channel.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(rec.channel.icon, color: rec.channel.color, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Audit Record #${rec.id}', style: const TextStyle(fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuditRow('Timestamp', rec.timestamp.toString(), isDark),
                _buildAuditRow('Customer', '${rec.customerName} (${rec.customerPhone})', isDark),
                _buildAuditRow('Direction', rec.direction.label, isDark),
                _buildAuditRow('Channel', rec.channel.label, isDark),
                _buildAuditRow('Actor / Sender', '${rec.actorName} (${rec.actorType})', isDark),
                _buildAuditRow('Source Module', rec.sourceModule.toUpperCase(), isDark),
                if (rec.relatedEntityId != null)
                  _buildAuditRow('Linked CRM Entity', '${rec.relatedEntityType?.toUpperCase()}: ${rec.relatedEntityId}', isDark),
                if (rec.templateCode != null)
                  _buildAuditRow('WhatsApp Template', rec.templateCode!, isDark),
                const Divider(height: 16),
                const Text('Full Message Payload / Summary:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Text(
                    rec.previewText,
                    style: const TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAuditRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
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
            title: 'Communication Audit History & Logs',
            subtitle: 'Complete chronological audit trail of all manual, automated, broadcast & bot messages',
            icon: Icons.history_rounded,
            onExportCsv: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting audit trail to CSV file...')),
              );
            },
            onRefresh: () {
              setState(() {
                _records = List.from(CommunicationMockData.auditHistory);
              });
            },
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
                        title: 'Total Logged Records',
                        value: '142',
                        subtitle: 'Today’s audit entries',
                        icon: Icons.receipt_long_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'WhatsApp Volume',
                        value: '118',
                        subtitle: '83% of all traffic',
                        icon: Icons.chat_bubble_outline,
                        color: const Color(0xFF25D366),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Automations & Drips',
                        value: '64',
                        subtitle: 'Zero human touch',
                        icon: Icons.water_drop_outlined,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommKpiCard(
                        title: 'Delivery Health Rate',
                        value: '98.4%',
                        subtitle: 'Provider uptime',
                        icon: Icons.verified_outlined,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filter Bar
                CommFilterBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  searchHint: 'Search audit records by client, phone, or message preview...',
                  categories: const ['All', 'Manual', 'Broadcast', 'Drip', 'Chatbot'],
                  selectedCategory: _sourceFilter,
                  onCategorySelected: (cat) => setState(() => _sourceFilter = cat),
                  selectedChannel: _channelFilter,
                  onChannelChanged: (c) => setState(() => _channelFilter = c),
                  onResetFilters: () {
                    setState(() {
                      _searchQuery = '';
                      _channelFilter = null;
                      _sourceFilter = 'All';
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Table
                _buildHistoryTable(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable(bool isDark) {
    final filtered = _filteredRecords;

    final columns = [
      const CommDataColumn(label: 'Timestamp (IST)', width: 140),
      const CommDataColumn(label: 'Customer', width: 190),
      const CommDataColumn(label: 'Channel', width: 110),
      const CommDataColumn(label: 'Direction', width: 100),
      const CommDataColumn(label: 'Actor / Staff', width: 150),
      const CommDataColumn(label: 'Message Content Preview', width: 280),
      const CommDataColumn(label: 'Status', width: 110),
      const CommDataColumn(label: 'Source', width: 110),
    ];

    final rows = filtered.map((rec) {
      return CommDataRow(
        onTap: () => _showRecordDetail(rec),
        cells: [
          // Timestamp
          Text(
            rec.timestamp.toString().substring(0, 16),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),

          // Customer
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(rec.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(rec.customerPhone, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),

          // Channel
          CommStatusBadge.fromChannel(rec.channel),

          // Direction
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: rec.direction == MessageDirection.incoming
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rec.direction.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: rec.direction == MessageDirection.incoming ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
              ),
            ),
          ),

          // Actor
          Text(
            rec.actorName,
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Preview
          Text(
            rec.previewText,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Status
          CommStatusBadge.fromMessageStatus(rec.status),

          // Source
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Text(
              rec.sourceModule.toUpperCase(),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
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
