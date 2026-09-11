import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/admin_phase2_models.dart';
import '../models/admin_phase2_mock_data.dart';
import '../widgets/admin_shared_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<AdminNotificationLog> _logs = List.from(AdminPhase2MockData.notifications);
  final List<NotificationRule> _rules = List.from(AdminPhase2MockData.notificationRules);
  final List<UserNotificationPreference> _preferences = List.from(AdminPhase2MockData.defaultPreferences);

  String _searchQuery = '';
  NotificationChannelType? _selectedChannelFilter;
  NotificationDeliveryStatus? _selectedStatusFilter;
  AdminNotificationLog? _selectedLogDetail;
  bool _isCreateRuleModalOpen = false;

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

  List<AdminNotificationLog> get _filteredLogs {
    return _logs.where((log) {
      if (_selectedChannelFilter != null && log.channel != _selectedChannelFilter) {
        return false;
      }
      if (_selectedStatusFilter != null && log.deliveryStatus != _selectedStatusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = log.recipientName.toLowerCase().contains(q) ||
            log.eventTitle.toLowerCase().contains(q) ||
            log.relatedRecordTitle.toLowerCase().contains(q) ||
            log.relatedRecordId.toLowerCase().contains(q) ||
            log.messageBody.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(context);

    final sentToday = _logs.length;
    final deliveredCount = _logs.where((l) => l.deliveryStatus == NotificationDeliveryStatus.delivered || l.deliveryStatus == NotificationDeliveryStatus.read).length;
    final failedCount = _logs.where((l) => l.deliveryStatus == NotificationDeliveryStatus.failed).length;
    final activeRulesCount = _rules.where((r) => r.isActive).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Module Header
                AdminHeader(
                  title: 'Notification Center & Rules',
                  description: 'Centralized event dispatch monitoring across In-App, Push, WhatsApp, SMS, and Email channels.',
                  icon: Icons.notifications_active_rounded,
                  breadcrumbs: const ['Homio Administration', 'Operations Control', 'Notifications'],
                  actions: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dispatched real-time health ping to WhatsApp Cloud API & FCM Gateway.')),
                        );
                      },
                      icon: const Icon(Icons.wifi_tethering_rounded, size: 16),
                      label: const Text('Test Gateway Ping', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isCreateRuleModalOpen = true),
                      icon: const Icon(Icons.add_alert_rounded, size: 16),
                      label: const Text('New Notification Rule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                      label: 'Dispatched Today',
                      value: '$sentToday',
                      subtitle: '99.2% Gateway Uptime',
                      icon: Icons.send_rounded,
                      color: AppColors.primary,
                      trendText: '+14%',
                      isPositiveTrend: true,
                    ),
                    AdminMetricItem(
                      label: 'Successfully Delivered',
                      value: '$deliveredCount',
                      subtitle: 'Direct carrier confirmed',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                    ),
                    AdminMetricItem(
                      label: 'Failed / Retrying',
                      value: '$failedCount',
                      subtitle: 'Auto-recovery queue active',
                      icon: Icons.error_outline_rounded,
                      color: AppColors.error,
                    ),
                    AdminMetricItem(
                      label: 'Active Notification Rules',
                      value: '$activeRulesCount Configured',
                      subtitle: '5 Core Channels Enabled',
                      icon: Icons.tune_rounded,
                      color: AppColors.secondary,
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
                      Tab(icon: Icon(Icons.receipt_long_rounded, size: 18), text: 'Activity & Delivery Logs'),
                      Tab(icon: Icon(Icons.rule_folder_rounded, size: 18), text: 'Configured Notification Rules'),
                      Tab(icon: Icon(Icons.tune_rounded, size: 18), text: 'Channel Preferences & Policies'),
                    ],
                  ),
                ),

                // 4. Tab Views
                if (_tabController.index == 0)
                  _buildActivityTab(isDark, isMobile),
                if (_tabController.index == 1)
                  _buildRulesTab(isDark, isMobile),
                if (_tabController.index == 2)
                  _buildPreferencesTab(isDark, isMobile),
              ],
            ),
          ),

          // Detail Slideover Drawer
          if (_selectedLogDetail != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildLogDetailDrawer(isDark),
            ),

          // Create Rule Modal
          if (_isCreateRuleModalOpen)
            _buildCreateRuleModal(isDark),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: NOTIFICATION ACTIVITY & DELIVERY LOGS
  // ==========================================================================
  Widget _buildActivityTab(bool isDark, bool isMobile) {
    final list = _filteredLogs;

    return Column(
      children: [
        // Filter Bar
        AdminFilterBar(
          searchQuery: _searchQuery,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          searchHint: 'Search recipient, event title, record ID (e.g. MTG-8821, PRJ-401)...',
          filterControls: [
            DropdownButton<NotificationChannelType?>(
              value: _selectedChannelFilter,
              hint: const Text('All Channels', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Channels', style: TextStyle(fontSize: 12))),
                for (final ch in NotificationChannelType.values)
                  DropdownMenuItem(value: ch, child: Text(ch.label, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedChannelFilter = val),
            ),
            DropdownButton<NotificationDeliveryStatus?>(
              value: _selectedStatusFilter,
              hint: const Text('All Statuses', style: TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                for (final st in NotificationDeliveryStatus.values)
                  DropdownMenuItem(value: st, child: Text(st.label, style: const TextStyle(fontSize: 12))),
              ],
              onChanged: (val) => setState(() => _selectedStatusFilter = val),
            ),
          ],
          onExport: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exported notification delivery history to CSV format.')),
            );
          },
        ),

        // Activity Table or Mobile Cards
        if (list.isEmpty)
          _buildEmptyState(isDark)
        else if (isMobile)
          _buildMobileActivityCards(list, isDark)
        else
          _buildDesktopActivityTable(list, isDark),
      ],
    );
  }

  Widget _buildDesktopActivityTable(List<AdminNotificationLog> list, bool isDark) {
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
              DataColumn(label: Text('Recipient & Role', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Event & Subject', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Channel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Related Record', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Dispatched At', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Delivery Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Trigger Source', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ],
            rows: list.map((log) {
              return DataRow(
                cells: [
                  // Recipient
                  DataCell(
                    InkWell(
                      onTap: () => setState(() => _selectedLogDetail = log),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(log.recipientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('${log.recipientRoleOrType} • ${log.recipientContact}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ),
                  // Event
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: Text(log.eventTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  // Channel
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(log.channel.icon, size: 16, color: log.channel.color),
                        const SizedBox(width: 6),
                        Text(log.channel.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: log.channel.color)),
                      ],
                    ),
                  ),
                  // Related Record
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Text('${log.relatedRecordType}: ${log.relatedRecordId}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // Dispatched At
                  DataCell(
                    Text('${log.sentAt.hour.toString().padLeft(2, '0')}:${log.sentAt.minute.toString().padLeft(2, '0')} IST', style: const TextStyle(fontSize: 12)),
                  ),
                  // Status
                  DataCell(
                    AdminStatusBadge(label: log.deliveryStatus.label, color: log.deliveryStatus.color),
                  ),
                  // Trigger Source
                  DataCell(
                    Text(log.triggeredBy, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ),
                  // Actions
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      tooltip: 'View Delivery Payload & Trace',
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

  Widget _buildMobileActivityCards(List<AdminNotificationLog> list, bool isDark) {
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
                    Row(
                      children: [
                        Icon(log.channel.icon, size: 15, color: log.channel.color),
                        const SizedBox(width: 6),
                        Text(log.channel.label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: log.channel.color)),
                      ],
                    ),
                    AdminStatusBadge(label: log.deliveryStatus.label, color: log.deliveryStatus.color),
                  ],
                ),
                const SizedBox(height: 8),
                Text(log.eventTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 3),
                Text('To: ${log.recipientName} (${log.recipientContact})', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Record: ${log.relatedRecordId}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    OutlinedButton(
                      onPressed: () => setState(() => _selectedLogDetail = log),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Trace Details', style: TextStyle(fontSize: 11.5)),
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
  // TAB 2: CONFIGURABLE NOTIFICATION RULES
  // ==========================================================================
  Widget _buildRulesTab(bool isDark, bool isMobile) {
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
                  Text('Automated Notification Rules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  Text('Define how CRM events generate messages across WhatsApp, Email, Push & SMS.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isCreateRuleModalOpen = true),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Rule', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _rules.length,
            itemBuilder: (context, index) {
              final rule = _rules[index];
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.notifications_active_outlined, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(rule.ruleName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                    const SizedBox(width: 8),
                                    if (rule.isSystemMandatory)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('MANDATORY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.error)),
                                      ),
                                  ],
                                ),
                                Text('${rule.moduleName} • Event: ${rule.eventName}', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                              ],
                            ),
                          ),
                          Switch(
                            value: rule.isActive,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _rules[index] = rule.copyWith(isActive: val);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(rule.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Channels: ', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          Wrap(
                            spacing: 6,
                            children: rule.channels.map((ch) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: ch.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(ch.label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: ch.color)),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                          Text('Schedule: ${rule.scheduleOffset}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
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
  // TAB 3: USER CHANNEL PREFERENCES & POLICIES
  // ==========================================================================
  Widget _buildPreferencesTab(bool isDark, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Global Channel Dispatch Policies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          Text('Configure mandatory operational channels vs optional end-user opt-ins.', style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _preferences.length,
            itemBuilder: (context, index) {
              final pref = _preferences[index];
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
                          Text(pref.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          if (pref.isMandatory)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Mandatory System Message', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(pref.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: NotificationChannelType.values.map((ch) {
                          final enabled = pref.channelStates[ch] ?? false;
                          return FilterChip(
                            label: Text(ch.label, style: TextStyle(fontSize: 11, color: enabled ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                            selected: enabled,
                            selectedColor: ch.color,
                            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                            onSelected: pref.isMandatory
                                ? null
                                : (val) {
                                    setState(() {
                                      pref.channelStates[ch] = val;
                                    });
                                  },
                          );
                        }).toList(),
                      ),
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
  // LOG DETAIL DRAWER (Slide-over with technical trace)
  // ==========================================================================
  Widget _buildLogDetailDrawer(bool isDark) {
    final log = _selectedLogDetail!;

    return AdminDrawerLayout(
      title: 'Notification Delivery Trace',
      subtitle: '${log.id} • ${log.eventTitle}',
      onClose: () => setState(() => _selectedLogDetail = null),
      footerActions: [
        OutlinedButton(
          onPressed: () => setState(() => _selectedLogDetail = null),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Re-dispatching notification to ${log.recipientContact} via ${log.channel.label}...')),
            );
          },
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Retry Dispatch'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Channel Pill
            Row(
              children: [
                Icon(log.channel.icon, size: 18, color: log.channel.color),
                const SizedBox(width: 8),
                Text(log.channel.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: log.channel.color)),
                const Spacer(),
                AdminStatusBadge(label: log.deliveryStatus.label, color: log.deliveryStatus.color),
              ],
            ),
            const Divider(height: 24),

            _detailRow('Recipient', '${log.recipientName} (${log.recipientRoleOrType})', isDark),
            _detailRow('Target Contact', log.recipientContact, isDark),
            _detailRow('Related Record', '${log.relatedRecordType}: ${log.relatedRecordId} (${log.relatedRecordTitle})', isDark),
            _detailRow('Dispatched At', '${log.sentAt.toIso8601String().replaceFirst('T', ' ').substring(0, 19)} IST', isDark),
            _detailRow('Trigger Source', log.triggeredBy, isDark),
            if (log.templateCode != null)
              _detailRow('Template Used', log.templateCode!, isDark),

            const SizedBox(height: 16),
            Text('Rendered Message Body', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(log.messageBody, style: const TextStyle(fontSize: 13, height: 1.5)),
            ),

            if (log.failureReason != null) ...[
              const SizedBox(height: 16),
              Text('Failure Diagnostic', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(log.failureReason!, style: const TextStyle(fontSize: 12, color: AppColors.error, height: 1.4)),
              ),
            ],

            if (log.technicalPayload != null) ...[
              const SizedBox(height: 16),
              Text('Gateway Technical Payload', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(log.technicalPayload!, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  // ==========================================================================
  // CREATE RULE MODAL
  // ==========================================================================
  Widget _buildCreateRuleModal(bool isDark) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    NotificationRecipientType selectedType = NotificationRecipientType.customer;

    return Center(
      child: Container(
        width: 520,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Create Notification Rule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _isCreateRuleModalOpen = false),
                ),
              ],
            ),
            const Divider(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Rule Name *',
                hintText: 'e.g. Design Presentation 24h WhatsApp Reminder',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Explain when and why this notification triggers...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NotificationRecipientType>(
              initialValue: selectedType,
              decoration: InputDecoration(
                labelText: 'Target Recipient Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              items: NotificationRecipientType.values.map((t) {
                return DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (val) {
                if (val != null) selectedType = val;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _isCreateRuleModalOpen = false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please provide a rule name.')),
                      );
                      return;
                    }

                    final newRule = NotificationRule(
                      id: 'nr_${DateTime.now().millisecondsSinceEpoch}',
                      ruleName: nameCtrl.text,
                      eventCode: 'CUSTOM_OPERATIONAL_EVENT',
                      eventName: 'Custom Configured Trigger',
                      moduleName: 'Sales CRM & Funnels',
                      description: descCtrl.text.isEmpty ? 'Custom notification rule' : descCtrl.text,
                      recipientType: selectedType,
                      recipientTarget: selectedType.label,
                      channels: [NotificationChannelType.whatsApp, NotificationChannelType.inApp],
                      templateId: 'WT_GENERIC_ALERT',
                      triggerCondition: 'Event.triggered == true',
                      scheduleOffset: 'Immediate',
                    );

                    setState(() {
                      _rules.insert(0, newRule);
                      _isCreateRuleModalOpen = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification Rule "${newRule.ruleName}" created successfully.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Save & Activate'),
                ),
              ],
            ),
          ],
        ),
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
            const Icon(Icons.notifications_off_outlined, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text('No Notifications Match Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Try clearing search parameters or adjusting channel filters.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ],
        ),
      ),
    );
  }
}
