import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/hrms_repository.dart';
import '../domain/hrms_domain_models.dart';
import '../domain/hrms_enums.dart';
import '../widgets/hrms_header.dart';
import '../widgets/hrms_metric_card.dart';
import '../widgets/hrms_data_table.dart';
import '../widgets/hrms_filter_bar.dart';
import '../widgets/hrms_status_badge.dart';
import '../widgets/travel_log_dialog.dart';

class HrmsTravelPage extends StatefulWidget {
  const HrmsTravelPage({super.key});

  @override
  State<HrmsTravelPage> createState() => _HrmsTravelPageState();
}

class _HrmsTravelPageState extends State<HrmsTravelPage> {
  final _repo = HrmsRepository();

  String _statusFilter = 'all';
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  List<FieldTravelRecord> get _filteredRecords {
    return _repo.travelRecords.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = r.employeeName.toLowerCase().contains(q) ||
            r.destinationName.toLowerCase().contains(q) ||
            r.purpose.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (_statusFilter == 'pending' && r.status != ApprovalStatus.pending) return false;
      if (_statusFilter == 'approved' && r.status != ApprovalStatus.approved) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.of(context).size.width < 768;

    final records = _filteredRecords;
    final totalRecords = records.length;
    final totalPages = (totalRecords / _pageSize).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _pageSize;
    final paged = records.skip(startIndex).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E14) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? AppSpacing.md : AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                HrmsHeader(
                  title: 'GPS Field Travel & Mileage Reimbursements',
                  subtitle: 'Automated distance calculation, departure/arrival photo verification & vehicle rate policy disbursal',
                  icon: Icons.add_road_rounded,
                  badgeText: 'GPS TRACKER ACTIVE',
                  badgeColor: const Color(0xFF3B82F6),
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () => TravelLogDialog.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                      label: Text('Log Field Trip', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Metrics
                _buildMetrics(context, isCompact),
                const SizedBox(height: AppSpacing.md),

                // Filter Bar
                HrmsFilterBar(
                  searchHint: 'Search trips by personnel name, site destination, or purpose...',
                  selectedFilter: _statusFilter,
                  onSearchChanged: (q) => setState(() {
                    _searchQuery = q;
                    _currentPage = 1;
                  }),
                  filterOptions: [
                    FilterOption(label: 'All Logs', value: 'all', count: _repo.travelRecords.length),
                    FilterOption(label: 'Pending Approval', value: 'pending', count: _repo.travelRecords.where((t) => t.status == ApprovalStatus.pending).length),
                    FilterOption(label: 'Approved & Cleared', value: 'approved', count: _repo.travelRecords.where((t) => t.status == ApprovalStatus.approved).length),
                  ],
                  onFilterSelected: (val) => setState(() {
                    _statusFilter = val;
                    _currentPage = 1;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Table
                _buildTravelTable(paged, totalRecords, totalPages, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, bool isCompact) {
    final all = _repo.travelRecords;
    final totalKm = all.fold<double>(0.0, (s, r) => s + r.distanceKm);
    final totalDisbursed = all.where((r) => r.status == ApprovalStatus.approved).fold<double>(0.0, (s, r) => s + r.totalAmount);
    final pendingCount = all.where((r) => r.status == ApprovalStatus.pending).length;
    final policy = _repo.policyConfig;

    final cards = [
      HrmsMetricCard(
        title: 'Total Distance Logged',
        value: '${totalKm.toStringAsFixed(1)} KM',
        subtitle: 'Across Luxury Sites',
        icon: Icons.directions_car_rounded,
        accentColor: const Color(0xFF3B82F6),
      ),
      HrmsMetricCard(
        title: 'Approved Reimbursement',
        value: '₹${totalDisbursed.toStringAsFixed(2)}',
        subtitle: 'Auto-Calculated from GPS',
        icon: Icons.payments_rounded,
        accentColor: const Color(0xFF10B981),
      ),
      HrmsMetricCard(
        title: 'Pending Approvals',
        value: '$pendingCount Claims',
        subtitle: 'Selfie Audit Required',
        icon: Icons.timelapse,
        accentColor: const Color(0xFFF59E0B),
      ),
      HrmsMetricCard(
        title: 'Mileage Policy Rates',
        value: '₹${policy.bikeMileageRatePerKm} / ₹${policy.carMileageRatePerKm}',
        subtitle: 'Two-Wheeler / Four-Wheeler',
        icon: Icons.policy_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
    ];

    if (isCompact) {
      return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _buildTravelTable(List<FieldTravelRecord> records, int totalRecords, int totalPages, bool isDark) {
    return HrmsDataTable(
      columns: const [
        HrmsDataColumn(title: 'FIELD PERSONNEL'),
        HrmsDataColumn(title: 'ROUTE (ORIGIN → DESTINATION)'),
        HrmsDataColumn(title: 'MODE & DISTANCE'),
        HrmsDataColumn(title: 'REIMBURSEMENT CLAIM'),
        HrmsDataColumn(title: 'VERIFICATION & STATUS'),
        HrmsDataColumn(title: 'ACTIONS', alignment: Alignment.centerRight),
      ],
      currentPage: _currentPage,
      totalPages: totalPages,
      totalRecords: totalRecords,
      onPageChanged: (p) => setState(() => _currentPage = p),
      rows: records.map((r) {
        return [
          // Personnel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(r.employeeName, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Text(r.employeeCode, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
            ],
          ),

          // Route
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${r.originName} → ${r.destinationName}',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                r.purpose,
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Mode & KM
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(r.travelMode.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${r.distanceKm} KM', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  Text('₹${r.ratePerKm}/km', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),

          // Total Claim
          Text(
            '₹${r.totalAmount.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
          ),

          // Verification & Status
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HrmsStatusBadge.approval(r.status),
              const SizedBox(width: 6),
              if (r.originSelfieUrl != null && r.arrivalSelfieUrl != null)
                const Tooltip(
                  message: 'Both departure and arrival selfies verified',
                  child: Icon(Icons.camera_alt, size: 14, color: Color(0xFF10B981)),
                ),
            ],
          ),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (r.status == ApprovalStatus.pending) ...[
                ElevatedButton(
                  onPressed: () {
                    _repo.updateTravelStatus(r.id, ApprovalStatus.approved, approvedBy: 'Finance Approver');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Travel claim for ${r.employeeName} approved!')),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text('Approve', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 4),
                OutlinedButton(
                  onPressed: () {
                    _repo.updateTravelStatus(r.id, ApprovalStatus.rejected, approvedBy: 'Finance Approver');
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('Reject', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFEF4444))),
                ),
              ] else
                Text(
                  'Cleared by ${r.approvedBy ?? "Manager"}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
            ],
          ),
        ];
      }).toList(),
    );
  }
}
