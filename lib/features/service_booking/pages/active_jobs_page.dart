import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/job_checkin_modal.dart';
import '../widgets/daily_work_update_modal.dart';
import '../widgets/work_verification_modal.dart';
import '../widgets/reassignment_modal.dart';

class ActiveJobsPage extends StatefulWidget {
  const ActiveJobsPage({super.key});

  @override
  State<ActiveJobsPage> createState() => _ActiveJobsPageState();
}

class _ActiveJobsPageState extends State<ActiveJobsPage> {
  final List<ServiceBooking> _jobs = List.from(LabourMockData.activeBookings);
  String _searchQuery = '';
  TradeType? _selectedTrade;
  bool? _filterDelayedOnly;
  String _statusFilter = 'All Active';

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    // Filter jobs
    var filtered = _jobs.where((job) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = job.bookingNumber.toLowerCase().contains(q) ||
            job.projectName.toLowerCase().contains(q) ||
            job.tradesmanName.toLowerCase().contains(q) ||
            job.workTitle.toLowerCase().contains(q) ||
            job.siteLocation.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedTrade != null && job.trade != _selectedTrade) return false;
      if (_filterDelayedOnly == true && !job.isDelayed) return false;
      if (_statusFilter == 'In Progress' && job.status != BookingStatus.inProgress) return false;
      if (_statusFilter == 'Checklist Signed' && job.status != BookingStatus.checklistSigned) return false;
      if (_statusFilter == 'Completed' && job.status != BookingStatus.completed) return false;
      return true;
    }).toList();

    final totalActive = _jobs.where((j) => j.status == BookingStatus.inProgress || j.status == BookingStatus.checklistSigned).length;
    final delayedCount = _jobs.where((j) => j.isDelayed).length;
    final awaitingVerificationCount = _jobs.where((j) => j.status == BookingStatus.checklistSigned).length;
    final checkedInCount = _jobs.where((j) => j.checkInRecord != null).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Active Field Jobs & Workforce Operations',
              subtitle: 'Operational control center for live site attendance, daily work logs, progress milestone sign-offs, and delay mitigations.',
              activeTab: 'Active Jobs',
              trailing: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Field GPS check-in ping dispatched to all active supervisors.')),
                  );
                },
                icon: const Icon(Icons.satellite_alt_rounded, size: 16),
                label: const Text('Live Geofence Audit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                  // Operational KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildJobKpi('Active Field Deployments', '$totalActive Jobs', 'Currently in execution', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildJobKpi('Geo-Checked In Today', '$checkedInCount Workers', 'Verified via biometric selfie', Icons.pin_drop_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildJobKpi('Delayed / At Risk', '$delayedCount Jobs', 'Requires supervisor mitigation', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildJobKpi('Awaiting Verification', '$awaitingVerificationCount Ready', 'Milestone completed on site', Icons.verified_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildJobKpi('Active Field Deployments', '$totalActive Jobs', 'Currently in execution', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildJobKpi('Geo-Checked In Today', '$checkedInCount Workers', 'Verified via biometric selfie', Icons.pin_drop_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildJobKpi('Delayed / At Risk', '$delayedCount Jobs', 'Requires supervisor mitigation', Icons.warning_amber_rounded, const Color(0xFFEF4444), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildJobKpi('Awaiting Verification', '$awaitingVerificationCount Ready', 'Milestone completed on site', Icons.verified_rounded, const Color(0xFF8B5CF6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Toolbar & Filter Controls
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search active job by ID, project name, tradesman, or site address...',
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
                              child: DropdownButtonFormField<TradeType?>(
                                initialValue: _selectedTrade,
                                decoration: InputDecoration(
                                  labelText: 'Trade',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Trades')),
                                  ...TradeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedTrade = val),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: _statusFilter,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'All Active', child: Text('All Active')),
                                  DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                  DropdownMenuItem(value: 'Checklist Signed', child: Text('Checklist Signed')),
                                  DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                ],
                                onChanged: (val) => setState(() => _statusFilter = val ?? 'All Active'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilterChip(
                              label: const Text('Delayed Only'),
                              avatar: const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                              selected: _filterDelayedOnly == true,
                              onSelected: (val) => setState(() => _filterDelayedOnly = val ? true : null),
                              selectedColor: Colors.red.withValues(alpha: 0.15),
                              checkmarkColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Results Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Work Orders (${filtered.length})',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimaryColor),
                      ),
                      const Text(
                        'GPS Geo-fencing & Daily Checklist Enforcement Active',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main Active Jobs Table
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 20,
                        columnSpacing: 22,
                        headingRowColor: WidgetStatePropertyAll(surfaceColor),
                        columns: const [
                          DataColumn(label: Text('Job & Project', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Tradesman', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Progress', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Check-In Status', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Schedule Status', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Supervisor', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Stage Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                        ],
                        rows: filtered.map((job) {
                          return DataRow(
                            cells: [
                              // Job & Project
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(job.bookingNumber, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimaryColor)),
                                    Text(job.projectName, style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                    Text(job.workTitle, style: const TextStyle(fontSize: 10, color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              // Tradesman
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(job.trade.icon, size: 14, color: job.trade.color),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(job.tradesmanName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimaryColor)),
                                        Text('${job.tradesmenCount} workers deployed', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Progress Bar
                              DataCell(
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${job.progressPercent.toInt()}%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: textPrimaryColor)),
                                          Text('${job.dailyChecklist.where((i) => i.isCompleted).length}/${job.dailyChecklist.length} Items', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: job.progressPercent / 100.0,
                                          backgroundColor: borderColor,
                                          color: job.isDelayed ? Colors.red : (job.progressPercent >= 100 ? const Color(0xFF10B981) : AppColors.primary),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Check-In Status
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      job.checkInRecord != null ? Icons.check_circle_rounded : Icons.pending_rounded,
                                      size: 14,
                                      color: job.checkInRecord != null ? const Color(0xFF10B981) : Colors.amber,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      job.checkInRecord != null ? 'Checked In' : 'Pending',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: job.checkInRecord != null ? const Color(0xFF10B981) : Colors.amber.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Schedule Status / Delay Badge
                              DataCell(
                                job.isDelayed
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.warning_amber_rounded, size: 13, color: Colors.red),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Delayed (${job.delayDays}d)',
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'On Schedule',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                                        ),
                                      ),
                              ),
                              // Supervisor
                              DataCell(Text(job.supervisorName.split('(').first.trim(), style: TextStyle(fontSize: 11, color: textPrimaryColor))),
                              // Stage Actions
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 1. Check-In Button
                                    OutlinedButton.icon(
                                      onPressed: () => _openCheckInModal(context, job),
                                      icon: const Icon(Icons.touch_app_outlined, size: 14),
                                      label: const Text('Check In'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // 2. Daily Log Button
                                    OutlinedButton.icon(
                                      onPressed: () => _openDailyUpdateModal(context, job),
                                      icon: const Icon(Icons.edit_note_rounded, size: 14),
                                      label: const Text('Daily Log'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // 3. Supervisor Verify Button
                                    ElevatedButton.icon(
                                      onPressed: () => _openVerificationModal(context, job),
                                      icon: const Icon(Icons.fact_check_rounded, size: 14),
                                      label: const Text('Verify Work'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // 4. Reassign if Delayed
                                    if (job.isDelayed)
                                      IconButton(
                                        tooltip: 'Reassign Worker (Preserve History)',
                                        icon: const Icon(Icons.swap_horiz_rounded, color: Colors.orange, size: 20),
                                        onPressed: () => _openReassignModal(context, job),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
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

  Widget _buildJobKpi(String title, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCheckInModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => JobCheckInModal(
        booking: booking,
        onCheckInCompleted: (checkIn) {
          setState(() {
            final idx = _jobs.indexWhere((j) => j.id == booking.id);
            if (idx != -1) {
              _jobs[idx] = booking.copyWith(
                checkInRecord: checkIn,
                activeJobStatus: ActiveJobStatus.checkedIn,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Site Check-in confirmed for ${booking.tradesmanName} on ${booking.projectName}')),
          );
        },
      ),
    );
  }

  void _openDailyUpdateModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => DailyWorkUpdateModal(
        booking: booking,
        onUpdateSubmitted: (update) {
          setState(() {
            final idx = _jobs.indexWhere((j) => j.id == booking.id);
            if (idx != -1) {
              final updatedList = List<DailyWorkUpdate>.from(booking.dailyUpdates)..insert(0, update);
              _jobs[idx] = booking.copyWith(
                progressPercent: update.progressPercentage,
                dailyUpdates: updatedList,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Daily work update logged: ${update.hoursWorked} hrs recorded.')),
          );
        },
      ),
    );
  }

  void _openVerificationModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => WorkVerificationModal(
        booking: booking,
        onVerified: (verification, newStatus) {
          setState(() {
            final idx = _jobs.indexWhere((j) => j.id == booking.id);
            if (idx != -1) {
              _jobs[idx] = booking.copyWith(
                workVerification: verification,
                status: newStatus,
                activeJobStatus: newStatus == BookingStatus.completed ? ActiveJobStatus.completed : ActiveJobStatus.inProgress,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Work verification recorded: ${verification.status}')),
          );
        },
      ),
    );
  }

  void _openReassignModal(BuildContext context, ServiceBooking booking) {
    showDialog(
      context: context,
      builder: (ctx) => ReassignmentModal(
        booking: booking,
        onReassigned: (reassignmentRecord, replacementWorker) {
          setState(() {
            final idx = _jobs.indexWhere((j) => j.id == booking.id);
            if (idx != -1) {
              final history = List<ReassignmentRecord>.from(booking.reassignmentHistory)..add(reassignmentRecord);
              _jobs[idx] = booking.copyWith(
                tradesmanId: replacementWorker.id,
                tradesmanName: replacementWorker.legalName,
                tradesmanPhone: replacementWorker.phone,
                reassignmentHistory: history,
                isDelayed: false,
                delayDays: 0,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job reassigned to ${replacementWorker.legalName}. Historical log preserved.')),
          );
        },
      ),
    );
  }
}
