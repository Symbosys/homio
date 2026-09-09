import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/after_sales_models.dart';
import '../models/after_sales_mock_data.dart';
import '../widgets/after_sales_header.dart';
import '../widgets/create_complaint_modal.dart';

class ComplaintsSnagsPage extends StatefulWidget {
  const ComplaintsSnagsPage({super.key});

  @override
  State<ComplaintsSnagsPage> createState() => _ComplaintsSnagsPageState();
}

class _ComplaintsSnagsPageState extends State<ComplaintsSnagsPage> {
  final List<Complaint> _complaints = List.from(AfterSalesMockData.complaints);

  String _searchQuery = '';
  ComplaintSeverity? _selectedSeverity;
  ComplaintStatus? _selectedStatus;
  String _dateFilter = 'This Month';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    final filtered = _complaints.where((c) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = c.complaintNumber.toLowerCase().contains(q) ||
            c.customerName.toLowerCase().contains(q) ||
            c.customerPhone.contains(q) ||
            c.projectName.toLowerCase().contains(q) ||
            c.subject.toLowerCase().contains(q) ||
            c.complaintType.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedSeverity != null && c.severity != _selectedSeverity) return false;
      if (_selectedStatus != null && c.status != _selectedStatus) return false;
      return true;
    }).toList();

    // KPIs
    final totalComplaints = _complaints.length;
    final openComplaints = _complaints.where((c) => c.status != ComplaintStatus.resolved && c.status != ComplaintStatus.closed).length;
    final criticalCount = _complaints.where((c) => c.severity == ComplaintSeverity.critical && c.status != ComplaintStatus.resolved).length;
    final overdueCount = _complaints.where((c) => c.isOverdue).length;
    final resolvedCount = _complaints.where((c) => c.status == ComplaintStatus.resolved || c.status == ComplaintStatus.closed).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AfterSalesHeader(
              title: 'Complaints, Snags & Quality Escalations',
              subtitle: 'Defect management system tracking multi-snag resolutions, severity escalations, and executive customer sign-offs.',
              activeTab: 'Complaints / Snags',
              selectedDateFilter: _dateFilter,
              onDateFilterChanged: (val) => setState(() => _dateFilter = val),
              trailing: ElevatedButton.icon(
                onPressed: () => _openCreateModal(context),
                icon: const Icon(Icons.report_problem_rounded, size: 16),
                label: const Text('Log Customer Complaint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpi('Total Complaints', '$totalComplaints', 'All logged grievances', Icons.report_outlined, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Unresolved / Open', '$openComplaints', 'Under active investigation', Icons.pending_actions_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Critical Severity', '$criticalCount', 'Safety & structural risk', Icons.dangerous_rounded, const Color(0xFFDC2626), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('SLA Overdue', '$overdueCount', 'Immediate escalation required', Icons.alarm_off_rounded, const Color(0xFF991B1B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpi('Resolved & Closed', '$resolvedCount', 'Customer confirmed', Icons.verified_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpi('Total Complaints', '$totalComplaints', 'All logged grievances', Icons.report_outlined, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Unresolved / Open', '$openComplaints', 'Under active investigation', Icons.pending_actions_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Critical Severity', '$criticalCount', 'Safety & structural risk', Icons.dangerous_rounded, const Color(0xFFDC2626), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('SLA Overdue', '$overdueCount', 'Immediate escalation required', Icons.alarm_off_rounded, const Color(0xFF991B1B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpi('Resolved & Closed', '$resolvedCount', 'Customer confirmed', Icons.verified_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search & Filter Panel
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search complaints by #, customer, project, defect type, or subject...',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<ComplaintSeverity?>(
                            initialValue: _selectedSeverity,
                            decoration: InputDecoration(
                              labelText: 'Severity',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Severities')),
                              ...ComplaintSeverity.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedSeverity = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<ComplaintStatus?>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              filled: true,
                              fillColor: backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Statuses')),
                              ...ComplaintStatus.values.map((st) => DropdownMenuItem(value: st, child: Text(st.label))),
                            ],
                            onChanged: (val) => setState(() => _selectedStatus = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Complaints List with Nested Snags Expandable Cards
                  Text('Active Complaints & Snag Breakdown (${filtered.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: c.severity == ComplaintSeverity.critical ? Colors.red.withValues(alpha: 0.4) : borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Status, Severity, Number & Escalation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: c.status.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(c.status.label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: c.status.color)),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: c.severity.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(c.severity.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.severity.color)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('${c.complaintNumber} • Age: ${c.ageInDays} days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondaryColor)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(c.escalationLevel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.orange)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Headline & Narrative
                            Text(c.subject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimaryColor)),
                            const SizedBox(height: 4),
                            Text(c.description, style: TextStyle(fontSize: 12, height: 1.4, color: textSecondaryColor)),
                            const SizedBox(height: 10),

                            // Customer & Project Context Row
                            Row(
                              children: [
                                Text('${c.customerName} (${c.customerPhone})', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                                const SizedBox(width: 12),
                                Text('• ${c.projectName} (${c.projectId})', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                const SizedBox(width: 12),
                                Text('• Handover: ${c.handoverDate.day}/${c.handoverDate.month}/${c.handoverDate.year}', style: TextStyle(fontSize: 12, color: textMutedColor)),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Nested Snags List
                            if (c.snags.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Constituent Snag Items (${c.snags.length})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                                        const Text('Multi-item defect tracking active', style: TextStyle(fontSize: 10, color: Color(0xFF10B981))),
                                      ],
                                    ),
                                    const Divider(height: 16),
                                    ...c.snags.map((snag) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: snag.status.color.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(snag.snagNumber, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: snag.status.color)),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(snag.description, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                                                  Text('${snag.roomArea} (${snag.specificLocation}) • Team: ${snag.responsibleTeam} • Tech: ${snag.assignedPerson}', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: surfaceColor,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: borderColor),
                                              ),
                                              child: Text(snag.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: snag.status.color)),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Actions Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Assigned Owner: ${c.assignedToName} (${c.assignedToRole})',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondaryColor),
                                ),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => _escalateComplaint(c),
                                      icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                                      label: const Text('Escalate'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        side: const BorderSide(color: Colors.orange),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (c.status != ComplaintStatus.resolved && c.status != ComplaintStatus.closed)
                                      ElevatedButton.icon(
                                        onPressed: () => _resolveComplaint(c),
                                        icon: const Icon(Icons.check_circle_outline, size: 16),
                                        label: const Text('Mark Resolved & Close Snags'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 0,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpi(String label, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCreateModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CreateComplaintModal(
        onComplaintCreated: (newComplaint) {
          setState(() => _complaints.insert(0, newComplaint));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Complaint ${newComplaint.complaintNumber} registered and escalated to Service Manager!')),
          );
        },
      ),
    );
  }

  void _escalateComplaint(Complaint c) {
    setState(() {
      final idx = _complaints.indexWhere((x) => x.id == c.id);
      if (idx != -1) {
        _complaints[idx] = _complaints[idx].copyWith(
          escalationLevel: 'Executive Management Escalation Active',
          status: ComplaintStatus.escalated,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint ${c.complaintNumber} escalated to VP Operations & Executive Leadership.')),
    );
  }

  void _resolveComplaint(Complaint c) {
    setState(() {
      final idx = _complaints.indexWhere((x) => x.id == c.id);
      if (idx != -1) {
        _complaints[idx] = _complaints[idx].copyWith(
          status: ComplaintStatus.resolved,
          resolvedDate: DateTime.now(),
          isCustomerConfirmed: true,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint ${c.complaintNumber} verified and marked as RESOLVED!')),
    );
  }
}
