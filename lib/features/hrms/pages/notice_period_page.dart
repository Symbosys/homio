import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/hrms_models.dart';
import '../models/hrms_mock_data.dart';

class NoticePeriodPage extends StatefulWidget {
  const NoticePeriodPage({super.key});

  @override
  State<NoticePeriodPage> createState() => _NoticePeriodPageState();
}

class _NoticePeriodPageState extends State<NoticePeriodPage> {
  final List<NoticePeriodHandoff> _handoffs = List.from(hrmsMockNoticeHandoffs);

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    final filteredHandoffs = _handoffs.where((h) {
      return h.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.employeeCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.department.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final activeExits = _handoffs.where((h) => !h.isRelievingLetterIssued).length;
    final completedExits = _handoffs.where((h) => h.isRelievingLetterIssued).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildKpiMetrics(isDark, activeExits, completedExits, width),
            const SizedBox(height: 24),
            _buildHandoffListCard(isDark, filteredHandoffs),
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
                  child: const Icon(Icons.person_remove_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Notice Period & Offboarding Handoff',
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
              '30/60/90 days countdown with mandatory 3-part clearance: Asset, Project Handoff, and Accounts F&F.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showInitiateOffboardingModal(isDark),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Initiate Offboarding'),
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

  Widget _buildKpiMetrics(bool isDark, int active, int completed, double width) {
    final cards = [
      _buildMetricCard(
        isDark: isDark,
        title: 'Active Offboarding Pipelines',
        value: '$active Personnel',
        sub: 'Serving notice period',
        icon: Icons.hourglass_empty_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: '3-Part Clearance Enforced',
        value: '100% Mandatory',
        sub: 'Asset + Project + Accounts',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _buildMetricCard(
        isDark: isDark,
        title: 'Completed Full & Final (F&F)',
        value: '$completed Handed Over',
        sub: 'Relieving letters issued',
        icon: Icons.task_alt_rounded,
        color: const Color(0xFF10B981),
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

  Widget _buildHandoffListCard(bool isDark, List<NoticePeriodHandoff> list) {
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
                'Notice Period Clearance Tracking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Strict SLA Clearance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              hintText: 'Search departing employee...',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.how_to_reg_rounded, size: 36, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
                    const SizedBox(height: 10),
                    Text(
                      'No active resignations currently in offboarding.',
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
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 28),
              itemBuilder: (context, index) {
                final item = list[index];
                return _buildHandoffCard(isDark, item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHandoffCard(bool isDark, NoticePeriodHandoff item) {
    final daysRemaining = item.lastWorkingDay.difference(DateTime.now()).inDays;
    final isClearedAll = item.isFullyCleared;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    child: Text(
                      item.employeeName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.employeeName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                        ),
                      ),
                      Text(
                        '${item.employeeCode} • ${item.department.displayName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: daysRemaining > 0
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.12)
                      : const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      daysRemaining > 0 ? Icons.access_time_rounded : Icons.check_circle_rounded,
                      size: 14,
                      color: daysRemaining > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      daysRemaining > 0 ? '$daysRemaining Days Left' : 'Notice Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: daysRemaining > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Exit Timeline: Resigned on ${DateFormat('dd MMM yyyy').format(item.resignationDate)} → Last Working Day: ${DateFormat('dd MMM yyyy').format(item.lastWorkingDay)} (${item.noticeDaysTotal} Days Notice)',
                style: TextStyle(fontSize: 11.5, color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 10),
          // 3-Part Checklist
          const Text('3-PART CLEARANCE HANDSHAKE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildChecklistToggle(
                  isDark: isDark,
                  title: '1. Asset Clearance',
                  desc: 'Laptop, ID card, keys',
                  isChecked: item.isAssetCleared,
                  onChanged: (val) {
                    _updateHandoff(item.copyWith(isAssetCleared: val));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildChecklistToggle(
                  isDark: isDark,
                  title: '2. Project Handoff',
                  desc: 'Sites, clients & drives',
                  isChecked: item.isProjectHandoffDone,
                  onChanged: (val) {
                    _updateHandoff(item.copyWith(isProjectHandoffDone: val));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildChecklistToggle(
                  isDark: isDark,
                  title: '3. Accounts & F&F',
                  desc: 'PF, gratuity & claims',
                  isChecked: item.isAccountsSettled,
                  onChanged: (val) {
                    _updateHandoff(item.copyWith(isAccountsSettled: val));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.handoverToEmployeeName != null)
                Text(
                  'Designated Successor: ${item.handoverToEmployeeName}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.gold),
                )
              else
                const SizedBox(),
              ElevatedButton.icon(
                onPressed: isClearedAll ? () => _issueRelievingLetter(item) : null,
                icon: const Icon(Icons.verified_rounded, size: 14),
                label: Text(item.isRelievingLetterIssued ? 'Relieving Letter Issued' : 'Generate Relieving Letter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.deepNavy,
                  disabledBackgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightBorder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistToggle({
    required bool isDark,
    required String title,
    required String desc,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isChecked
              ? const Color(0xFF10B981).withValues(alpha: 0.1)
              : (isDark ? AppColors.darkCardBg : AppColors.pureWhite),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked ? const Color(0xFF10B981) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: isChecked ? const Color(0xFF10B981) : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isChecked ? const Color(0xFF10B981) : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateHandoff(NoticePeriodHandoff updated) {
    setState(() {
      final idx = _handoffs.indexWhere((h) => h.id == updated.id);
      if (idx != -1) {
        _handoffs[idx] = updated;
      }
    });
  }

  void _issueRelievingLetter(NoticePeriodHandoff item) {
    setState(() {
      final idx = _handoffs.indexWhere((h) => h.id == item.id);
      if (idx != -1) {
        _handoffs[idx] = item.copyWith(isRelievingLetterIssued: true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Issued digital Relieving & Experience Certificate for ${item.employeeName}.'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _showInitiateOffboardingModal(bool isDark) {
    String selectedEmpId = hrmsMockEmployees.first.id;
    int noticeDays = 60;
    String successorName = 'Alok Nath';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Initiate Employee Offboarding',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.pureWhite : AppColors.deepNavy),
            ),
            content: SizedBox(
              width: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedEmpId,
                    decoration: const InputDecoration(labelText: 'Resigning Personnel', border: OutlineInputBorder()),
                    items: hrmsMockEmployees.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.name} (${e.code})'))).toList(),
                    onChanged: (val) => setDialogState(() => selectedEmpId = val!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    initialValue: noticeDays,
                    decoration: const InputDecoration(labelText: 'Notice Period Duration', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('30 Days Standard Notice')),
                      DropdownMenuItem(value: 60, child: Text('60 Days Lead/Manager Notice')),
                      DropdownMenuItem(value: 90, child: Text('90 Days Director/Critical Notice')),
                    ],
                    onChanged: (val) => setDialogState(() => noticeDays = val!),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Designated Handover Successor',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => successorName = val,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final emp = hrmsMockEmployees.firstWhere((e) => e.id == selectedEmpId);
                  final newHandoff = NoticePeriodHandoff(
                    id: 'not-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.name,
                    employeeCode: emp.code,
                    department: emp.department,
                    resignationDate: DateTime.now(),
                    lastWorkingDay: DateTime.now().add(Duration(days: noticeDays)),
                    noticeDaysTotal: noticeDays,
                    isAssetCleared: false,
                    isProjectHandoffDone: false,
                    isAccountsSettled: false,
                    handoverToEmployeeName: successorName.isNotEmpty ? successorName : null,
                  );
                  setState(() {
                    _handoffs.insert(0, newHandoff);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Initiated $noticeDays-day offboarding track for ${newHandoff.employeeName}')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.deepNavy),
                child: const Text('Start Offboarding Track'),
              ),
            ],
          );
        },
      ),
    );
  }
}
