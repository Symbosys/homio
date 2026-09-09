import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/labour_models.dart';
import '../models/labour_mock_data.dart';
import '../widgets/service_booking_header.dart';
import '../widgets/labour_profile_drawer.dart';

class LabourAvailabilityPage extends StatefulWidget {
  const LabourAvailabilityPage({super.key});

  @override
  State<LabourAvailabilityPage> createState() => _LabourAvailabilityPageState();
}

class _LabourAvailabilityPageState extends State<LabourAvailabilityPage> {
  final List<LabourProfile> _workers = List.from(LabourMockData.profiles);
  String _selectedDay = 'All Days';
  LabourStatus? _selectedStatusFilter;
  TradeType? _selectedTrade;
  String _searchQuery = '';
  LabourProfile? _activeWorker;

  final List<String> _daysOfWeek = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    if (_workers.isNotEmpty) {
      _activeWorker = _workers.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final backgroundColor = AppColors.getBackground(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimaryColor = AppColors.getTextPrimary(context);
    final textSecondaryColor = AppColors.getTextSecondary(context);
    final textMutedColor = AppColors.getTextMuted(context);

    // Filter workers
    var filtered = _workers.where((w) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = w.legalName.toLowerCase().contains(q) ||
            w.id.toLowerCase().contains(q) ||
            w.trade.label.toLowerCase().contains(q) ||
            w.city.toLowerCase().contains(q);
        if (!matches) return false;
      }
      if (_selectedTrade != null && w.trade != _selectedTrade) return false;
      if (_selectedStatusFilter != null && w.labourStatus != _selectedStatusFilter) return false;
      return true;
    }).toList();

    final availableNowCount = _workers.where((w) => w.labourStatus == LabourStatus.available).length;
    final onSiteCount = _workers.where((w) => w.labourStatus == LabourStatus.onSite).length;
    final onLeaveCount = _workers.where((w) => w.labourStatus == LabourStatus.onLeave).length;
    final bookedCount = _workers.where((w) => w.labourStatus == LabourStatus.booked).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ServiceBookingHeader(
              title: 'Workforce Availability & Shift Scheduling',
              subtitle: 'Real-time calendar availability, weekly shift allocations, travel radius limits, and on-demand dispatch readiness.',
              activeTab: 'Availability & Shifts',
              trailing: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shift roster synchronization triggered across all field devices.')),
                  );
                },
                icon: const Icon(Icons.sync_rounded, size: 16),
                label: const Text('Sync Shift Roster'),
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
                  // KPI Scoreboard
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 900;
                      if (isNarrow) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildKpiBox('Available Today', '$availableNowCount Workers', 'Ready for instant dispatch', Icons.check_circle_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiBox('Active on Site', '$onSiteCount Deployed', 'Engaged in ongoing jobs', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiBox('Pre-Booked', '$bookedCount Scheduled', 'Allocated for upcoming slots', Icons.calendar_today_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                            _buildKpiBox('On Leave / Absent', '$onLeaveCount Unavailable', 'Leave requests registered', Icons.beach_access_rounded, const Color(0xFF64748B), surfaceColor, borderColor, textPrimaryColor, textMutedColor),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildKpiBox('Available Today', '$availableNowCount Workers', 'Ready for instant dispatch', Icons.check_circle_rounded, const Color(0xFF10B981), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiBox('Active on Site', '$onSiteCount Deployed', 'Engaged in ongoing jobs', Icons.engineering_rounded, const Color(0xFF3B82F6), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiBox('Pre-Booked', '$bookedCount Scheduled', 'Allocated for upcoming slots', Icons.calendar_today_rounded, const Color(0xFFF59E0B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildKpiBox('On Leave / Absent', '$onLeaveCount Unavailable', 'Leave requests registered', Icons.beach_access_rounded, const Color(0xFF64748B), surfaceColor, borderColor, textPrimaryColor, textMutedColor)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Filter & Search Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: 'Search by worker name, trade, zone, or city...',
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
                              child: DropdownButtonFormField<LabourStatus?>(
                                initialValue: _selectedStatusFilter,
                                decoration: InputDecoration(
                                  labelText: 'Status Filter',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: backgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Availability')),
                                  ...LabourStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                                ],
                                onChanged: (val) => setState(() => _selectedStatusFilter = val),
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
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Day Selector Strip
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: const Text('All Days'),
                                selected: _selectedDay == 'All Days',
                                onSelected: (_) => setState(() => _selectedDay = 'All Days'),
                                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                              ),
                              const SizedBox(width: 8),
                              ..._daysOfWeek.map((day) {
                                final isSelected = _selectedDay == day;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(day),
                                    selected: isSelected,
                                    onSelected: (_) => setState(() => _selectedDay = isSelected ? 'All Days' : day),
                                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Master-Detail Split: Left Worker Roster Table, Right Schedule & Radius Inspector
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Workforce Table
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Workforce Schedule Ledger (${filtered.length})',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimaryColor),
                                    ),
                                    Text('Tap worker to inspect shift', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: borderColor),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
                                itemBuilder: (context, index) {
                                  final worker = filtered[index];
                                  final isSelected = _activeWorker?.id == worker.id;

                                  return InkWell(
                                    onTap: () => setState(() => _activeWorker = worker),
                                    child: Container(
                                      color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              worker.photoUrl,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 28),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(worker.legalName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimaryColor)),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: worker.trade.color.withValues(alpha: 0.12),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(worker.trade.label.split('&').first.trim(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: worker.trade.color)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text('${worker.city} (${worker.zone}) • Max Radius: ${worker.preferredRadiusKm.toInt()} km', style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                                              ],
                                            ),
                                          ),
                                          // Status Dropdown
                                          DropdownButton<LabourStatus>(
                                            value: worker.labourStatus,
                                            underline: const SizedBox(),
                                            items: LabourStatus.values.map((s) {
                                              return DropdownMenuItem(
                                                value: s,
                                                child: Row(
                                                  children: [
                                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                                                    const SizedBox(width: 6),
                                                    Text(s.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s.color)),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newStatus) {
                                              if (newStatus != null) {
                                                setState(() {
                                                  final idx = _workers.indexWhere((w) => w.id == worker.id);
                                                  if (idx != -1) {
                                                    _workers[idx] = worker.copyWith(labourStatus: newStatus);
                                                    if (_activeWorker?.id == worker.id) {
                                                      _activeWorker = _workers[idx];
                                                    }
                                                  }
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Updated ${worker.legalName}\'s availability to ${newStatus.label}')),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),

                      // Right: Detailed Shift & Location Radius Inspector
                      Expanded(
                        flex: 5,
                        child: _activeWorker == null
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('WEEKLY SHIFT CALENDAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: textSecondaryColor)),
                                        IconButton(
                                          tooltip: 'View Full Dossier',
                                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                                          onPressed: () => _openProfileDrawer(context, _activeWorker!),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _activeWorker!.legalName,
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimaryColor),
                                    ),
                                    Text('${_activeWorker!.trade.label} • Standard: 09:00 AM - 06:00 PM', style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                                    const SizedBox(height: 16),

                                    // Weekday Table
                                    ..._daysOfWeek.map((day) {
                                      final isSunday = day == 'Sunday';
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: borderColor),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  !isSunday ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                                  size: 16,
                                                  color: !isSunday ? const Color(0xFF10B981) : Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimaryColor)),
                                              ],
                                            ),
                                            Text(
                                              !isSunday ? '09:00 AM - 06:00 PM (Full Day)' : 'Weekly Off',
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: !isSunday ? textPrimaryColor : textSecondaryColor),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 16),

                                    // Location & Travel Radius Box
                                    Text('OPERATING RADIUS & LOGISTICS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6, color: textSecondaryColor)),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildInfoRow('Home Base:', _activeWorker!.city, textPrimaryColor, textSecondaryColor),
                                          const SizedBox(height: 6),
                                          _buildInfoRow('Operating Zones:', _activeWorker!.zone, textPrimaryColor, textSecondaryColor),
                                          const SizedBox(height: 6),
                                          _buildInfoRow('Max Travel Distance:', '${_activeWorker!.preferredRadiusKm.toInt()} km radius', const Color(0xFF10B981), textSecondaryColor),
                                          const SizedBox(height: 6),
                                          _buildInfoRow('Travel Allowance:', '₹${_activeWorker!.travelCharge.toInt()} / day', textPrimaryColor, textSecondaryColor),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Action: Mark Temporary Leave
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            final idx = _workers.indexWhere((w) => w.id == _activeWorker!.id);
                                            if (idx != -1) {
                                              _workers[idx] = _activeWorker!.copyWith(labourStatus: LabourStatus.onLeave);
                                              _activeWorker = _workers[idx];
                                            }
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Marked ${_activeWorker!.legalName} on leave.')),
                                          );
                                        },
                                        icon: const Icon(Icons.event_busy_rounded, size: 16),
                                        label: const Text('Log Leave / Blackout Dates'),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiBox(String title, String value, String subtitle, IconData icon, Color color, Color bg, Color border, Color textPrimary, Color textMuted) {
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

  Widget _buildInfoRow(String label, String value, Color textColor, Color labelColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: labelColor)),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor), textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  void _openProfileDrawer(BuildContext context, LabourProfile worker) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ProfileDrawer',
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: LabourProfileDrawer(worker: worker),
        );
      },
    );
  }
}
