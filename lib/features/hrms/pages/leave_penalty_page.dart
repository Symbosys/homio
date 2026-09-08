import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class LeavePenaltyPage extends StatefulWidget {
  const LeavePenaltyPage({super.key});

  @override
  State<LeavePenaltyPage> createState() => _LeavePenaltyPageState();
}

class _LeavePenaltyPageState extends State<LeavePenaltyPage> {
  final List<LeaveApplication> _leaves = List.from(hrmsMockLeaves);

  String _searchQuery = '';
  ApprovalStatus? _filterStatus;
  bool _filterPenaltyOnly = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredLeaves = _leaves.where((l) {
      final matchesSearch = l.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.employeeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.reason.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == null || l.status == _filterStatus;
      final matchesPenalty = !_filterPenaltyOnly || l.isDoublePenaltyApplied;

      return matchesSearch && matchesStatus && matchesPenalty;
    }).toList();

    final pendingCount = _leaves.where((l) => l.status == ApprovalStatus.pending).length;
    final approvedCount = _leaves.where((l) => l.status == ApprovalStatus.approved).length;
    final penaltyDeductions = _leaves
        .where((l) => l.isDoublePenaltyApplied)
        .fold<double>(0, (sum, l) => sum + l.penaltyDeductionAmount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildDoublePenaltyBanner(isDark),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, pendingCount, approvedCount, penaltyDeductions, width),
            const SizedBox(height: 24),
            _buildLeaveApplicationsCard(isDark, filteredLeaves),
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
                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.event_busy_rounded, color: Color(0xFFEF4444), size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Leave Roster & Double Penalty Enforcement',
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
              'PRD Rule: Unapproved leave or absence post-rejection incurs a mandatory 2-day base salary penalty per day.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showApplyLeaveModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Apply Leave'),
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

  Widget _buildDoublePenaltyBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COMPLIANCE CLAUSE: DOUBLE SALARY DEDUCTION PROTOCOL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Any personnel taking unapproved leave, ghosting shift rosters, or remaining absent after formal manager denial automatically incurs a 2X daily base salary deduction in that month\'s automated payroll: Deduction = (Base Salary / 30) × 2 × Days.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(bool isDark, int pending, int approved, double penaltyTotal, double width) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Pending Manager Decisions',
        value: '$pending Applications',
        sub: 'Requires approval / denial',
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Approved Active Leaves',
        value: '$approved Cleared',
        sub: 'Protected standard quota',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF10B981),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: '2X Penalties Enforced',
        value: '₹${NumberFormat('#,##,###').format(penaltyTotal)}',
        sub: 'Auto-deducted from payroll',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFEF4444),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Standard Quotas (Yr)',
        value: '12 CL / 8 SL / 15 PL',
        sub: 'Pro-rata monthly credit',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF3B82F6),
      ),
    ];

    if (width < Breakpoints.compact) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
    );
  }

  Widget _buildMetricCard({
    required bool isDark,
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveApplicationsCard(bool isDark, List<LeaveApplication> leaves) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leave Requests & Compliance Audit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filterStatus == null && !_filterPenaltyOnly,
                    onSelected: (_) => setState(() {
                      _filterStatus = null;
                      _filterPenaltyOnly = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Pending'),
                    selected: _filterStatus == ApprovalStatus.pending,
                    onSelected: (val) => setState(() {
                      _filterStatus = val ? ApprovalStatus.pending : null;
                      _filterPenaltyOnly = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('2X Penalties Only'),
                    selected: _filterPenaltyOnly,
                    selectedColor: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    onSelected: (val) => setState(() {
                      _filterPenaltyOnly = val;
                      _filterStatus = null;
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search by employee, code, or reason...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (leaves.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_available_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No leave applications match the selected criteria.',
                      style: TextStyle(color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leaves.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final item = leaves[index];
                return _buildLeaveRow(isDark, item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLeaveRow(bool isDark, LeaveApplication item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isDoublePenaltyApplied
            ? const Color(0xFFEF4444).withValues(alpha: 0.05)
            : (isDark ? AppColors.darkSurface : AppColors.lightBackground),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isDoublePenaltyApplied
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: item.isDoublePenaltyApplied
                ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                : AppColors.gold.withValues(alpha: 0.15),
            child: Icon(
              item.isDoublePenaltyApplied ? Icons.local_fire_department_rounded : Icons.calendar_month_rounded,
              color: item.isDoublePenaltyApplied ? const Color(0xFFEF4444) : AppColors.gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.employeeName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.employeeCode,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildLeaveTypeTag(item.type),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.reason,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.date_range_rounded, size: 12, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(width: 5),
                    Text(
                      '${DateFormat('dd MMM').format(item.startDate)} - ${DateFormat('dd MMM yyyy').format(item.endDate)} (${item.days} ${item.days > 1 ? "days" : "day"})',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                if (item.isDoublePenaltyApplied) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '2X Deduction Enforced: ₹${NumberFormat('#,##,###').format(item.penaltyDeductionAmount)} (${item.days * 2} days base equivalent)',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 14),
          _buildLeaveStatusAndAction(isDark, item),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeTag(LeaveType type) {
    Color color;
    switch (type) {
      case LeaveType.casual:
        color = const Color(0xFF3B82F6);
        break;
      case LeaveType.sick:
        color = const Color(0xFF10B981);
        break;
      case LeaveType.paid:
        color = const Color(0xFF8B5CF6);
        break;
      case LeaveType.unpaid:
        color = const Color(0xFF64748B);
        break;
      case LeaveType.unapproved:
      case LeaveType.unapprovedAbsence:
        color = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.displayName,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _buildLeaveStatusAndAction(bool isDark, LeaveApplication item) {
    if (item.status == ApprovalStatus.approved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('Approved', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
      );
    }

    if (item.status == ApprovalStatus.rejected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('Rejected', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              final idx = _leaves.indexWhere((l) => l.id == item.id);
              if (idx != -1) {
                _leaves[idx] = item.copyWith(status: ApprovalStatus.approved);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Approved leave for ${item.employeeName}')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Approve', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => _confirmDenyAndWarnPenalty(item),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF4444),
            side: const BorderSide(color: Color(0xFFEF4444)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Reject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  void _confirmDenyAndWarnPenalty(LeaveApplication item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Leave Application?'),
        content: Text(
          'Denying this request formally notifies ${item.employeeName}.\n\nUnder PRD Section 13, taking leave despite formal rejection triggers an automatic 2X Base Salary Deduction on payroll.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = _leaves.indexWhere((l) => l.id == item.id);
                if (idx != -1) {
                  _leaves[idx] = item.copyWith(status: ApprovalStatus.rejected);
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rejected request. Double-penalty clause armed for ${item.employeeName}'),
                  backgroundColor: const Color(0xFFEF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Confirm Rejection'),
          ),
        ],
      ),
    );
  }

  void _showApplyLeaveModal(bool isDark) {
    String selectedEmpId = hrmsMockEmployees.first.id;
    LeaveType leaveType = LeaveType.casual;
    int days = 1;
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Submit Leave Application',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            content: SizedBox(
              width: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedEmpId,
                    decoration: const InputDecoration(labelText: 'Employee', border: OutlineInputBorder()),
                    items: hrmsMockEmployees.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.name} (${e.code})'))).toList(),
                    onChanged: (val) => setDialogState(() => selectedEmpId = val!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<LeaveType>(
                    initialValue: leaveType,
                    decoration: const InputDecoration(labelText: 'Leave Classification', border: OutlineInputBorder()),
                    items: LeaveType.values.where((t) => t != LeaveType.unapproved && t != LeaveType.unapprovedAbsence).map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.displayName));
                    }).toList(),
                    onChanged: (val) => setDialogState(() => leaveType = val!),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: days.toString(),
                    decoration: const InputDecoration(labelText: 'Number of Days', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setDialogState(() => days = int.tryParse(val) ?? 1),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Reason for Leave *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (reasonCtrl.text.trim().isEmpty) return;
                  final emp = hrmsMockEmployees.firstWhere((e) => e.id == selectedEmpId);
                  final newLeave = LeaveApplication(
                    id: 'lv-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.name,
                    employeeCode: emp.code,
                    leaveType: leaveType,
                    startDate: DateTime.now().add(const Duration(days: 2)),
                    endDate: DateTime.now().add(Duration(days: 2 + days - 1)),
                    totalDays: days,
                    reason: reasonCtrl.text.trim(),
                    status: ApprovalStatus.pending,
                    isDoublePenaltyApplied: false,
                  );
                  setState(() {
                    _leaves.insert(0, newLeave);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Applied for ${newLeave.days} day(s) leave for ${newLeave.employeeName}')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Submit Application'),
              ),
            ],
          );
        },
      ),
    );
  }
}
